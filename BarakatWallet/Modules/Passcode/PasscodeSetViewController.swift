//
//  SetPinViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 22/10/23.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

extension UITextInput {
    var selectedRange: NSRange? {
        guard let range = selectedTextRange else { return nil }
        let location = offset(from: beginningOfDocument, to: range.start)
        let length = offset(from: range.start, to: range.end)
        return NSRange(location: location, length: length)
    }
}

class PasscodeSetViewController: BaseViewController, KeyPadViewDelegate, BioAuthViewControllerDelegate, VerifyCodeViewControllerDelegate {
    
    let backButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(name: .back_arrow), for: .normal)
        view.tintColor = Theme.current.primaryTextColor
        view.isHidden = false
        return view
    }()
    let label: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = UIFont.bold(size: 22)
        view.textColor = Theme.current.tintColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "ENTER_PIN".localized
        view.numberOfLines = 0
        return view
    }()
    let numberHint: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 16)
        view.textColor = Theme.current.primaryTextColor
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.text = "ENTER_PIN_MIN".localized
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
        view.text = "ENTER_PIN_HINT".localized
        view.numberOfLines = 0
        view.isHidden = true
        view.lineBreakMode = .byWordWrapping
        view.textAlignment = .center
        return view
    }()
    let keyPadView: KeyPadView = {
        let view = KeyPadView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let continueButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.radius = 14
        view.setTitle("CONTINUE".localized, for: .normal)
        view.isEnabled = false
        return view
    }()
    let validDigitsSet: CharacterSet = {
        return CharacterSet(charactersIn: "0".unicodeScalars.first! ... "9".unicodeScalars.first!)
    }()
    var dialedNumbersDisplayString = "" {
        didSet {
            let text = self.dialedNumbersDisplayString
            self.passcodeDotView.inputDotCount = text.count
        }
    }
    weak var coordinator: PasscodeCoordinator?
    let hapticFeedback = HapticFeedback()
    let viewModel: PasscodeViewModel
    
    init(viewModel: PasscodeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.setStatusBarStyle(dark: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.label)
        self.view.addSubview(self.numberHint)
        self.view.addSubview(self.passcodeDotView)
        self.view.addSubview(self.timerHint)
        self.view.addSubview(self.keyPadView)
        self.view.addSubview(self.continueButton)
        NSLayoutConstraint.activate([
            self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24),
            self.backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIApplication.statusBarHeight + 10),
            self.backButton.heightAnchor.constraint(equalToConstant: 28),
            self.backButton.widthAnchor.constraint(equalToConstant: 28),
            self.label.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 27),
            self.label.topAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            self.label.rightAnchor.constraint(lessThanOrEqualTo: self.view.rightAnchor, constant: -27),
            self.numberHint.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 27),
            self.numberHint.topAnchor.constraint(equalTo: self.label.bottomAnchor, constant: 48),
            self.numberHint.rightAnchor.constraint(lessThanOrEqualTo: self.view.rightAnchor, constant: -27),
            self.passcodeDotView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 27),
            self.passcodeDotView.topAnchor.constraint(equalTo: self.numberHint.bottomAnchor, constant: 28),
            self.passcodeDotView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -27),
            self.passcodeDotView.heightAnchor.constraint(equalToConstant: 24),
            self.timerHint.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 27),
            self.timerHint.topAnchor.constraint(equalTo: self.passcodeDotView.bottomAnchor, constant: 20),
            self.timerHint.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -27),
            self.keyPadView.topAnchor.constraint(equalTo: self.timerHint.bottomAnchor, constant: 20),
            self.keyPadView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            self.keyPadView.heightAnchor.constraint(equalTo: self.keyPadView.widthAnchor, multiplier: 1.2),
            self.keyPadView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            self.continueButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 27),
            self.continueButton.topAnchor.constraint(equalTo: self.keyPadView.bottomAnchor, constant: 10),
            self.continueButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -27),
            self.continueButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            self.continueButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
        ])
        self.keyPadView.delegate = self
        self.passcodeDotView.totalDotCount = self.viewModel.passcodeMinLength
        self.passcodeDotView.inputDotCount = 0
        self.backButton.rx.tap.subscribe { [weak self] _ in
            if let coo = self?.coordinator {
                coo.navigateBack()
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }.disposed(by: self.viewModel.disposeBag)
        self.continueButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.next(text: self.dialedNumbersDisplayString)
        }.disposed(by: self.viewModel.disposeBag)
        self.viewModel.didLogin.subscribe(onNext: { [weak self] info in
            self?.hideProgressView()
            self?.showBioAuth(accountInfo: info)
        }).disposed(by: self.viewModel.disposeBag)
        self.viewModel.didLoginFailed.subscribe(onNext: { [weak self] message in
            self?.hideProgressView()
            self?.showErrorAlert(title: "ERROR".localized, message: message)
        }).disposed(by: self.viewModel.disposeBag)
        self.setInfo()
    }
    
    func keyTapped(digit: String) {
        if digit == "." {
            switch self.viewModel.startFor {
            case .setup(let key, let exist, let w):
                if exist {
                    self.coordinator?.navigateToResetPasscode(key: key, wallet: w)
                }
            case .change(let acc):
                switch self.viewModel.setupStep {
                case .check:
                    self.coordinator?.navigateToResetPasscode(key: acc.getKey() ?? "", wallet: acc.wallet)
                case .first:break
                case .second(_):break
                }
            }
        } else {
            self.hapticFeedback.tap()
            var text = self.dialedNumbersDisplayString
            if digit == "<" {
                if !text.isEmpty {
                    text = String(text.dropLast())
                }
            } else {
                text = text + digit
            }
            if let _ = text.rangeOfCharacter(from: self.validDigitsSet.inverted) {
                return
            }
            switch self.viewModel.startFor {
            case .setup(_, _, _):
                switch self.viewModel.setupStep {
                case .check, .first:
                    if text.count > self.viewModel.passcodeMaxLength {
                        return
                    }
                    self.passcodeDotView.totalDotCount = max(self.viewModel.passcodeMinLength, text.count)
                case .second(new: let new):
                    if text.count > new.count {
                        return
                    }
                }
            case .change(let old):
                switch self.viewModel.setupStep {
                case .check:
                    if text.count > String(old.pin).count {
                        return
                    }
                case .first:
                    if text.count > self.viewModel.passcodeMaxLength {
                        return
                    }
                    self.passcodeDotView.totalDotCount = max(self.viewModel.passcodeMinLength, text.count)
                case .second(let new):
                    if text.count > new.count {
                        return
                    }
                }
            }
            self.dialedNumbersDisplayString = text
            self.passcodeDotView.inputDotCount = text.count
            self.continueButton.isEnabled = self.dialedNumbersDisplayString.count >= self.viewModel.passcodeMinLength && self.dialedNumbersDisplayString.count <= self.viewModel.passcodeMaxLength
        }
    }
    
    func setInfo() {
        switch self.viewModel.startFor {
        case .setup(_, let exist, _):
            self.dialedNumbersDisplayString = ""
            self.passcodeDotView.totalDotCount = 4
            self.passcodeDotView.inputDotCount = 0
            if exist {
                self.label.text = "ENTER_PIN".localized
                self.keyPadView.starButtonText = "ENTER_PIN_HINT".localized
            } else {
                self.label.text = "PASSCODE_GEN".localized
            }
        case .change(let old):
            self.keyPadView.starButtonText = "ENTER_PIN_HINT".localized
            self.dialedNumbersDisplayString = ""
            self.passcodeDotView.totalDotCount = String(old.pin).count
            self.passcodeDotView.inputDotCount = 0
            self.label.text = "PASSCODE_OLD_ENTER".localized
        }
    }
    
    func next(text: String) {
        switch self.viewModel.startFor {
        case .change(let old):
            switch self.viewModel.setupStep {
            case .check:
                if String(old.pin) == text {
                    self.keyPadView.starButtonText = nil
                    self.keyPadView.collection.reloadData()
                    self.viewModel.setupStep = .first
                    self.passcodeDotView.slideInFromLeft()
                    self.label.slideInFromLeft()
                    self.passcodeDotView.totalDotCount = 4
                    self.passcodeDotView.inputDotCount = 0
                    self.dialedNumbersDisplayString = ""
                    self.label.text = "PASSCODE_ENTER_NEW".localized
                } else {
                    self.passcodeDotView.shakeAnimate()
                    self.passcodeDotView.totalDotCount = String(old.pin).count
                    self.passcodeDotView.inputDotCount = 0
                    self.dialedNumbersDisplayString = ""
                    self.label.text = "PASSCODE_OLD_ENTER".localized
                }
            case .first:
                self.viewModel.setupStep = .second(new: text)
                self.passcodeDotView.slideInFromLeft()
                self.label.slideInFromLeft()
                self.dialedNumbersDisplayString = ""
                self.passcodeDotView.totalDotCount = text.count
                self.passcodeDotView.inputDotCount = 0
                self.label.text = "PASSCODE_RENTER".localized
            case .second(let new):
                if new == text {
                    self.changePin(key: old.getKey() ?? "")
                } else {
                    self.viewModel.setupStep = .first
                    self.passcodeDotView.slideInFromLeft()
                    self.label.slideInFromLeft()
                    self.dialedNumbersDisplayString = ""
                    self.passcodeDotView.totalDotCount = 4
                    self.passcodeDotView.inputDotCount = 0
                    self.label.text = "PASSCODE_ENTER_NEW".localized
                    self.showErrorAlert(title: "ERROR".localized, message: "PASSCODE_DONT_MATCH".localized)
                }
            }
        case .setup(let key, let exist, let wallet):
            if exist {
                let digits = self.dialedNumbersDisplayString.digits
                guard digits.count >= self.viewModel.passcodeMinLength, digits.count <= self.viewModel.passcodeMaxLength else { return }
                self.showProgressView()
                self.viewModel.checkPin(pin: digits, key: key, wallet: wallet)
            } else {
                switch self.viewModel.setupStep {
                case .check: break
                case .first:
                    self.viewModel.setupStep = .second(new: text)
                    self.passcodeDotView.slideInFromLeft()
                    self.label.slideInFromLeft()
                    self.dialedNumbersDisplayString = ""
                    self.passcodeDotView.totalDotCount = text.count
                    self.passcodeDotView.inputDotCount = 0
                    self.label.text = "PASSCODE_RENTER".localized
                case .second(new: let new):
                    let digits = new.digits
                    if new == text {
                        self.showProgressView()
                        self.viewModel.checkPin(pin: digits, key: key, wallet: wallet)
                    } else {
                        self.viewModel.setupStep = .first
                        self.passcodeDotView.slideInFromLeft()
                        self.label.slideInFromLeft()
                        self.dialedNumbersDisplayString = ""
                        self.passcodeDotView.totalDotCount = 4
                        self.passcodeDotView.inputDotCount = 0
                        self.label.text = "PASSCODE_GEN".localized
                        self.showErrorAlert(title: "ERROR".localized, message: "PASSCODE_DONT_MATCH".localized)
                    }
                }
            }
        }
    }
    
    func showBioAuth(accountInfo: AppStructs.AccountInfo) {
        if let auth = LocalAuth.biometricAuthentication {
            self.coordinator?.presentBioAuth(auth: auth, accountInfo: accountInfo, delegate: self)
        } else {
            self.coordinator?.authSuccess(accountInfo: accountInfo)
        }
    }
    
    func didDismisAlert(accountInfo: AppStructs.AccountInfo) {
        self.coordinator?.authSuccess(accountInfo: accountInfo)
    }
    
    func changePin(key: String) {
        self.showProgressView()
        self.viewModel.authService.resetPin(key: key)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] r in
                guard let self = self else { return }
                self.hideProgressView()
                self.coordinator?.navigateToConfirm(phoneNumber: r.wallet, key: key, delegate: self)
            } onFailure: { [weak self] error in
                guard let self = self else { return }
                self.hideProgressView()
                if let error = error as? NetworkError {
                    self.showErrorAlert(title: "ERROR".localized, message: (error.message ?? error.error) ?? error.localizedDescription)
                } else {
                    self.showErrorAlert(title: "ERROR".localized, message: error.localizedDescription)
                }
            }.disposed(by: self.viewModel.disposeBag)
    }
    
    func verify(code: String, key: String, wallet: String) {
        self.showProgressView()
        self.viewModel.authService.resetPinConfirm(key: key, code: code)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.checkPin(pin: self.dialedNumbersDisplayString, key: key, wallet: wallet)
            } onFailure: { [weak self] error in
                guard let self = self else { return }
                self.hideProgressView()
                if let error = error as? NetworkError {
                    self.showErrorAlert(title: "ERROR".localized, message: (error.message ?? error.error) ?? error.localizedDescription)
                } else {
                    self.showErrorAlert(title: "ERROR".localized, message: error.localizedDescription)
                }
            }.disposed(by: self.viewModel.disposeBag)
    }
    
    func resendCode(key: String, completion: @escaping (String) -> Void) {
        switch self.viewModel.startFor {
        case .setup(_, _, _):break
        case .change(let account):
            self.changePin(key: account.getKey() ?? "")
            self.coordinator?.navigateBack()
        }
    }
}
