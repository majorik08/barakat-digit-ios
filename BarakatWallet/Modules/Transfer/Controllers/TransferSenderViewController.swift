//
//  TransferSenderViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 24/10/23.
//

import Foundation
import UIKit

enum CardTypes: String {
    case Viza = "viza"
    case MasterCard = "mastercard"
    case AmericanExpress = "amex"
    case UnionPay = "unionpay"
    case DinersClub = "dinersclub"
    
    var pattern: String {
        switch self {
        case .Viza: return "^4[0-9]{1,15}$"
        case .MasterCard: return "^5[1-5][0-9]{0,14}$"
        case .AmericanExpress: return "^3[47][0-9]{0,13}$"
        case .UnionPay: return "^62[0-9]{0,14}$"
        case .DinersClub: return "^3(?:0[0-5,9]|[689][0-9])[0-9]{0,11}$"
        }
    }
    var tag: Int {
        switch self {
        case .Viza: return 1
        case .MasterCard: return 2
        case .AmericanExpress: return 3
        case .UnionPay: return 4
        case .DinersClub: return 5
        }
    }
    var image: UIImage? {
        switch self {
        case .Viza:
            return UIImage(name: .card_visa)
        case .MasterCard:
            return UIImage(name: .card_master)
        case .AmericanExpress:
            return UIImage(name: .card_american)
        case .UnionPay:
            return UIImage(name: .card_union)
        case .DinersClub:
            return UIImage(name: .card_diners)
        }
    }
    //visa = ["4"] // length = 16 format = 4-4-4-4
    //masterCard =  ["51", "52", "53", "54", "55"] // length = 16 format = 4-4-4-4
    //amex = ["34", "37"] // length = 15 format = 4-5-6
    //union = ["62"] // length = 16 format = 4-4-4-4
    //dinersClub = ["300", "301", "302", "303", "304", "305", "309", "36", "38", "39"] // length = 14 format = 4-6-4
}

class TransferSenderViewController: BaseViewController, UITextFieldDelegate {
    
