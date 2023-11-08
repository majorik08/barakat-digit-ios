//
//  FloatingLabeledTextField.swift
//  BarakatWallet
//
//  Created by km1tj on 24/10/23.
//

import Foundation
import UIKit

class FloatingLabeledTextField: UITextField {

    var floatingLabel: UILabel!
    var placeHolderText: String?

    var floatingLabelColor: UIColor = UIColor.blue {
        didSet {
            self.floatingLabel.textColor = floatingLabelColor
        }
    }
    var floatingLabelFont: UIFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            self.floatingLabel.font = floatingLabelFont
        }
    }
    var floatingLabelHeight: CGFloat = 30

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.clipsToBounds = true
        self.borderStyle = .none
        self.layer.borderColor = Theme.current.tintColor.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 14
        
        
        let flotingLabelFrame = CGRect(x: 0, y: 0, width: frame.width, height: 0)
        floatingLabel = UILabel(frame: flotingLabelFrame)
        floatingLabel.textColor = floatingLabelColor
        floatingLabel.font = floatingLabelFont
        floatingLabel.text = self.placeholder
        self.addSubview(floatingLabel)
        placeHolderText = placeholder
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: UITextField.textDidBeginEditingNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: UITextField.textDidEndEditingNotification, object: self)
    }

    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.text == "" {
            UIView.animate(withDuration: 0.3) {
                self.floatingLabel.frame = CGRect(x: 0, y: -self.floatingLabelHeight, width: self.frame.width, height: self.floatingLabelHeight)
            }
            self.placeholder = ""
        }
    }

    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        if self.text == "" {
            UIView.animate(withDuration: 0.1) {
               self.floatingLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0)
            }
            self.placeholder = placeHolderText
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
