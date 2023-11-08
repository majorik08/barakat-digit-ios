//
//  TransferRootViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 22/10/23.
//

import Foundation
import UIKit
import PhoneNumberKit

class TransferReceiverViewController: BaseViewController, UITabBarControllerDelegate, UITextFieldDelegate {
    
    let topBar: TransferTopView = {
        let view = TransferTopView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backButton.tintColor = .white
        view.titleLabel.text = "MONEY_TRANSERS".localized
        view.subTitleLabel.text = ""
        return view
    }()
    let cardNumerField: CardTextFiled = {
        let view = CardTextFiled()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topLabel.text = "CARD_NUMBER_RECEIVER".localized
        view.textField.textColor = Theme.current.primaryTextColor
        view.textField.minimumFontSize = 14
        view.textField.adjustsFontSizeToFitWidth = true
        view.textField.attributedPlaceholder = NSAttributedString(string: "1111-1111-1111-1111", attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryTextColor])
        view.textField.keyboardType = .numberPad
        view.textField.returnKeyType = .done
        return view
    }()
    let numberView: CardTextFiled = {
        let view = PhoneNumberTextField(withPhoneNumberKit: Constants.phoneNumberKit)
        let filedView = CardTextFiled(textField: view)
        filedView.topLabel.text = "PHONE_NUMBER_RECEIVER".localized
        filedView.translatesAutoresizingMaskIntoConstraints = false
        filedView.rightImage.image = UIImage(name: .add_number)
        view.withFlag = false
        view.withPrefix = true
        view.withExamplePlaceholder = true
        view.leftViewMode = .always
        view.keyboardType = UIKeyboardType.phonePad
        view.borderStyle = .none
        view.attributedPlaceholder = NSAttributedString(string: "+992 918 00 00 00", attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryTextColor])
        return filedView
    }()
    let bottomAuthLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 16)
        view.textColor = Theme.current.primaryTextColor
        view.text = "RECEIVER_NOT_CARD_ANSWER".localized
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    let bottomAuthHintLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 14)
        view.textColor = Theme.current.secondaryTextColor
        view.text = "RECEIVER_ORDER_CARD_HELP".localized
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    let nextButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.radius = 14
        view.setTitle("CONTINUE".localized, for: .normal)
        view.isEnabled = false
        return view
    }()
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    weak var delegate: TransferSumViewControllerDelegate?
    weak var coordinator: TransferCoordinator?
    var pickMode: Bool = false
    var type: TransferType
    var sender: TransferIdentifier
    var cards: [CardTypes] = {
        return [.AmericanExpress, .DinersClub, .MasterCard, .Viza, .UnionPay]
    }()
    
    init(type: TransferType, sender: TransferIdentifier, delegate: TransferSumViewControllerDelegate?) {
        self.type = type
        self.sender = sender
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.topBar)
        self.view.addSubview(self.nextButton)
        let enterView: UIView
        switch self.type {
        case .byCard:
            enterView = self.cardNumerField
            self.view.addSubview(self.cardNumerField)
            self.topBar.subTitleLabel.text = "TRANSFER_BY_CARD_INFO".localized
            self.bottomAuthLabel.isHidden = false
            self.bottomAuthHintLabel.isHidden = false
        case .byNumber:
            enterView = self.numberView
            self.view.addSubview(self.numberView)
            self.topBar.subTitleLabel.text = "TRANSFER_BY_NUMBER_INFO".localized
            self.bottomAuthLabel.isHidden = true
            self.bottomAuthHintLabel.isHidden = true
        }
        self.view.addSubview(self.bottomAuthLabel)
        self.view.addSubview(self.bottomAuthHintLabel)
        NSLayoutConstraint.activate([
            self.topBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.topBar.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.topBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.topBar.heightAnchor.constraint(equalToConstant: 160),
            enterView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24),
            enterView.topAnchor.constraint(equalTo: self.topBar.bottomAnchor, constant: 30),
            enterView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24),
            enterView.heightAnchor.constraint(equalToConstant: 74),
            
            self.bottomAuthLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24),
            self.bottomAuthLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24),
            self.bottomAuthHintLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24),
            self.bottomAuthHintLabel.topAnchor.constraint(equalTo: self.bottomAuthLabel.bottomAnchor, constant: 10),
            self.bottomAuthHintLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24),
            self.bottomAuthHintLabel.bottomAnchor.constraint(equalTo: self.nextButton.topAnchor, constant: -30),
            self.nextButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24),
            self.nextButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24),
            self.nextButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            self.nextButton.heightAnchor.constraint(equalToConstant: 56),
        ])
        self.cardNumerField.textField.addTarget(self, action: #selector(reformatAsCardNumber), for: [.editingChanged])
        self.cardNumerField.textField.delegate = self
        self.numberView.textField.addTarget(self, action: #selector(reformatAsCardNumber), for: [.editingChanged])
        self.numberView.textField.delegate = self
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard)))
        self.topBar.backButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        self.nextButton.addTarget(self, action: #selector(self.goToSum), for: .touchUpInside)
    }
    
    override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
        self.topBar.themeChanged(newTheme: newTheme)
    }
    
    @objc func goBack() {
        self.coordinator?.navigateBack()
    }
    
    @objc func goToSum() {
        if let delegate = self.delegate {
            delegate.receiverPicked(receiver: .card(number: "3422342342"))
            self.coordinator?.navigateBack()
        } else {
            self.coordinator?.navigateToEnterSum(type: self.type, sender: self.sender, receiver: .card(number: "dasdasdasd"))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.checkFields() {
            self.view.endEditing(true)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.cardNumerField.textField {
            self.previousTextFieldContent = textField.text
            self.previousSelection = textField.selectedTextRange
            return true
        } else if textField == self.numberView.textField {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 20
        }
        return false
    }
    
    func checkFields() -> Bool {
        switch self.type {
        case .byCard:
            guard let cardNumber = self.cardNumerField.textField.text?.digits, cardNumber.count >= 14 else {
                self.nextButton.isEnabled = false
                return false
            }
        case .byNumber:
            guard let cardNumber = self.numberView.textField.text?.digits, cardNumber.count >= 8 else {
                self.nextButton.isEnabled = false
                return false
            }
        }
        self.nextButton.isEnabled = true
        return true
    }
    
    @objc func reformatAsCardNumber(textField: UITextField) {
        if textField == self.cardNumerField.textField {
            var targetCursorPosition = 0
            if let startPosition = textField.selectedTextRange?.start {
                targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
            }
            var cardNumberWithoutSpaces = ""
            if let text = textField.text {
                cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
            }
            if cardNumberWithoutSpaces.count > 13 {
                if cardNumberWithoutSpaces.count > 16 {
                    textField.text = self.previousTextFieldContent
                    textField.selectedTextRange = self.previousSelection
                    if self.checkFields() {
                        self.cardNumerField.textField.resignFirstResponder()
                    }
                    return
                }
            }
            let cardNumberWithSpaces = self.insertCreditCardSpaces(cardNumberWithoutSpaces, preserveCursorPosition: &targetCursorPosition)
            textField.text = cardNumberWithSpaces
            if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
                textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
            }
        } else if textField == self.numberView.textField {
            if self.checkFields() {
                if let s = textField as? PhoneNumberTextField, s.isValidNumber {
                    self.numberView.textField.resignFirstResponder()
                }
            }
        }
    }
    
    func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var digitsOnlyString = ""
        let originalCursorPosition = cursorPosition
        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            if characterToAdd >= "0" && characterToAdd <= "9" {
                digitsOnlyString.append(characterToAdd)
            } else if i < originalCursorPosition {
                cursorPosition -= 1
            }
        }
        return digitsOnlyString
    }
    
    func insertCreditCardSpaces(_ creditCard: String, preserveCursorPosition cursorPosition: inout Int) -> String {
        var card: CardTypes? = nil
        for cardItem in self.cards {
            if self.regexCheck(pattern: cardItem.pattern, text: creditCard) {
                card = cardItem
            }
        }
        if let card = card {
            self.cardNumerField.rightImage.image = card.image
        } else {
            self.cardNumerField.rightImage.image = nil
        }
        let is464 = card == .DinersClub
        let is456 = card == .AmericanExpress
        let is4444 = !(is464 || is456)
        var stringWithAddedSpaces = ""
        let cursorPositionInSpacelessString = cursorPosition
        for i in 0..<creditCard.count {
            let needs464Spacing = (is464 && (i == 4 || i == 10 || i == 14))
            let needs456Spacing = (is456 && (i == 4 || i == 9 || i == 15))
            let needs4444Spacing = (is4444 && i > 0 && (i % 4) == 0)
            if needs464Spacing || needs456Spacing || needs4444Spacing {
                stringWithAddedSpaces.append(" ")
                if i < cursorPositionInSpacelessString {
                    cursorPosition += 1
                }
            }
            let characterToAdd = creditCard[creditCard.index(creditCard.startIndex, offsetBy:i)]
            stringWithAddedSpaces.append(characterToAdd)
        }
        return stringWithAddedSpaces
    }
    
    func regexCheck(pattern: String, text: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            let match = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, text.count))
            return match != nil
        } catch {
            return false
        }
    }
}