    let topBar: TransferTopView = {
        let view = TransferTopView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backButton.tintColor = .white
        view.titleLabel.text = "MONEY_TRANSERS".localized
        view.subTitleLabel.text = ""
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
    let cardNumerField: CardTextFiled = {
        let view = CardTextFiled()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topLabel.text =  "SENDER_CARD_NUMBER".localized
        view.textField.textColor = Theme.current.primaryTextColor
        view.textField.minimumFontSize = 14
        view.textField.adjustsFontSizeToFitWidth = true
        view.textField.attributedPlaceholder = NSAttributedString(string: "1111-1111-1111-1111", attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryTextColor])
        view.textField.keyboardType = .numberPad
        view.textField.returnKeyType = .done
        //view.textField.textContentType = UITextContentType.creditCardNumber
        return view
    }()
    let cardDateField: CardTextFiled = {
        let view = CardTextFiled()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topLabel.text =  "CARD_DATE".localized
        view.textField.attributedPlaceholder = NSAttributedString(string: "12/24", attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryTextColor])
        view.textField.textColor = Theme.current.primaryTextColor
        view.textField.keyboardType = .numberPad
        view.textField.returnKeyType = .done
        return view
    }()
    let cardCvvField: CardTextFiled = {
        let view = CardTextFiled()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topLabel.text = "CVC/CVV"
        view.textField.attributedPlaceholder = NSAttributedString(string: "123", attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryTextColor])
        view.textField.textColor = Theme.current.primaryTextColor
        view.textField.keyboardType = .numberPad
        view.textField.returnKeyType = .done
        view.textField.enablesReturnKeyAutomatically = true
        return view
    }()
    let secureTextLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 11)
        view.textColor = Theme.current.secondaryTextColor
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.text = "CARD_INFO_SEND_SECURE".localized
        return view
    }()
    var type: TransferType
    weak var delegate: TransferSumViewControllerDelegate?
    weak var coordinator: TransferCoordinator?
    var cards: [CardTypes] = {
        return [.AmericanExpress, .DinersClub, .MasterCard, .Viza, .UnionPay]
    }()
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    
    init(type: TransferType, delegate: TransferSumViewControllerDelegate?) {
        self.type = type
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
        self.view.addSubview(self.cardNumerField)
        self.view.addSubview(self.cardDateField)
        self.view.addSubview(self.cardCvvField)
        self.view.addSubview(self.secureTextLabel)
        NSLayoutConstraint.activate([
            self.topBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.topBar.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.topBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.topBar.heightAnchor.constraint(equalToConstant: 160),
            self.nextButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24),
            self.nextButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24),
            self.nextButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            self.nextButton.heightAnchor.constraint(equalToConstant: 56),
            self.cardNumerField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24),
            self.cardNumerField.topAnchor.constraint(equalTo: self.topBar.bottomAnchor, constant: 30),
            self.cardNumerField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24),
            self.cardNumerField.heightAnchor.constraint(equalToConstant: 74),
            self.cardDateField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24),
            self.cardDateField.topAnchor.constraint(equalTo: self.cardNumerField.bottomAnchor, constant: 20),
            self.cardDateField.rightAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -10),
            self.cardDateField.heightAnchor.constraint(equalToConstant: 74),
            self.cardCvvField.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 10),
            self.cardCvvField.topAnchor.constraint(equalTo: self.cardNumerField.bottomAnchor, constant: 20),
            self.cardCvvField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24),
            self.cardCvvField.heightAnchor.constraint(equalToConstant: 74),
            self.secureTextLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24),
            self.secureTextLabel.topAnchor.constraint(equalTo: self.cardDateField.bottomAnchor, constant: 20),
            self.secureTextLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24)
        ])
        self.topBar.backButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        self.nextButton.addTarget(self, action: #selector(self.goToReceiver), for: .touchUpInside)
        switch self.type {
        case .byNumber:
            self.topBar.subTitleLabel.text = "TRANSFER_BY_NUMBER_INFO".localized
        case .byCard:
            self.topBar.subTitleLabel.text = "TRANSFER_BY_CARD_INFO".localized
        }
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard)))
        self.cardNumerField.textField.delegate = self
        self.cardCvvField.textField.delegate = self
        self.cardDateField.textField.delegate = self
        self.cardNumerField.textField.addTarget(self, action: #selector(reformatAsCardNumber), for: [.editingChanged])
        self.cardCvvField.textField.addTarget(self, action: #selector(reformatAsCardNumber), for: [.editingChanged])
        self.cardDateField.textField.addTarget(self, action: #selector(reformatAsCardNumber), for: [.editingChanged])
    }
    
    @objc func goBack() {
        self.coordinator?.navigateBack()
    }
    
    @objc func goToReceiver() {
        if let delegate = self.delegate {
            delegate.senderPicked(sender: .card(number: "342342342342"))
            self.coordinator?.navigateBack()
        } else {
            self.coordinator?.navigateToPickReceiver(type: self.type, sender: .card(number: "342342342342"), delegate: nil)
        }
    }
    
//    @objc func applyPayment() {
//        guard let cardNumber = self.cardNumberField.text?.digits, cardNumber.count >= 14 else {
//            self.snackView(viewToShake: self.cardNumberField)
//            return
//        }
//        guard let expDate = self.cardDateField.text, expDate.count == 5, self.regexCheck(pattern: "(0[1-9]|1[0-2]{1})\\/(1[8-9]|[2-9][0-9])$", text: expDate) else {
//            self.snackView(viewToShake: self.cardDateField)
//            return
//        }
//        guard let cscCode = self.cardCscField.text, cscCode.count == 3, self.regexCheck(pattern: "[0-9]{3}$", text: cscCode) else {
//            self.snackView(viewToShake: self.cardCscField)
//            return
//        }
//        //let paymentReq = PaymentRequestParams.CreditCardPaymentRequest(phoneNumber: self.phoneNumber, cardNumber: Int(cardNumber) ?? 0, expirationDate: expDate, cardCode: Int(cscCode) ?? 0, amount: self.amount, currency: .USD)
//    }
    
    override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
        self.topBar.themeChanged(newTheme: newTheme)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.cardNumerField.textField {
            self.previousTextFieldContent = textField.text
            self.previousSelection = textField.selectedTextRange
            return true
        } else if textField == self.cardDateField.textField {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 5
        } else if textField == self.cardCvvField.textField {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 3
        }
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.checkFields() {
            self.view.endEditing(true)
        }
    }
    
    func checkFields() -> Bool {
        guard let cardNumber = self.cardNumerField.textField.text?.digits, cardNumber.count >= 14 else {
            self.nextButton.isEnabled = false
            return false
        }
        guard let expDate = self.cardDateField.textField.text, expDate.count == 5 else {
            self.nextButton.isEnabled = false
            return false
        }
        guard let cscCode = self.cardCvvField.textField.text, cscCode.count == 3 else {
            self.nextButton.isEnabled = false
            return false
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
                    } else {
                        self.cardDateField.textField.becomeFirstResponder()
                    }
                    return
                }
            }
            let cardNumberWithSpaces = self.insertCreditCardSpaces(cardNumberWithoutSpaces, preserveCursorPosition: &targetCursorPosition)
            textField.text = cardNumberWithSpaces
            if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
                textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
            }
        } else if textField == self.cardDateField.textField {
            var targetCursorPosition = 0
            if let startPosition = textField.selectedTextRange?.start {
                targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
            }
            var cardNumberWithoutSpaces = ""
            if let text = textField.text {
                cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
            }
            if cardNumberWithoutSpaces.count > 4 {
                return
            }
            var cardNumberWithSpaces = ""
            for i in 0..<cardNumberWithoutSpaces.count {
                if i == 2 {
                    cardNumberWithSpaces.append("/")
                    if i < targetCursorPosition {
                        targetCursorPosition += 1
                    }
                }
                let characterToAdd = cardNumberWithoutSpaces[cardNumberWithoutSpaces.index(cardNumberWithoutSpaces.startIndex, offsetBy:i)]
                cardNumberWithSpaces.append(characterToAdd)
            }
            textField.text = cardNumberWithSpaces
            if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
                textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
            }
            if cardNumberWithSpaces.count >= 5 {
                if self.regexCheck(pattern: "(0[1-9]|1[0-2]{1})\\/(1[8-9]|[2-9][0-9])$", text: cardNumberWithSpaces) {
                    if self.checkFields() {
                        self.cardDateField.textField.resignFirstResponder()
                    } else {
                        self.cardCvvField.textField.becomeFirstResponder()
                    }
                } else {
                    self.snackView(viewToShake: self.cardDateField)
                }
            }
        } else if textField == self.cardCvvField.textField {
            var targetCursorPosition = 0
            if let startPosition = textField.selectedTextRange?.start {
                targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
            }
            var cardNumberWithoutSpaces = ""
            if let text = textField.text {
                cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
            }
            textField.text = cardNumberWithoutSpaces
            if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
                textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
            }
            if cardNumberWithoutSpaces.count >= 3 {
                if self.regexCheck(pattern: "[0-9]{3}$", text: cardNumberWithoutSpaces) {
                    if self.checkFields() {
                        self.cardCvvField.textField.resignFirstResponder()
                    }
                } else {
                    self.snackView(viewToShake: self.cardCvvField)
                }
            }
        }
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
            return false
        }
    }
}
