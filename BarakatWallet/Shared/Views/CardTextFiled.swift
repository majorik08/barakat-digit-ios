//
//  CardTextFiled.swift
//  BarakatWallet
//
//  Created by km1tj on 24/10/23.
//

import Foundation
import UIKit

class CardTextFiled: UIView {
    
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
    let rightImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    let bottomLabel: PaddingLabel = {
        let view = PaddingLabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 15)
        view.textColor = Theme.current.tintColor
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return view
    }()
    let textField: UITextField
    
    init(textField: UITextField = UITextField(frame: .zero)) {
        self.textField = textField
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField.font = UIFont.medium(size: 17)
        self.textField.textColor = Theme.current.primaryTextColor
        self.textField.clipsToBounds = true
        self.textField.borderStyle = .none
        self.textField.backgroundColor = .clear
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.addSubview(self.rootView)
        self.addSubview(self.topLabel)
        self.addSubview(self.bottomLabel)
        self.rootView.addSubview(self.textFieldTopLabel)
        self.rootView.addSubview(self.textField)
        self.rootView.addSubview(self.rightImage)
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
            self.textField.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 16),
            self.textField.topAnchor.constraint(equalTo: self.textFieldTopLabel.bottomAnchor, constant: 0),
            self.textField.rightAnchor.constraint(equalTo: self.rightImage.leftAnchor, constant: -10),
            self.textField.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0),
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
