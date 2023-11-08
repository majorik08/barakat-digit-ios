//
//  VerifyCodeViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 22/10/23.
//

import Foundation
import UIKit
import RxCocoa

class VerifyCodeViewController: BaseViewController, KeyPadViewDelegate {
    
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
        view.text = "ENTER_CODE".localized
        return view
    }()
    let numberHint: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 16)
        view.textColor = Theme.current.primaryTextColor
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.text = "SMS_SENDED_TO".localizedFormat(arguments: "+992 918 000000")
        return view
    }()
    let numberView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let codeField: UITextField = {
        let view = UITextField(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 20)
        view.borderStyle = .none
        if #available(iOS 12.0, *) {
            view.textContentType = .oneTimeCode
        }
        view.keyboardType = .numberPad
        view.textAlignment = .center
        view.textColor = Theme.current.primaryTextColor
        view.inputView = UIView(backgroundColor: .clear)
        view.attributedPlaceholder = NSAttributedString(string: "SMS_CODE".localized, attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryTextColor])
        return view
    }()
    let timerHint: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 14)
        view.textColor = Theme.current.secondaryTextColor
        view.text = "RESEND_AFTER".localized
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.textAlignment = .center
        view.isUserInteractionEnabled = true
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
        return view
    }()
    var timer: Timer? = nil
    let viewModel: VerifyViewModel
    weak var coordinator: LoginCoordinator?
    
    init(viewModel: VerifyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.label)
        self.view.addSubview(self.numberHint)
        self.view.addSubview(self.numberView)
        self.numberView.addSubview(self.codeField)
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
            self.numberView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 27),
            self.numberView.topAnchor.constraint(equalTo: self.numberHint.bottomAnchor, constant: 10),
            self.numberView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -27),
            self.numberView.heightAnchor.constraint(equalToConstant: 46),
            self.codeField.leftAnchor.constraint(equalTo: self.numberView.leftAnchor, constant: 8),
            self.codeField.topAnchor.constraint(equalTo: self.numberView.topAnchor, constant: 6),
            self.codeField.rightAnchor.constraint(equalTo: self.numberView.rightAnchor, constant: -8),
            self.codeField.bottomAnchor.constraint(equalTo: self.numberView.bottomAnchor, constant: -6),
            self.timerHint.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 27),
            self.timerHint.topAnchor.constraint(equalTo: self.numberView.bottomAnchor, constant: 20),
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
        self.keyPadView.delegate = self
        self.numberHint.text = "SMS_SENDED_TO".localizedFormat(arguments: self.viewModel.phoneNumber.formatedPrefix())
        self.backButton.rx.tap.subscribe { [weak self] _ in
            self?.coordinator?.navigateBack()
        }.disposed(by: self.viewModel.disposeBag)
        self.codeField.rx.text.orEmpty.bind(to: self.viewModel.code).disposed(by: self.viewModel.disposeBag)
        self.continueButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let code = self.codeField.text ?? ""
            self.showProgressView()
            self.viewModel.verifyTapped(device: Constants.Device, code: code)
        }.disposed(by: self.viewModel.disposeBag)
        self.viewModel.didVerifyError.subscribe { [weak self] message in
            self?.hideProgressView()
            self?.showErrorAlert(title: "ERROR".localized, message: message)
        }.disposed(by: self.viewModel.disposeBag)
        self.viewModel.didSignIn.subscribe { [weak self] account in
            guard let self = self else { return }
            self.hideProgressView()
            self.coordinator?.navigateToSetPin(account: account)
        }.disposed(by: self.viewModel.disposeBag)
        self.timerHint.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resendCode)))
        self.viewModel.isSendActive.bind(to: self.continueButton.rx.isEnabled).disposed(by: self.viewModel.disposeBag)
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(canResentCode), userInfo: nil, repeats: true)
        self.codeField.becomeFirstResponder()
    }
    
    @objc func resendCode() {
        if self.viewModel.waitTime <= 0 {
            
        }
    }
    
    @objc func canResentCode() {
        if self.viewModel.waitTime > 0 {
            self.viewModel.waitTime -= 1
            let mutableText = NSMutableAttributedString(string: "\("RESEND_AFTER".localized): ", attributes: [NSAttributedString.Key.foregroundColor : Theme.current.secondaryTextColor])
            mutableText.append(NSAttributedString(string: "\(self.viewModel.waitTime)", attributes: [NSAttributedString.Key.foregroundColor : Theme.current.tintColor]))
            self.timerHint.attributedText = mutableText
        } else {
            let attr = NSAttributedString(string: "RESEND_CODE_TITLE".localized, attributes:
                                            [NSAttributedString.Key.foregroundColor : Theme.current.tintColor,
                                             NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
            self.timerHint.attributedText = attr
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let c = UIColor(red: 0.2, green: 0.333, blue: 0.914, alpha: 1)
        self.numberView.roundCorners(corners: [.allCorners], radius: 8, thickness: 1.8, color: c)
    }
    
    func keyTapped(digit: String) {
        if digit == "<" {
            self.codeField.deleteBackward()
        } else {
            self.codeField.insertText(digit)
        }
    }
}
