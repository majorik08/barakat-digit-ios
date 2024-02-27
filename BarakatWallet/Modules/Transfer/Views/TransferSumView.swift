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
        view.backgroundColor = Theme.current.grayColor
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
    let bottomLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 16)
        view.textColor = Theme.current.primaryTextColor
        view.textAlignment = .center
        view.text = "PLUS_AMOUNT".localized
        return view
    }()
    let topSumContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 23
        view.clipsToBounds = true
        return view
    }()
    let bottomSumContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 23
        view.clipsToBounds = true
        return view
    }()
    let topSumField: CurrencyField = {
        let view = CurrencyField(insets: .init(top: 0, left: 0, bottom: 0, right: 0), aligment: .center)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.field.placeholder = "RUB"
        view.currency = .RUB
        view.font = UIFont.bold(size: 16)
        view.rightView.adjustsFontSizeToFitWidth = false
        return view
    }()
    let bottomSumField: CurrencyField = {
        let view = CurrencyField(insets: .init(top: 0, left: 0, bottom: 0, right: 0), aligment: .center)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.field.placeholder = "TJS"
        view.currency = .TJS
        view.font = UIFont.bold(size: 16)
        view.rightView.adjustsFontSizeToFitWidth = false
        return view
    }()
    let transferRateView: TransferInfoView = {
        let view = TransferInfoView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.iconView.image = UIImage(name: .rubl_icon).tintedWithLinearGradientColors()
        view.titleLabel.text = ""
        view.subTitleLabel.text = ""
        return view
    }()
    let transferTaxView: TransferInfoView = {
        let view = TransferInfoView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.iconView.image = UIImage(name: .per_icon).tintedWithLinearGradientColors()
        view.titleLabel.text = ""
        view.subTitleLabel.text = ""
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
        self.leftView.addSubview(self.topSumContainer)
        self.leftView.addSubview(self.bottomLabel)
        self.leftView.addSubview(self.bottomSumContainer)
        self.topSumContainer.addSubview(self.topSumField)
        self.bottomSumContainer.addSubview(self.bottomSumField)
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
            self.topSumContainer.leftAnchor.constraint(equalTo: self.leftView.leftAnchor),
            self.topSumContainer.topAnchor.constraint(equalTo: self.leftView.topAnchor, constant: 0),
            self.topSumContainer.rightAnchor.constraint(equalTo: self.leftView.rightAnchor),
            self.topSumContainer.heightAnchor.constraint(equalToConstant: 46),
            self.topSumField.leftAnchor.constraint(greaterThanOrEqualTo: self.topSumContainer.leftAnchor),
            self.topSumField.topAnchor.constraint(equalTo: self.topSumContainer.topAnchor),
            self.topSumField.rightAnchor.constraint(lessThanOrEqualTo: self.topSumContainer.rightAnchor),
            self.topSumField.bottomAnchor.constraint(equalTo: self.topSumContainer.bottomAnchor),
            self.topSumField.centerXAnchor.constraint(equalTo: self.topSumContainer.centerXAnchor),
            self.bottomLabel.leftAnchor.constraint(equalTo: self.leftView.leftAnchor),
            self.bottomLabel.topAnchor.constraint(equalTo: self.topSumContainer.bottomAnchor, constant: 10),
            self.bottomLabel.rightAnchor.constraint(equalTo: self.leftView.rightAnchor),
            self.bottomSumContainer.leftAnchor.constraint(equalTo: self.leftView.leftAnchor),
            self.bottomSumContainer.topAnchor.constraint(equalTo: self.bottomLabel.bottomAnchor, constant: 6),
            self.bottomSumContainer.rightAnchor.constraint(equalTo: self.leftView.rightAnchor),
            self.bottomSumContainer.heightAnchor.constraint(equalToConstant: 46),
            self.bottomSumContainer.bottomAnchor.constraint(equalTo: self.leftView.bottomAnchor),
            self.bottomSumField.leftAnchor.constraint(greaterThanOrEqualTo: self.bottomSumContainer.leftAnchor),
            self.bottomSumField.topAnchor.constraint(equalTo: self.bottomSumContainer.topAnchor),
            self.bottomSumField.rightAnchor.constraint(lessThanOrEqualTo: self.bottomSumContainer.rightAnchor),
            self.bottomSumField.bottomAnchor.constraint(equalTo: self.bottomSumContainer.bottomAnchor),
            self.bottomSumField.centerXAnchor.constraint(equalTo: self.bottomSumContainer.centerXAnchor),
            self.transferRateView.leftAnchor.constraint(equalTo: self.rightView.leftAnchor),
            self.transferRateView.topAnchor.constraint(equalTo: self.rightView.topAnchor, constant: 0),
            self.transferRateView.rightAnchor.constraint(equalTo: self.rightView.rightAnchor),
            self.transferTaxView.leftAnchor.constraint(equalTo: self.rightView.leftAnchor),
            self.transferTaxView.topAnchor.constraint(equalTo: self.transferRateView.bottomAnchor, constant: 10),
            self.transferTaxView.rightAnchor.constraint(equalTo: self.rightView.rightAnchor),
            self.transferTaxView.bottomAnchor.constraint(lessThanOrEqualTo: self.rightView.bottomAnchor)
        ])
        self.topSumField.field.addTarget(self, action: #selector(activateField), for: .editingDidBegin)
        self.bottomSumField.field.addTarget(self, action: #selector(activateField), for: .editingDidBegin)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func activateField(textField: UITextField) {
        if textField == self.topSumField.field {
            self.topSumContainer.backgroundColor = Theme.current.tintColor
            self.bottomSumContainer.backgroundColor = .clear
            self.makeActive(textField: self.topSumField)
            self.makeDisable(textField: self.bottomSumField)
        } else if textField == self.bottomSumField.field {
            self.topSumContainer.backgroundColor = .clear
            self.bottomSumContainer.backgroundColor = Theme.current.tintColor
            self.makeActive(textField: self.bottomSumField)
            self.makeDisable(textField: self.topSumField)
        }
    }
    
    func makeActive(textField: CurrencyField) {
        textField.textColor = .white
        if textField == self.topSumField {
            textField.field.attributedPlaceholder = NSAttributedString(string: "RUB", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        } else if textField == self.bottomSumField {
            textField.field.attributedPlaceholder = NSAttributedString(string: "TJS", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        }
    }
    
    func makeDisable(textField: CurrencyField) {
        textField.textColor = Theme.current.tintColor
        if textField == self.topSumField {
            textField.field.attributedPlaceholder = NSAttributedString(string: "RUB", attributes: [NSAttributedString.Key.foregroundColor: Theme.current.tintColor])
        } else if textField == self.bottomSumField {
            textField.field.attributedPlaceholder = NSAttributedString(string: "TJS", attributes: [NSAttributedString.Key.foregroundColor: Theme.current.tintColor])
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
