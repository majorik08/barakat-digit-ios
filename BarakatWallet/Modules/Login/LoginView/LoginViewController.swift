//
//  LoginViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 05/10/23.
//

import Foundation
import UIKit
import PhoneNumberKit
import RxCocoa

class LoginViewController: BaseViewController, KeyPadViewDelegate {
    
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
        view.text = "YOUR_PHONE_NUMBER".localized
        return view
    }()
    let numberHint: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 16)
        view.textColor = Theme.current.primaryTextColor
        view.text = "PHONE_NUMBER".localized
        return view
    }()
    let countyView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let numberView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let phoneNumberField: PhoneNumberTextField = {
        let view = PhoneNumberTextField(withPhoneNumberKit: Constants.phoneNumberKit)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 18)
        view.borderStyle = .none
        view.textContentType = .telephoneNumber
        view.keyboardType = .numberPad
        view.textColor = Theme.current.primaryTextColor
        view.inputView = UIView(backgroundColor: .clear)
        view.attributedPlaceholder = NSAttributedString(string: "918-00-00-00", attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryTextColor])
        view.partialFormatter.defaultRegion = Constants.defaultRegionCode()
        return view
    }()
    let countryCodeLable: UILabel = {
        let view = UILabel(frame: .zero)
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.regular(size: 18)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        view.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        view.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: .horizontal)
        return view
    }()
    let arrowImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(name: .down_arrow)
        view.tintColor = Theme.current.primaryTextColor
        view.contentMode = .scaleAspectFit
        return view
    }()
    let checkButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(name: .checked), for: .selected)
        view.setImage(UIImage(name: .unchecked), for: .normal)
        view.tintColor = Theme.current.tintColor
        view.isSelected = true
        return view
    }()
    let privacyHint: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 14)
        view.textColor = Theme.current.primaryTextColor
        view.text = "PRIVACY_LOGIN".localized
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
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
    var selectedCountry: CountryPicker.Country? {
        didSet {
            if let country = self.selectedCountry {
                self.phoneNumberField.partialFormatter.defaultRegion = country.countryCode
                let flag = CountryPicker.flag(country: country.countryCode)
                self.countryCodeLable.text = flag + " \(country.countryPhoneCode)"
            }
        }
    }
    weak var coordinator: LoginCoordinator?
    let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.label)
        self.view.addSubview(self.numberHint)
        self.view.addSubview(self.countyView)
        self.view.addSubview(self.numberView)
        self.countyView.addSubview(self.countryCodeLable)
        self.countyView.addSubview(self.arrowImageView)
        self.numberView.addSubview(self.phoneNumberField)
        self.view.addSubview(self.checkButton)
        self.view.addSubview(self.privacyHint)
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
            self.countyView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 27),
            self.countyView.topAnchor.constraint(equalTo: self.numberHint.bottomAnchor, constant: 10),
            self.countyView.heightAnchor.constraint(equalToConstant: 46),
            self.countyView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3),
            self.numberView.leftAnchor.constraint(equalTo: self.countyView.rightAnchor, constant: -1),
            self.numberView.topAnchor.constraint(equalTo: self.numberHint.bottomAnchor, constant: 10),
            self.numberView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -27),
            self.numberView.heightAnchor.constraint(equalToConstant: 46),
            self.countryCodeLable.leftAnchor.constraint(equalTo: self.countyView.leftAnchor, constant: 8),
            self.countryCodeLable.topAnchor.constraint(equalTo: self.countyView.topAnchor, constant: 6),
            self.countryCodeLable.bottomAnchor.constraint(equalTo: self.countyView.bottomAnchor, constant: -6),
            self.arrowImageView.leftAnchor.constraint(equalTo: self.countryCodeLable.rightAnchor, constant: 4),
            self.arrowImageView.topAnchor.constraint(equalTo: self.countyView.topAnchor, constant: 6),
            self.arrowImageView.rightAnchor.constraint(equalTo: self.countyView.rightAnchor, constant: -8),
            self.arrowImageView.bottomAnchor.constraint(equalTo: self.countyView.bottomAnchor, constant: -6),
            self.arrowImageView.widthAnchor.constraint(equalToConstant: 16),
            self.phoneNumberField.leftAnchor.constraint(equalTo: self.numberView.leftAnchor, constant: 16),
            self.phoneNumberField.topAnchor.constraint(equalTo: self.numberView.topAnchor, constant: 6),
            self.phoneNumberField.rightAnchor.constraint(equalTo: self.numberView.rightAnchor, constant: -8),
            self.phoneNumberField.bottomAnchor.constraint(equalTo: self.numberView.bottomAnchor, constant: -6),
            self.checkButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 27),
            self.checkButton.topAnchor.constraint(equalTo: self.countyView.bottomAnchor, constant: 20),
            self.checkButton.heightAnchor.constraint(equalToConstant: 22),
            self.checkButton.widthAnchor.constraint(equalToConstant: 22),
            self.privacyHint.leftAnchor.constraint(equalTo: self.checkButton.rightAnchor, constant: 10),
            self.privacyHint.topAnchor.constraint(equalTo: self.countyView.bottomAnchor, constant: 20),
            self.privacyHint.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -27),
            self.keyPadView.topAnchor.constraint(equalTo: self.privacyHint.bottomAnchor, constant: 20),
            self.keyPadView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            self.keyPadView.heightAnchor.constraint(equalTo: self.keyPadView.widthAnchor, multiplier: 1.2),
            self.keyPadView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            self.continueButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 27),
            self.continueButton.topAnchor.constraint(equalTo: self.keyPadView.bottomAnchor, constant: 10),
            self.continueButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -27),
            self.continueButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            self.continueButton.heightAnchor.constraint(equalToConstant: 56),
        ])
        if let country = CountryPicker.getCurrentCountry(ISO: self.phoneNumberField.partialFormatter.defaultRegion, language: Constants.Language ?? "en") {
            self.selectedCountry = country
        } else {
            self.selectedCountry = CountryPicker.Country(countryName: "Tajikistan", countryCode: "TJ", countryPhoneCode: "+992", countryFullCode: "TJK")
        }
        self.selectedCountry = CountryPicker.Country(countryName: "Tajikistan", countryCode: "TJ", countryPhoneCode: "+992", countryFullCode: "TJK")
        self.keyPadView.delegate = self
        self.backButton.rx.tap.subscribe { [weak self] _ in
            self?.coordinator?.navigateBack()
        }.disposed(by: self.viewModel.disposeBag)
        self.checkButton.rx.tap.subscribe { [weak self] event in
            self?.checkButton.isSelected = !(self?.checkButton.isSelected ?? false)
            self?.viewModel.privacyCheck.onNext(self?.checkButton.isSelected ?? false)
        }.disposed(by: self.viewModel.disposeBag)
        self.phoneNumberField.rx.text.orEmpty.bind(to: self.viewModel.phoneNumber).disposed(by: self.viewModel.disposeBag)
        self.continueButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.showProgressView()
            let phoneNumber = "+\("\(self.selectedCountry?.countryPhoneCode ?? "") \(self.phoneNumberField.text!)".digits)"
            self.viewModel.signInTapped(device: Constants.Device, number: phoneNumber)
        }.disposed(by: self.viewModel.disposeBag)
        self.viewModel.didSendError.subscribe { [weak self] message in
            self?.hideProgressView()
            self?.showErrorAlert(title: "ERROR".localized, message: message)
        }.disposed(by: self.viewModel.disposeBag)
        self.viewModel.didSendCode.subscribe { [weak self] key in
            guard let self = self else { return }
            self.hideProgressView()
            let phoneNumber = "+\("\(self.selectedCountry?.countryPhoneCode ?? "") \(self.phoneNumberField.text!)".digits)"
            self.coordinator?.navigateToValidate(phoneNumber: phoneNumber, key: key)
        }.disposed(by: self.viewModel.disposeBag)
        self.viewModel.isSendActive.bind(to: self.continueButton.rx.isEnabled).disposed(by: self.viewModel.disposeBag)
        self.phoneNumberField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let c = UIColor(red: 0.2, green: 0.333, blue: 0.914, alpha: 1)
        self.countyView.roundCorners(corners: [.topLeft, .bottomLeft], radius: 8, thickness: 1.8, color: c)
        self.numberView.roundCorners(corners: [.topRight, .bottomRight], radius: 8, thickness: 1.8, color: c)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setStatusBarStyle(dark: nil)
    }
    
    func keyTapped(digit: String) {
        if digit == "<" {
            self.phoneNumberField.deleteBackward()
        } else {
            self.phoneNumberField.insertText(digit)
        }
        self.phoneNumberField.text = self.phoneNumberField.text
    }
}
