//
//  LockViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 26/10/23.
//

import Foundation
import UIKit
import LocalAuthentication

public enum LocalAuthBiometricAuthentication {
    case touchId
    case faceId
}

public struct LocalAuth {
    
    public static let biometricAuthentication: LocalAuthBiometricAuthentication? = {
        let context = LAContext()
        if context.canEvaluatePolicy(LAPolicy(rawValue: Int(kLAPolicyDeviceOwnerAuthenticationWithBiometrics))!, error: nil) {
            if #available(iOSApplicationExtension 11.0, iOS 11.0, *) {
                switch context.biometryType {
                case .faceID:
                    return .faceId
                case .touchID:
                    return .touchId
                default:
                    return nil
                }
            } else {
                return .touchId
            }
        } else {
            return nil
        }
    }()
    
    public static let evaluatedPolicyDomainState: Data? = {
        let context = LAContext()
        if context.canEvaluatePolicy(LAPolicy(rawValue: Int(kLAPolicyDeviceOwnerAuthenticationWithBiometrics))!, error: nil) {
            if #available(iOSApplicationExtension 9.0, iOS 9.0, *) {
                return context.evaluatedPolicyDomainState
            } else {
                return Data()
            }
        }
        return nil
    }()
    
    public static func auth(reason: String, completion: @escaping (_ result: Bool, _ data: Data?) -> Void) {
        let context = LAContext()
        context.localizedCancelTitle = "PASSCODE_ENTER".localized
        if LAContext().canEvaluatePolicy(LAPolicy(rawValue: Int(kLAPolicyDeviceOwnerAuthenticationWithBiometrics))!, error: nil) {
            context.evaluatePolicy(LAPolicy(rawValue: Int(kLAPolicyDeviceOwnerAuthenticationWithBiometrics))!, localizedReason: reason, reply: { result, _ in
                let evaluatedPolicyDomainState: Data?
                if #available(iOSApplicationExtension 9.0, iOS 9.0, *) {
                    evaluatedPolicyDomainState = context.evaluatedPolicyDomainState
                } else {
                    evaluatedPolicyDomainState = Data()
                }
                completion(result, evaluatedPolicyDomainState)
                if #available(iOSApplicationExtension 9.0, iOS 9.0, *) {
                    context.invalidate()
                }
            })
        } else {
            if #available(iOSApplicationExtension 9.0, iOS 9.0, *) {
                context.invalidate()
            }
            completion(false, nil)
        }
    }
}

class PasscodeViewController: BaseViewController, KeyPadViewDelegate {
    
