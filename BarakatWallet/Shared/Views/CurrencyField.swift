//
//  CurrencyEnterView.swift
//  BarakatWallet
//
//  Created by km1tj on 15/02/24.
//

import Foundation
import UIKit

class CurrencyField: UIView, UITextFieldDelegate {
    
    let field: ClosestPositionField = {
        let view = ClosestPositionField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = ""
        view.placeholder = "0"
        view.textAlignment = .right
        view.keyboardType = .decimalPad
        //view.adjustsFontSizeToFitWidth = true
        //view.contentScaleFactor = 1
        view.borderStyle = .none
        //view.setContentCompressionResistancePriority(.init(1002), for: .horizontal)
        //view.setContentHuggingPriority(.init(1002), for: .horizontal)
        return view
    }()
    let rightView: ClosestPositionField = {
        let view = ClosestPositionField()
        view.text = ""
        view.placeholder = ""
        view.isUserInteractionEnabled = false
        view.isEnabled = false
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adjustsFontSizeToFitWidth = true
        view.contentScaleFactor = 0.6
        view.borderStyle = .none
        //view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        //view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.inputView = UIView(frame: .zero)
        return view
    }()
    
    var font: UIFont? = nil {
        didSet {
            self.field.font = font
            self.rightView.font = font
        }
    }
    var textColor: UIColor? = nil {
        didSet {
            self.field.textColor = textColor
            self.rightView.textColor = textColor
        }
    }
    
    var passTextFieldText: ((String, Double?) -> Void)?
    var currency: CurrencyEnum? {
        didSet {
            let cur = currency ?? .USD
            let locale = Locale.current
            let str = locale.localizedCurrencySymbol(currency: cur)
            self.rightView.text = str ?? cur.description
        }
    }
    private var isSymbolOnRight = false
    var amountAsDouble: Double?
    var startingValue: Double? {
        didSet {
            self.amountAsDouble = startingValue
            if let a = startingValue, a > 0 {
                self.field.text = "\(String(format: "%.2f", a))"
            } else {
                self.field.text = ""
            }
            //self.field.text = "\(Decimal(startingValue ?? 0.0))"
        }
    }
    
    enum Alignment {
        case center
        case right
        case left
    }
    
    init(insets: UIEdgeInsets = .zero, aligment: Alignment) {
        super.init(frame: .zero)
        self.isUserInteractionEnabled = true
        self.addSubview(self.field)
        self.addSubview(self.rightView)
        NSLayoutConstraint.activate([
            self.field.leftAnchor.constraint(equalTo: self.leftAnchor, constant: insets.left),
            self.field.topAnchor.constraint(equalTo: self.topAnchor, constant: insets.top),
            self.field.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: insets.bottom),
            self.rightView.leftAnchor.constraint(equalTo: self.field.rightAnchor, constant: 4),
            self.rightView.topAnchor.constraint(equalTo: self.topAnchor, constant: insets.top),
            self.rightView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -insets.right),
            self.rightView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: insets.bottom),
        ])
        self.field.delegate = self
        self.field.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapped)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapped() {
        self.field.becomeFirstResponder()
    }
    
    @objc func textFieldDidChange() {
        let resut = self.updateTextField()
        self.amountAsDouble = resut.amount
        self.field.text = resut.text
        self.passTextFieldText?(self.field.text!, self.amountAsDouble)
    }
    
    public func updateTextField() -> (text: String, amount: Double) {
        var cleanedAmount = ""
        for character in self.field.text ?? "" {
            if character.isNumber {
                cleanedAmount.append(character)
            } else if character == "." {
                cleanedAmount.append(".")
            } else if character == "," {
                cleanedAmount.append(".")
            }
        }
        let amountAsNumber = Double(cleanedAmount) ?? 0.0
        return (text: cleanedAmount, amount: amountAsNumber)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return self.shouldChangeCharactersIn(textField, string: string)
    }
    
    private func shouldChangeCharactersIn(_ textField: UITextField, string: String) -> Bool {
        let newAdd = string == "," ? "." : string
        let str = "\(textField.text ?? "")\(newAdd)"
        let currency = self.currency ?? .USD
        let components = str.components(separatedBy: ".")
        if components.count == 2, components[1].count > currency.minorUnit {
            return false
        }
        if let _ = Double(str) {
            return true
        } else if string == "" {
            return true
        }
        return false
    }
    
    func insertText(_ text: String) {
        if self.shouldChangeCharactersIn(self.field, string: text) {
            self.field.insertText(text)
        }
    }
    
    func deleteBackward() {
        self.field.deleteBackward()
    }
}
class ClosestPositionField: UITextField {
    override func closestPosition(to point: CGPoint) -> UITextPosition? {
        let beginning = self.beginningOfDocument
        let end = self.position(from: beginning, offset: self.text?.count ?? 0)
        return end
    }
}
