//
//  CurrencyFormatField.swift
//  BarakatWallet
//
//  Created by km1tj on 17/02/24.
//

import Foundation
import UIKit

protocol CurrencyFormatFieldDelegate: AnyObject {
    func currencyFieldDidChanged()
}

class CurrencyFormatField: UIView, UITextFieldDelegate {
 
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        return formatter
    }()
    let textField: ClosestPositionField = {
        let view = ClosestPositionField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = ""
        view.placeholder = "0"
        view.textAlignment = .left
        view.keyboardType = .decimalPad
        view.borderStyle = .none
        return view
    }()
    let currencyView: UITextField = {
        let view = UITextField()
        view.text = ""
        view.placeholder = ""
        view.isUserInteractionEnabled = false
        view.isEnabled = false
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        view.borderStyle = .none
        view.inputView = UIView(frame: .zero)
        return view
    }()
    var font: UIFont? = nil {
        didSet {
            self.textField.font = font
            self.currencyView.font = font
        }
    }
    var textColor: UIColor? = nil {
        didSet {
            self.textField.textColor = textColor
            self.currencyView.textColor = textColor
        }
    }
    var currency: CurrencyEnum = .TJS {
        didSet {
            let locale = Locale.current
            let str = locale.localizedCurrencySymbol(currency: currency)
            self.currencyView.text = str ?? currency.description
        }
    }
    private var alwaysShowFractions: Bool = false
    private var numberOfDecimalPlaces: Int = 2
    private var internalValue: Double?
    var value: Double? {
        didSet {
            self.delegate?.currencyFieldDidChanged()
        }
    }
    
    weak var delegate: CurrencyFormatFieldDelegate?
    
    init(insets: UIEdgeInsets = .zero) {
        super.init(frame: .zero)
        self.isUserInteractionEnabled = true
        self.addSubview(self.textField)
        self.addSubview(self.currencyView)
        NSLayoutConstraint.activate([
            self.textField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: insets.left),
            self.textField.topAnchor.constraint(equalTo: self.topAnchor, constant: insets.top),
            self.textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: insets.bottom),
            self.currencyView.leftAnchor.constraint(equalTo: self.textField.rightAnchor, constant: 4),
            self.currencyView.topAnchor.constraint(equalTo: self.topAnchor, constant: insets.top),
            self.currencyView.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -insets.right),
            self.currencyView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: insets.bottom),
        ])
        self.textField.delegate = self
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapped)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapped() {
        self.textField.becomeFirstResponder()
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get new value
        let originalText = textField.text
        let text = textField.text as NSString?
        let newValue = text?.replacingCharacters(in: range, with: string)
        let display = newValue != nil ? self.currencyFormat(str: newValue!, decimalPlaces: self.numberOfDecimalPlaces) : nil
        // validate change
        if !self.shouldAllowChange(oldValue: textField.text ?? "", newValue: newValue ?? "") {
            return false
        }
        // update binding variable
        self.value = newValue?.double ?? 0
        self.internalValue = value
        // don't move cursor if nothing changed (i.e. entered invalid values)
        if textField.text == display && string.count > 0 {
            return false
        }
        // update textfield display
        textField.text = display
        // calculate and update cursor position
        // update cursor position
//        let beginningPosition = textField.beginningOfDocument
//        var numberOfCharactersAfterCursor: Int
//        if string.count == 0 && originalText == display {
//            // if deleting and nothing changed, use lower bound of range
//            // to allow cursor to move backwards
//            numberOfCharactersAfterCursor = (originalText?.count ?? 0) - range.lowerBound
//        } else {
//            numberOfCharactersAfterCursor = (originalText?.count ?? 0) - range.upperBound
//        }
//        let offset = (display?.count ?? 0) - numberOfCharactersAfterCursor
//        let cursorLocation = textField.position(from: beginningPosition, offset: offset)
//        if let cursorLoc = cursorLocation {
//            /**
//              Shortly after new text is being pasted from the clipboard, UITextField receives a new value for its
//              `selectedTextRange` property from the system. This new range is not consistent to the formatted text and
//              calculated caret position most of the time, yet it's being assigned just after setCaretPosition call.
//              
//              To insure correct caret position is set, `selectedTextRange` is assigned asynchronously.
//              (presumably after a vanishingly small delay)
//              */
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
//                textField.selectedTextRange = textField.textRange(from: cursorLoc, to: cursorLoc)
//             }
//        }
        // prevent from going to didChange
        // all changes to textfield already made
        return false
    }
            
    func shouldAllowChange(oldValue: String, newValue: String) -> Bool {
        // return if already has decimal
        if newValue.numberOfDecimalPoints > 1 {
            return false
        }
        // limits integers length
        if newValue.integers.count > 9 {
            return false
        }
        // limits fractions length
        if newValue.fractions?.count ?? 0 > self.numberOfDecimalPlaces {
            return false
        }
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let v = self.value {
            textField.text = self.currencyFormat(dbl: v, decimalPlaces: self.numberOfDecimalPlaces, forceShowDecimalPlaces: self.alwaysShowFractions)
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    private func currencyFormat(dbl: Double, decimalPlaces: Int? = nil, forceShowDecimalPlaces: Bool = false) -> String? {
        var integer = 0.0
        let d = decimalPlaces != nil ? decimalPlaces! : 2
        if forceShowDecimalPlaces {
            self.formatter.minimumFractionDigits = d
            self.formatter.maximumFractionDigits = d
        } else {
            // show fractions if exist
            let fraction = modf(dbl, &integer)
            if fraction > 0 {
                self.formatter.maximumFractionDigits = d
            } else {
                self.formatter.maximumFractionDigits = 0
            }
        }
        return self.formatter.string(from: NSNumber(value: dbl))
    }
    
    private func currencyFormat(str: String, decimalPlaces: Int? = nil) -> String? {
        guard let double = str.double else {
            return nil
        }
        // if has fractions, show fractions
        if str.fractions != nil {
            // the number of decimal points in the string
            let fractionDigits = str.fractions?.count ?? 0
            // limited to the decimalPlaces specified in the argument
            self.formatter.minimumFractionDigits = min(fractionDigits, decimalPlaces != nil ? decimalPlaces! : 2)
            self.formatter.maximumFractionDigits = min(fractionDigits, decimalPlaces != nil ? decimalPlaces! : 2)
            let formatted = self.formatter.string(from: NSNumber(value: double))
            // show dot if exists
            if let formatted = formatted, fractionDigits == 0 {
                return "\(formatted)" + (Locale.current.decimalSeparator ?? ".")
            }
            return formatted
        }
        self.formatter.maximumFractionDigits = 0
        let formatted = self.formatter.string(from: NSNumber(value: double))
        return formatted
    }
}
