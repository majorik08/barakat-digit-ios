//
//  BasePrefixTextField.swift
//  BarakatWallet
//
//  Created by km1tj on 20/02/24.
//

import Foundation
import UIKit
import ContactsUI

class BasePrefixTextField: UIView, UITextFieldDelegate {
    
    let rootView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = Theme.current.borderColor.cgColor
        view.layer.cornerRadius = 10
        view.layer.shadowColor = Theme.current.shadowColor.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.backgroundColor = Theme.current.plainTableBackColor
        return view
    }()
    let textFieldTopLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 15)
        view.textColor = Theme.current.secondaryTextColor
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return view
    }()
    let topLabel: PaddingLabel = {
        let view = PaddingLabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.current.plainTableBackColor
        view.textColor = Theme.current.tintColor
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.font = UIFont.medium(size: 15)
        view.leftInset = 8
        view.rightInset = 8
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.5
        return view
    }()
    let countyView: UIBaseView = {
        let view = UIBaseView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.highlightColor = Theme.current.plainSelectedCellBackground
        view.isUserInteractionEnabled = true
        return view
    }()
    let countryCodeLable: UILabel = {
        let view = UILabel(frame: .zero)
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.medium(size: 17)
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.5
        view.textAlignment = .left
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
    
    let rightImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.image = UIImage(name: .add_number)
        return view
    }()
    let bottomLabel: PaddingLabel = {
        let view = PaddingLabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 15)
        view.textColor = Theme.current.tintColor
        view.numberOfLines = 0
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return view
    }()
    let textField: UITextField
    
    weak var delegate: PaymentFieldDelegate?
    var param: AppStructs.PaymentGroup.ServiceItem.Params? = nil
    var getInfo: Bool = false
    var selectedCountry: CountryPicker.Country = .init(countryName: "Tajikistan", countryCode: "TJ", countryPhoneCode: "+992", countryFullCode: "TJK")
    var keyboardType: AppStructs.KeyboardViewType
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textField: UITextField, keyboardType: AppStructs.KeyboardViewType) {
        self.keyboardType = keyboardType
        self.textField = textField
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField.font = UIFont.medium(size: 17)
        self.textField.textColor = Theme.current.primaryTextColor
        self.textField.clipsToBounds = true
        self.textField.borderStyle = .none
        self.textField.backgroundColor = .clear
        switch keyboardType {
        case .nums:
            self.textField.keyboardType = .decimalPad
        case .alphabet:
            self.textField.keyboardType = .alphabet
        case .numsAndAlphabet:
            self.textField.keyboardType = .default
        case .phoneNumber:
            self.textField.keyboardType = .phonePad
        }
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        if keyboardType == .phoneNumber {
            self.addSubview(self.rootView)
            self.addSubview(self.topLabel)
            self.addSubview(self.bottomLabel)
            self.rootView.addSubview(self.textFieldTopLabel)
            self.rootView.addSubview(self.countyView)
            self.rootView.addSubview(self.textField)
            self.rootView.addSubview(self.rightImage)
            self.countyView.addSubview(self.countryCodeLable)
            self.countyView.addSubview(self.arrowImageView)
            NSLayoutConstraint.activate([
                self.rootView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
                self.rootView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
                self.rootView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
                self.bottomLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
                self.bottomLabel.topAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0),
                self.bottomLabel.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: 0),
                self.bottomLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
                self.topLabel.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 16),
                self.topLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
                self.topLabel.rightAnchor.constraint(lessThanOrEqualTo: self.rootView.rightAnchor, constant: -16),
                self.textFieldTopLabel.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 16),
                self.textFieldTopLabel.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 6),
                self.textFieldTopLabel.rightAnchor.constraint(equalTo: self.rightImage.leftAnchor, constant: -10),
                self.countyView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
                self.countyView.topAnchor.constraint(equalTo: self.textFieldTopLabel.bottomAnchor, constant: 0),
                self.countyView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0),
                self.countyView.widthAnchor.constraint(equalTo: self.rootView.widthAnchor, multiplier: 0.22),
                self.textField.leftAnchor.constraint(equalTo: self.countyView.rightAnchor, constant: 4),
                self.textField.topAnchor.constraint(equalTo: self.textFieldTopLabel.bottomAnchor, constant: 0),
                self.textField.rightAnchor.constraint(equalTo: self.rightImage.leftAnchor, constant: -10),
                self.textField.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0),
                self.textField.heightAnchor.constraint(equalToConstant: 48),
                self.rightImage.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -16),
                self.rightImage.heightAnchor.constraint(equalTo: self.rootView.heightAnchor, multiplier: 0.45),
                self.rightImage.widthAnchor.constraint(equalTo: self.rightImage.heightAnchor, multiplier: 1),
                self.rightImage.centerYAnchor.constraint(equalTo: self.rootView.centerYAnchor),
                self.countryCodeLable.leftAnchor.constraint(equalTo: self.countyView.leftAnchor, constant: 16),
                self.countryCodeLable.topAnchor.constraint(equalTo: self.countyView.topAnchor, constant: 6),
                self.countryCodeLable.bottomAnchor.constraint(equalTo: self.countyView.bottomAnchor, constant: -6),
                self.arrowImageView.leftAnchor.constraint(equalTo: self.countryCodeLable.rightAnchor, constant: 6),
                self.arrowImageView.topAnchor.constraint(equalTo: self.countyView.topAnchor, constant: 6),
                self.arrowImageView.rightAnchor.constraint(equalTo: self.countyView.rightAnchor, constant: -4),
                self.arrowImageView.bottomAnchor.constraint(equalTo: self.countyView.bottomAnchor, constant: -6),
                self.arrowImageView.widthAnchor.constraint(equalToConstant: 14),
            ])
        } else {
            self.addSubview(self.rootView)
            self.addSubview(self.topLabel)
            self.addSubview(self.bottomLabel)
            self.rootView.addSubview(self.textFieldTopLabel)
            self.rootView.addSubview(self.textField)
            NSLayoutConstraint.activate([
                self.rootView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
                self.rootView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
                self.rootView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
                self.bottomLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
                self.bottomLabel.topAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0),
                self.bottomLabel.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: 0),
                self.bottomLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
                self.topLabel.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 16),
                self.topLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
                self.topLabel.rightAnchor.constraint(lessThanOrEqualTo: self.rootView.rightAnchor, constant: -16),
                self.textFieldTopLabel.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 16),
                self.textFieldTopLabel.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 6),
                self.textFieldTopLabel.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -10),
                self.textField.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 16),
                self.textField.topAnchor.constraint(equalTo: self.textFieldTopLabel.bottomAnchor, constant: 0),
                self.textField.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -16),
                self.textField.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0),
                self.textField.heightAnchor.constraint(equalToConstant: 48)
            ])
        }
        self.countyView.addTapGestureRecognizerr {
            self.delegate?.getCountryTapped()
        }
        self.rightImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.rightImageTapped)))
    }
    
    func configure(param: AppStructs.PaymentGroup.ServiceItem.Params, value: String?, validate: Bool, getInfo: Bool) {
        self.getInfo = getInfo
        self.param = param
        self.tag = param.id
        self.topLabel.text = param.name
        self.textField.attributedPlaceholder = NSAttributedString(string: param.coment, attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryTextColor])
        if self.keyboardType == .phoneNumber {
            self.countryCodeLable.text = self.selectedCountry.countryPhoneCode
        }
        if validate {
            self.bottomLabel.text = nil
            self.bottomLabel.textColor = .systemRed
            self.textField.delegate = self
            self.textField.addTarget(self, action: #selector(self.reformatAsNeeded(textField:)), for: .editingChanged)
        }
        if let value = value {
            self.textField.text = value
            self.textField.sendActions(for: .editingChanged)
        }
    }
    
    func setInfo(country: CountryPicker.Country?, contactNumber: CNPhoneNumber?) {
        if let c = country {
            self.selectedCountry = c
            self.countryCodeLable.text = c.countryPhoneCode
        } else if let c = contactNumber {
            var txt = c.stringValue.digits
            if txt.starts(with: "992") {
                txt = txt.replacingOccurrences(of: "992", with: "")
            }
            self.textField.text = txt
            self.textField.sendActions(for: .editingChanged)
        }
    }
    
    @objc func rightImageTapped() {
        self.delegate?.getContactTapped()
    }
    
    @objc func reformatAsNeeded(textField: UITextField) {
        guard let param = self.param else { return }
        var value = ""
        if let text = textField.text {
            value = text
        }
        if self.keyboardType == .phoneNumber {
            value = "\(self.selectedCountry.countryPhoneCode)\(value)"
        }
        if self.regexCheck(pattern: param.mask, text: value) {
            self.bottomLabel.text = nil
            if self.getInfo {
                self.delegate?.getServiceAccountInfo(account: value)
            }
        } else {
            self.bottomLabel.text = "NUMBER_MUST_START_WITH".localized
        }
    }
    
    func snackView(viewToShake: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x - 10, y: viewToShake.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x + 10, y: viewToShake.center.y))
        viewToShake.layer.add(animation, forKey: "position")
    }
    
    func regexCheck(pattern: String, text: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            let match = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, text.count))
            return match != nil
        } catch {
            debugPrint(error)
            return false
        }
    }
}
