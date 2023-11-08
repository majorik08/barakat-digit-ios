//
//  TransferSumView.swift
//  BarakatWallet
//
//  Created by km1tj on 25/10/23.
//

import Foundation
import UIKit

class TransferSumView: UIView {
    
    let leftView: UIView = {
        let view = UIView(backgroundColor: .clear)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.00)
        view.layer.cornerRadius = 26
        view.clipsToBounds = true
        return view
    }()
    let rightView: UIView = {
        let view = UIView(backgroundColor: .clear)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let topLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 16)
        view.textColor = Theme.current.primaryTextColor
        view.textAlignment = .center
        view.text = "MINUS_AMOUNT".localized
        return view
    }()
    let topSumField: UITextField = {
        let view = UITextField(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 16)
        view.textAlignment = .center
        view.placeholder = "RUB"
        view.layer.cornerRadius = 23
        view.borderStyle = .none
        view.clipsToBounds = true
        view.keyboardType = .decimalPad
        return view
    }()
    let bottomLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 16)
        view.textColor = Theme.current.primaryTextColor
        view.textAlignment = .center
        view.text = "PLUS_AMOUNT".localized
        return view
    }()
    let bottomSumField: UITextField = {
        let view = UITextField(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 16)
        view.textAlignment = .center
        view.placeholder = "TJS"
        view.layer.cornerRadius = 23
        view.borderStyle = .none
        view.clipsToBounds = true
        view.keyboardType = .decimalPad
        return view
    }()
    let transferRateView: TransferInfoView = {
        let view = TransferInfoView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.iconView.image = UIImage(name: .rubl_icon).tintedWithLinearGradientColors()
        view.titleLabel.text = "0 RUB = 0.1115 TJS"
        view.subTitleLabel.text = "Курс"
        return view
    }()
    let transferTaxView: TransferInfoView = {
        let view = TransferInfoView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.iconView.image = UIImage(name: .per_icon).tintedWithLinearGradientColors()
        view.titleLabel.text = "40 RUB"
        view.subTitleLabel.text = "Комиссия 1.5% но не менее 40 RUB"
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 14
        self.layer.shadowColor = Theme.current.shadowColor.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.backgroundColor = Theme.current.plainTableCellColor
        self.addSubview(self.topLabel)
        self.addSubview(self.rightView)
        self.addSubview(self.leftView)
        self.leftView.addSubview(self.topSumField)
        self.leftView.addSubview(self.bottomLabel)
        self.leftView.addSubview(self.bottomSumField)
        self.rightView.addSubview(self.transferRateView)
        self.rightView.addSubview(self.transferTaxView)
        NSLayoutConstraint.activate([
            self.topLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.topLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            self.topLabel.rightAnchor.constraint(equalTo: self.centerXAnchor),
            self.leftView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            self.leftView.topAnchor.constraint(equalTo: self.topLabel.bottomAnchor, constant: 8),
            self.leftView.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: -8),
            self.leftView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            self.rightView.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: 8),
            self.rightView.topAnchor.constraint(equalTo: self.topLabel.topAnchor, constant: 4),
            self.rightView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            self.rightView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            self.topSumField.leftAnchor.constraint(equalTo: self.leftView.leftAnchor),
            self.topSumField.topAnchor.constraint(equalTo: self.leftView.topAnchor, constant: 0),
            self.topSumField.rightAnchor.constraint(equalTo: self.leftView.rightAnchor),
            self.topSumField.heightAnchor.constraint(equalToConstant: 46),
            self.bottomLabel.leftAnchor.constraint(equalTo: self.leftView.leftAnchor),
            self.bottomLabel.topAnchor.constraint(equalTo: self.topSumField.bottomAnchor, constant: 10),
            self.bottomLabel.rightAnchor.constraint(equalTo: self.leftView.rightAnchor),
            self.bottomSumField.leftAnchor.constraint(equalTo: self.leftView.leftAnchor),
            self.bottomSumField.topAnchor.constraint(equalTo: self.bottomLabel.bottomAnchor, constant: 6),
            self.bottomSumField.rightAnchor.constraint(equalTo: self.leftView.rightAnchor),
            self.bottomSumField.heightAnchor.constraint(equalToConstant: 46),
            self.bottomSumField.bottomAnchor.constraint(equalTo: self.leftView.bottomAnchor),
            self.transferRateView.leftAnchor.constraint(equalTo: self.rightView.leftAnchor),
            self.transferRateView.topAnchor.constraint(equalTo: self.rightView.topAnchor, constant: 0),
            self.transferRateView.rightAnchor.constraint(equalTo: self.rightView.rightAnchor),
            self.transferTaxView.leftAnchor.constraint(equalTo: self.rightView.leftAnchor),
            self.transferTaxView.topAnchor.constraint(equalTo: self.transferRateView.bottomAnchor, constant: 10),
            self.transferTaxView.rightAnchor.constraint(equalTo: self.rightView.rightAnchor),
            self.transferTaxView.bottomAnchor.constraint(lessThanOrEqualTo: self.rightView.bottomAnchor)
            
        ])
        self.topSumField.addTarget(self, action: #selector(activateField), for: .editingDidBegin)
        self.bottomSumField.addTarget(self, action: #selector(activateField), for: .editingDidBegin)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func activateField(textField: UITextField) {
        self.makeActive(textField: textField)
        if textField == self.topSumField {
            self.makeDisable(textField: self.bottomSumField)
        } else if textField == self.bottomSumField {
            self.makeDisable(textField: self.topSumField)
        }
    }
    
    func makeActive(textField: UITextField) {
        textField.backgroundColor = Theme.current.tintColor
        textField.textColor = .white
        if textField == self.topSumField {
            textField.attributedPlaceholder = NSAttributedString(string: "RUB", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        } else if textField == self.bottomSumField {
            textField.attributedPlaceholder = NSAttributedString(string: "TJS", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        }
    }
    
    func makeDisable(textField: UITextField) {
        textField.backgroundColor = .clear
        textField.textColor = Theme.current.tintColor
        if textField == self.topSumField {
            textField.attributedPlaceholder = NSAttributedString(string: "RUB", attributes: [NSAttributedString.Key.foregroundColor: Theme.current.primaryTextColor])
        } else if textField == self.bottomSumField {
            textField.attributedPlaceholder = NSAttributedString(string: "TJS", attributes: [NSAttributedString.Key.foregroundColor: Theme.current.primaryTextColor])
        }
    }
}


class TransferInfoView: UIView {
    
    let iconView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 12)
        view.numberOfLines = 0
        view.textColor = Theme.current.primaryTextColor
        return view
    }()
    let subTitleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 12)
        view.numberOfLines = 0
        view.textColor = Theme.current.primaryTextColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.iconView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.subTitleLabel)
        NSLayoutConstraint.activate([
            self.iconView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.iconView.topAnchor.constraint(equalTo: self.topAnchor),
            self.iconView.heightAnchor.constraint(equalToConstant: 16),
            self.iconView.widthAnchor.constraint(equalToConstant: 16),
            self.titleLabel.leftAnchor.constraint(equalTo: self.iconView.rightAnchor, constant: 10),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.subTitleLabel.leftAnchor.constraint(equalTo: self.iconView.rightAnchor, constant: 10),
            self.subTitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor),
            self.subTitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.subTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
