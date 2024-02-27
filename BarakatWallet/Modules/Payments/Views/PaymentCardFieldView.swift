//
//  PaymentCardFieldView.swift
//  BarakatWallet
//
//  Created by km1tj on 17/02/24.
//

import Foundation
import UIKit

class PaymentCardFieldView: UIView, UITextFieldDelegate {
    
    let titleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.regular(size: 16)
        view.text = "CARD_NUMBER_RECEIVER".localized
        return view
    }()
    let rootView: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.layer.borderColor = Theme.current.secondTintColor.withAlphaComponent(0.3).cgColor
        view.layer.borderWidth = 0.5
        view.startColor = Theme.current.mainGradientStartColor
        view.endColor = Theme.current.mainGradientEndColor
        return view
    }()
    let cardNumerField: PaddingTextField = {
        let view = PaddingTextField()
        view.padding = .init(top: 0, left: 16, bottom: 0, right: 16)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.attributedPlaceholder = NSAttributedString(string: "1111-1111-1111-1111", attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryTextColor])
        view.keyboardType = .numberPad
        view.returnKeyType = .done
        view.font = UIFont.medium(size: 17)
        view.borderStyle = .none
        view.layer.cornerRadius = 14
        view.backgroundColor = Theme.current.plainTableBackColor
        view.clipsToBounds = true
        return view
    }()
    let cardImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.titleView)
        self.addSubview(self.rootView)
        self.rootView.addSubview(self.cardNumerField)
        self.rootView.addSubview(self.cardImageView)
        NSLayoutConstraint.activate([
            self.titleView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.titleView.topAnchor.constraint(equalTo: self.topAnchor),
            self.titleView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.titleView.heightAnchor.constraint(equalToConstant: 20),
            self.rootView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.rootView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 10),
            self.rootView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.rootView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.cardNumerField.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 20),
            self.cardNumerField.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 23),
            self.cardNumerField.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -20),
            self.cardNumerField.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -23),
            self.cardImageView.rightAnchor.constraint(equalTo: self.cardNumerField.rightAnchor, constant: -10),
            self.cardImageView.centerYAnchor.constraint(equalTo: self.cardNumerField.centerYAnchor),
            self.cardImageView.heightAnchor.constraint(equalTo: self.cardNumerField.heightAnchor, multiplier: 0.7),
            self.cardImageView.widthAnchor.constraint(equalTo: self.cardImageView.heightAnchor, multiplier: 1.5),
        ])
        self.cardNumerField.addTarget(self, action: #selector(reformatAsCardNumber), for: [.editingChanged])
        self.cardNumerField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.cardNumerField {
            self.previousTextFieldContent = textField.text
            self.previousSelection = textField.selectedTextRange
            return true
        }
        return false
    }
    
    @objc func reformatAsCardNumber(textField: UITextField) {
        if textField == self.cardNumerField {
            var targetCursorPosition = 0
            if let startPosition = textField.selectedTextRange?.start {
                targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
            }
            var cardNumberWithoutSpaces = ""
            if let text = textField.text {
                cardNumberWithoutSpaces = CardTypes.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
            }
            if cardNumberWithoutSpaces.count > 16 {
                textField.text = self.previousTextFieldContent
                textField.selectedTextRange = self.previousSelection
                return
            }
            let cardNumberWithSpaces = CardTypes.insertCreditCardSpaces(cardNumberWithoutSpaces, preserveCursorPosition: &targetCursorPosition)
            textField.text = cardNumberWithSpaces.0
            self.cardImageView.image = cardNumberWithSpaces.1?.image
            if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
                textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
            }
        }
    }
}
