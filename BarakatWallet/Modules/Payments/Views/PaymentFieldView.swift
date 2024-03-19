//
//  PaymentFieldView.swift
//  BarakatWallet
//
//  Created by km1tj on 11/11/23.
//

import Foundation
import UIKit

class PaymentTextView: UIView {
    let rootView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = Theme.current.borderColor.cgColor
        view.layer.cornerRadius = 8
        view.layer.shadowColor = Theme.current.shadowColor.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        //view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.backgroundColor = Theme.current.plainTableBackColor
        return view
    }()
    let topLabel: PaddingLabel = {
        let view = PaddingLabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.current.plainTableBackColor
        view.textColor = Theme.current.tintColor
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.font = UIFont.medium(size: 16)
        view.leftInset = 8
        view.rightInset = 8
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.5
        return view
    }()
    let rightImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    let bottomLabel: PaddingLabel = {
        let view = PaddingLabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 14)
        view.textColor = Theme.current.secondaryTextColor
        //view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return view
    }()
    let fieldView: UITextView = {
        let view = UITextView()
        //view.padding = .init(top: 0, left: 10, bottom: 0, right: 10)
        view.textColor = Theme.current.primaryTextColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 16)
        view.clipsToBounds = true
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.addSubview(self.rootView)
        self.addSubview(self.topLabel)
        self.addSubview(self.bottomLabel)
        self.rootView.addSubview(self.fieldView)
        self.rootView.addSubview(self.rightImage)
        NSLayoutConstraint.activate([
            self.rootView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.rootView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.rootView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.bottomLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.bottomLabel.topAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0),
            self.bottomLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.bottomLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            self.topLabel.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 10),
            self.topLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.topLabel.rightAnchor.constraint(lessThanOrEqualTo: self.rootView.rightAnchor, constant: -10),
            self.fieldView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 10),
            self.fieldView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 0),
            self.fieldView.rightAnchor.constraint(equalTo: self.rightImage.leftAnchor, constant: -10),
            self.fieldView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0),
            //self.fieldView.heightAnchor.constraint(greaterThanOrEqualToConstant: 56),
            self.rightImage.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -16),
            self.rightImage.heightAnchor.constraint(equalTo: self.rootView.heightAnchor, multiplier: 0.45),
            self.rightImage.widthAnchor.constraint(equalTo: self.rightImage.heightAnchor, multiplier: 1),
            self.rightImage.centerYAnchor.constraint(equalTo: self.rootView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol PaymentFieldDelegate: AnyObject {
    func getServiceAccountInfo(account: String)
}

class PaymentFieldView: UIView, UITextFieldDelegate {
    
    let rootView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = Theme.current.borderColor.cgColor
        view.layer.cornerRadius = 8
        view.layer.shadowColor = Theme.current.shadowColor.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        //view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.backgroundColor = Theme.current.plainTableBackColor
        return view
    }()
    let topLabel: PaddingLabel = {
        let view = PaddingLabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.current.plainTableBackColor
        view.textColor = Theme.current.tintColor
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.font = UIFont.medium(size: 16)
        view.leftInset = 8
        view.rightInset = 8
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.5
        return view
    }()
    let rightImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    let bottomLabel: PaddingLabel = {
        let view = PaddingLabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 14)
        view.textColor = Theme.current.secondaryTextColor
        //view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return view
    }()
    let fieldView: PaddingTextField = {
        let view = PaddingTextField()
        view.padding = .init(top: 0, left: 10, bottom: 0, right: 10)
        view.textColor = Theme.current.primaryTextColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 16)
        view.clipsToBounds = true
        view.borderStyle = .none
        view.backgroundColor = .clear
        return view
    }()
    weak var delegate: PaymentFieldDelegate?
    var param: AppStructs.PaymentGroup.ServiceItem.Params? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.addSubview(self.rootView)
        self.addSubview(self.topLabel)
        self.addSubview(self.bottomLabel)
        self.rootView.addSubview(self.fieldView)
        self.rootView.addSubview(self.rightImage)
        NSLayoutConstraint.activate([
            self.rootView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.rootView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.rootView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.bottomLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            self.bottomLabel.topAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 4),
            self.bottomLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            self.bottomLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            self.topLabel.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 10),
            self.topLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.topLabel.rightAnchor.constraint(lessThanOrEqualTo: self.rootView.rightAnchor, constant: -10),
            self.fieldView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 10),
            self.fieldView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 0),
            self.fieldView.rightAnchor.constraint(equalTo: self.rightImage.leftAnchor, constant: -10),
            self.fieldView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0),
            self.fieldView.heightAnchor.constraint(equalToConstant: 56),
            self.rightImage.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -16),
            self.rightImage.heightAnchor.constraint(equalTo: self.rootView.heightAnchor, multiplier: 0.45),
            self.rightImage.widthAnchor.constraint(equalTo: self.rightImage.heightAnchor, multiplier: 1),
            self.rightImage.centerYAnchor.constraint(equalTo: self.rootView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(param: AppStructs.PaymentGroup.ServiceItem.Params, value: String?, validate: Bool) {
        self.param = param
//        let coms = param.prefix.split(separator: ",")
//        if coms.count == 1 {
//            self.fieldView.text = param.prefix
//        }
        //        struct Params: Codable {
        //            let id: Int
        //            let name: String
        //            let coment: String
        //            let keyboard: Int
        //            let mask: String
        //            let maxLen: Int
        //            let minLen: Int
        //            let param: Int
        //            let prefix: String
        //        }
        self.tag = param.id
        self.topLabel.text = param.name
        self.fieldView.attributedPlaceholder = NSAttributedString(string: param.coment, attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryTextColor])
        let type = AppStructs.KeyboardViewType(rawValue: param.keyboard) ?? .alphabet
        switch type {
        case .nums:
            self.fieldView.keyboardType = .decimalPad
        case .alphabet:
            self.fieldView.keyboardType = .alphabet
        case .numsAndAlphabet:
            self.fieldView.keyboardType = .default
        case .phoneNumber:
            self.fieldView.keyboardType = .phonePad
        }
        if validate {
            self.bottomLabel.text = nil
            self.bottomLabel.textColor = .systemRed
            self.fieldView.delegate = self
            self.fieldView.addTarget(self, action: #selector(self.reformatAsNeeded(textField:)), for: .editingDidEnd)
        }
        if let value = value {
            self.fieldView.text = value
        }
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let tText = textField.text else { return true }
//        guard let param = self.param else { return true }
//        let newLength = tText.count + string.count - range.length
//        return newLength <= param.maxLen
//    }
    
    @objc func reformatAsNeeded(textField: UITextField) {
        guard let param = self.param else { return }
        var value = ""
        if let text = textField.text {
            value = text
        }
        if self.regexCheck(pattern: param.mask, text: value) {
            self.bottomLabel.text = nil
        } else {
            self.bottomLabel.text = "NUMBER_MUST_START_WITH".localizedFormat(arguments: param.prefix)
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