    let avatarView: AvatarImageView = {
        let view = AvatarImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(name: .main_logo)
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        return view
    }()
    let label: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = UIFont.bold(size: 20)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "ENTER_PIN".localized
        view.textAlignment = .center
        view.textColor = Theme.current.primaryTextColor
        return view
    }()
    let passcodeDotView: PasswordDotView = {
        let view = PasswordDotView()
        view.fillColor = Theme.current.primaryTextColor
        view.strokeColor = Theme.current.primaryTextColor
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let timerHint: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 14)
        view.textColor = Theme.current.secondaryTextColor
        view.text = "PASSCODE_TRY_MIN".localized
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.textAlignment = .center
        return view
    }()
    let keyPadView: KeyPadView = {
        let view = KeyPadView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    weak var coordinator: PasscodeCoordinator?
    let hapticFeedback = HapticFeedback()
    let viewModel: PasscodeViewModel
    let waitInterval: Int32 = 60
    var newBioData: Data? = nil
    var timer: Timer? = nil
    var hiddenDigits = ["*", "#"]
    let validDigitsSet: CharacterSet = {
        return CharacterSet(charactersIn: "0".unicodeScalars.first! ... "9".unicodeScalars.first!)
    }()
    var dialedNumbersDisplayString = "" {
        didSet {
            let text = self.dialedNumbersDisplayString
            self.passcodeDotView.inputDotCount = text.count
        }
    }
    var hashButtonImage: UIImage? = nil
    
    init(viewModel: PasscodeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.current.plainTableBackColor
        var authWithBio: Bool = false
        if let a = LocalAuth.biometricAuthentication, Constants.DeviceBio {
            if a == .faceId {
                self.hashButtonImage = UIImage(name: .face_icon)
            } else {
                self.hashButtonImage = UIImage(name: .touch_icon)
            }
            self.keyPadView.hashButtonImage = self.hashButtonImage
            authWithBio = true
        }
        self.keyPadView.starButtonText = "ENTER_PIN_HINT".localized
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.avatarView)
        self.view.addSubview(self.label)
        self.view.addSubview(self.passcodeDotView)
        self.view.addSubview(self.timerHint)
        self.view.addSubview(self.keyPadView)
        NSLayoutConstraint.activate([
            self.avatarView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.avatarView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIApplication.statusBarHeight + 44 + 50),
            self.avatarView.heightAnchor.constraint(equalToConstant: 80),
            self.avatarView.widthAnchor.constraint(equalToConstant: 80),
            self.label.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 27),
            self.label.topAnchor.constraint(equalTo: self.avatarView.bottomAnchor, constant: 30),
            self.label.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -27),
            self.passcodeDotView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 27),
            self.passcodeDotView.topAnchor.constraint(equalTo: self.label.bottomAnchor, constant: 40),
            self.passcodeDotView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -27),
            self.passcodeDotView.heightAnchor.constraint(equalToConstant: 20),
            self.timerHint.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 27),
            self.timerHint.topAnchor.constraint(equalTo: self.passcodeDotView.bottomAnchor, constant: 20),
            self.timerHint.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -27),
            self.keyPadView.topAnchor.constraint(greaterThanOrEqualTo: self.timerHint.bottomAnchor, constant: 20),
            self.keyPadView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            self.keyPadView.heightAnchor.constraint(equalTo: self.keyPadView.widthAnchor, multiplier: 0.9),
            self.keyPadView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
            self.keyPadView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        self.passcodeDotView.totalDotCount = self.viewModel.account.pin?.count ?? 4
        self.passcodeDotView.inputDotCount = 0
        self.keyPadView.delegate = self
        self.updateInvalidAttempts()
        self.viewModel.didLogin.subscribe(onNext: { [weak self] info in
            self?.hideProgressView()
            self?.coordinator?.authSuccess(accountInfo: info)
        }).disposed(by: self.viewModel.disposeBag)
        self.viewModel.didLoginFailed.subscribe(onNext: { [weak self] message in
            self?.hideProgressView()
            self?.showErrorAlert(title: "ERROR".localized, message: message)
        }).disposed(by: self.viewModel.disposeBag)
        if authWithBio {
            self.auth()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func keyTapped(digit: String) {
        if digit == "." {
            self.coordinator?.navigateToResetPasscode()
        } else if digit == "<" {
            if self.dialedNumbersDisplayString.isEmpty {
                self.auth()
            } else {
                self.hapticFeedback.tap()
                self.dialedNumbersDisplayString = String(self.dialedNumbersDisplayString.dropLast())
            }
            self.passcodeDotView.inputDotCount = self.dialedNumbersDisplayString.count
        } else {
            let text = self.dialedNumbersDisplayString + digit
            if text.count > self.viewModel.account.pin?.count ?? 4 {
                return
            }
            if let _ = text.rangeOfCharacter(from: self.validDigitsSet.inverted) {
                return
            }
            if self.shouldWaitBeforeNextAttempt() {
                self.passcodeDotView.shakeAnimate()
                self.hapticFeedback.error()
                self.dialedNumbersDisplayString = ""
                self.passcodeDotView.inputDotCount = 0
            } else {
                self.dialedNumbersDisplayString += digit
                self.passcodeDotView.inputDotCount = text.count
                if text.count == self.viewModel.account.pin?.count ?? 4 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.checkPasscode(str: self.dialedNumbersDisplayString)
                    }
                }
            }
        }
        if self.dialedNumbersDisplayString.isEmpty {
            self.keyPadView.updateHashButtonImage(image: UIImage(name: .face_icon))
        } else {
            self.keyPadView.updateHashButtonImage(image: nil)
        }
    }
    
    private func shouldWaitBeforeNextAttempt() -> Bool {
        if let attempts = self.viewModel.account.lockState.unlockAttemts {
            if attempts.count >= 6 {
                var bootTimestamp: Int32 = 0
                let uptime = self.getDeviceUptimeSeconds(&bootTimestamp)
                if attempts.timestamp.bootTimestamp != bootTimestamp {
                    return true
                }
                if Int32(uptime) - attempts.timestamp.uptime < self.waitInterval {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func getDeviceUptimeSeconds(_ bootTime: inout Int32) -> time_t {
        var boottime = timeval()
        var mib: [Int32] = [CTL_KERN, KERN_BOOTTIME]
        var size = MemoryLayout<timeval>.stride
        var now = time_t()
        var uptime: time_t = -1
        time(&now)
        if (sysctl(&mib, 2, &boottime, &size, nil, 0) != -1 && boottime.tv_sec != 0) {
            uptime = now - boottime.tv_sec
            bootTime = Int32(boottime.tv_sec)
        }
        return uptime
    }
    
    public func unlock() {
        self.viewModel.account.lockState.unlockAttemts = nil
        self.viewModel.account.lockState.isManuallyLocked = false
        var bootTimestamp: Int32 = 0
        let uptime = self.getDeviceUptimeSeconds(&bootTimestamp)
        let timestamp = MonotonicTimestamp(bootTimestamp: bootTimestamp, uptime: Int32(uptime))
        self.viewModel.account.lockState.applicationActivityTimestamp = timestamp
        self.viewModel.updateLockState(state: self.viewModel.account.lockState)
        self.showProgressView()
        self.dialedNumbersDisplayString = ""
        self.passcodeDotView.inputDotCount = 0
        self.viewModel.pinChechSuccess()
    }
    
    public func failedUnlockAttempt() {
        var unlockAttemts = self.viewModel.account.lockState.unlockAttemts ?? UnlockAttempts(count: 0, timestamp: MonotonicTimestamp(bootTimestamp: 0, uptime: 0))
        unlockAttemts.count += 1
        var bootTimestamp: Int32 = 0
        let uptime = self.getDeviceUptimeSeconds(&bootTimestamp)
        let timestamp = MonotonicTimestamp(bootTimestamp: bootTimestamp, uptime: Int32(uptime))
        unlockAttemts.timestamp = timestamp
        self.viewModel.account.lockState.unlockAttemts = unlockAttemts
        self.viewModel.updateLockState(state: self.viewModel.account.lockState)
        self.updateInvalidAttempts()
    }
    
    func updateInvalidAttempts() {
        if let unlockAttemts = self.viewModel.account.lockState.unlockAttemts {
            if unlockAttemts.count >= 6 && self.shouldWaitBeforeNextAttempt() {
                self.timerHint.isHidden = false
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
                    guard let local = self else { return }
                    if !local.shouldWaitBeforeNextAttempt() {
                        local.updateInvalidAttempts()
                        local.timer?.invalidate()
                        local.timer = nil
                    }
                })
            } else {
                self.timerHint.isHidden = true
            }
        } else {
            self.timerHint.isHidden = true
        }
    }
    
    public func checkPasscode(str: String) {
        if self.shouldWaitBeforeNextAttempt() {
            self.passcodeDotView.shakeAnimate()
            self.hapticFeedback.error()
            self.dialedNumbersDisplayString = ""
            self.passcodeDotView.inputDotCount = 0
        } else {
            if self.viewModel.account.pin == str {
                if let newBioData = self.newBioData {
                    Constants.DeviceBioData = newBioData
                }
                self.unlock()
            } else {
                self.failedUnlockAttempt()
                self.passcodeDotView.shakeAnimate()
                self.hapticFeedback.error()
                self.dialedNumbersDisplayString = ""
                self.passcodeDotView.inputDotCount = 0
            }
        }
    }
    
    func auth() {
        LocalAuth.auth(reason: "PASSCODE_BIO_HELP".localizedFormat(arguments: Constants.AppName)) { res, data in
            if res {
                DispatchQueue.main.async {
                    guard let newData = data else {
                        self.passcodeDotView.inputDotCount = self.viewModel.account.pin?.count ?? 0
                        self.unlock()
                        return
                    }
                    if let old = Constants.DeviceBioData {
                        if old == newData {
                            self.unlock()
                        } else {
                            self.newBioData = LocalAuth.evaluatedPolicyDomainState
                        }
                    } else {
                        Constants.DeviceBioData = LocalAuth.evaluatedPolicyDomainState
                        self.unlock()
                    }
                }
            }
        }
    }
}
