//
//  SetPinViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 22/10/23.
//

import Foundation
import UIKit
import RxCocoa

extension UITextInput {
    var selectedRange: NSRange? {
        guard let range = selectedTextRange else { return nil }
        let location = offset(from: beginningOfDocument, to: range.start)
        let length = offset(from: range.start, to: range.end)
        return NSRange(location: location, length: length)
    }
}

class SetPinViewController: BaseViewController, KeyPadViewDelegate, UITextFieldDelegate {
    
    let backButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(name: .back_arrow), for: .normal)
        view.tintColor = Theme.current.primaryTextColor
        return view
    }()
    let label: GradientLabel = {
        let view = GradientLabel(frame: .zero)
        view.font = UIFont.bold(size: 22)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "ENTER_PIN".localized
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
    let passcodeField: UITextField = {
        let view = UITextField()
        view.isSecureTextEntry = true
        view.textColor = Theme.current.primaryTextColor
        view.returnKeyType = .done
        view.tintColor = Theme.current.tintColor
        view.keyboardAppearance = Theme.current.dark ? .dark : .light
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.current.groupedTableCellColor
        view.textAlignment = .center
        view.font = UIFont.regular(size: 19)
        view.isHidden = true
        view.autocorrectionType = .no
        view.inputAccessoryView = nil
        view.inputView = UIView(backgroundColor: .clear)
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
    weak var coordinator: LoginCoordinator?
 
    let viewModel: SetPinViewModel
    
    init(viewModel: SetPinViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.label)
        self.view.addSubview(self.numberHint)
        self.view.addSubview(self.passcodeField)
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
            self.label.topAnchor.constraint(greaterThanOrEqualTo: self.view.topAnchor, constant: UIApplication.statusBarHeight + 44 + 30),
            self.label.rightAnchor.constraint(lessThanOrEqualTo: self.view.rightAnchor, constant: -27),
            self.numberHint.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 27),
            self.numberHint.topAnchor.constraint(equalTo: self.label.bottomAnchor, constant: 48),
            self.numberHint.rightAnchor.constraint(lessThanOrEqualTo: self.view.rightAnchor, constant: -27),
            self.passcodeDotView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 27),
            self.passcodeDotView.topAnchor.constraint(equalTo: self.numberHint.bottomAnchor, constant: 28),
            self.passcodeDotView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -27),
            self.passcodeDotView.heightAnchor.constraint(equalToConstant: 24),
            self.passcodeField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 27),
            self.passcodeField.topAnchor.constraint(equalTo: self.numberHint.bottomAnchor, constant: 10),
            self.passcodeField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -27),
            self.passcodeField.heightAnchor.constraint(equalToConstant: 24),
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
            self.continueButton.heightAnchor.constraint(equalToConstant: 56),
        ])
        self.passcodeDotView.totalDotCount = self.viewModel.passcodeMinLength
        self.passcodeDotView.inputDotCount = 0
        self.keyPadView.delegate = self
        self.passcodeField.delegate = self
        self.backButton.rx.tap.subscribe { [weak self] _ in
            if let coo = self?.coordinator {
                coo.navigateBack()
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }.disposed(by: self.viewModel.disposeBag)
        self.continueButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.next(text: self.passcodeField.text ?? "")
        }.disposed(by: self.viewModel.disposeBag)
        self.passcodeField.rx.text.orEmpty.map({ $0.count >= self.viewModel.passcodeMinLength && $0.count <= self.viewModel.passcodeMaxLength }).share(replay: 1).bind(to: self.continueButton.rx.isEnabled).disposed(by: self.viewModel.disposeBag)
        self.passcodeField.becomeFirstResponder()
    }
    
    func keyTapped(digit: String) {
        guard let changeText = self.passcodeField.selectedRange else { return }
        if self.textField(self.passcodeField, shouldChangeCharactersIn: changeText, replacementString: digit == "<" ? "" : digit) {
            if digit == "<" {
                self.passcodeField.deleteBackward()
            } else {
                self.passcodeField.insertText(digit)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let text = (currentText as NSString).replacingCharacters(in: range, with: string)
        if text.count > self.viewModel.passcodeMaxLength {
            return false
        }
        if let _ = text.rangeOfCharacter(from: self.viewModel.validDigitsSet.inverted) {
            return false
        }
        if text.count >= self.viewModel.passcodeMinLength {
            self.passcodeDotView.totalDotCount = text.count
        }
        self.passcodeDotView.inputDotCount = text.count
        if string == "\n" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.next(text: text)
            }
            return false
        }
        if text.count == self.viewModel.passcodeMaxLength {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.next(text: text)
            }
        }
        return true
    }
    
    func next(text: String) {
        switch self.viewModel.startFor {
        case .change:
            if self.viewModel.setupStep == .first {
                self.viewModel.setupStep = .second
                self.viewModel.enteredPasscode = text
                self.passcodeDotView.slideInFromLeft()
                self.label.slideInFromLeft()
                self.passcodeField.text = ""
                self.passcodeDotView.inputDotCount = 0
                self.label.text = "PASSCODE_RENTER".localized
            } else if self.viewModel.setupStep == .second {
                if self.viewModel.enteredPasscode == text {
                    self.viewModel.changePin(pin: text)
                    self.viewModel.delegate?(true)
                } else {
                    self.viewModel.setupStep = .first
                    self.viewModel.enteredPasscode = nil
                    self.passcodeDotView.slideInFromLeft()
                    self.label.slideInFromLeft()
                    self.passcodeField.text = ""
                    self.passcodeDotView.inputDotCount = 0
                    self.label.text = "PASSCODE_ENTER_NEW".localized
                    self.showErrorAlert(title: "ERROR".localized, message: "PASSCODE_DONT_MATCH".localized)
                }
            }
        case .setup:
            if self.viewModel.setupStep == .first {
                self.viewModel.setupStep = .second
                self.viewModel.enteredPasscode = text
                self.passcodeDotView.slideInFromLeft()
                self.label.slideInFromLeft()
                self.passcodeField.text = ""
                self.passcodeDotView.inputDotCount = 0
                self.label.text = "PASSCODE_RENTER".localized
            } else if self.viewModel.setupStep == .second {
                if self.viewModel.enteredPasscode == text {
                    self.viewModel.changePin(pin: text)
                    self.viewModel.delegate?(true)
                    self.coordinator?.navigateToMain(account: self.viewModel.account)
                } else {
                    self.viewModel.setupStep = .first
                    self.viewModel.enteredPasscode = nil
                    self.passcodeDotView.slideInFromLeft()
                    self.label.slideInFromLeft()
                    self.passcodeField.text = ""
                    self.passcodeDotView.inputDotCount = 0
                    self.label.text = "PASSCODE_ENTER_NEW".localized
                    self.showErrorAlert(title: "ERROR".localized, message: "PASSCODE_DONT_MATCH".localized)
                }
            }
        case .check:
            if self.viewModel.startFor.passcode == text {
                self.viewModel.delegate?(true)
            } else {
                self.passcodeDotView.shakeAnimate()
                self.passcodeField.text = ""
                self.passcodeDotView.inputDotCount = 0
            }
        }
    }
}
