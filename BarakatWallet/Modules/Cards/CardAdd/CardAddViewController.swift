//
//  CardAddViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 08/11/23.
//

import Foundation
import UIKit
import RxSwift

class CardAddViewController: BaseViewController, UITextFieldDelegate {
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alwaysBounceVertical = true
        view.keyboardDismissMode = .interactive
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        return view
    }()
    private let rootView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let cardView: CardView = {
        let view = CardView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setColors()
        return view
    }()
    private let colorSelectorView: ColorOptionView = {
        let view = ColorOptionView(frame: .zero)
        view.titleView.text = "CARD_CHANGE_COLOR".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let cardNumerField: BaseTextFiled = {
        let view = BaseTextFiled()
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
    let cardDateField: BaseTextFiled = {
        let view = BaseTextFiled()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topLabel.text = "CARD_DATE".localized
        view.textField.attributedPlaceholder = NSAttributedString(string: "12/24", attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryTextColor])
        view.textField.textColor = Theme.current.primaryTextColor
        view.textField.keyboardType = .numberPad
        view.textField.returnKeyType = .done
        return view
    }()
    let cardCvvField: BaseTextFiled = {
        let view = BaseTextFiled()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topLabel.text = "CVC/CVV"
        view.textField.attributedPlaceholder = NSAttributedString(string: "123", attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryTextColor])
        view.textField.textColor = Theme.current.primaryTextColor
        view.textField.keyboardType = .numberPad
        view.textField.returnKeyType = .done
        view.textField.enablesReturnKeyAutomatically = true
        return view
    }()
    let cardPhoneNumber: BaseTextFiled = {
        let view = BaseTextFiled()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topLabel.text = "NAME_IN_CARD".localized
        view.textField.attributedPlaceholder = NSAttributedString(string: "NAME_IN_CARD".localized, attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryTextColor])
        view.textField.textColor = Theme.current.primaryTextColor
        view.textField.keyboardType = .default
        view.textField.returnKeyType = .done
        view.textField.enablesReturnKeyAutomatically = true
        return view
    }()
    private let nextButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.radius = 14
        view.setTitle("ADD_CARD".localized, for: .normal)
        view.isEnabled = true
        return view
    }()
    var nextButtonBottom: NSLayoutConstraint!
    
    let viewModel: CardsViewModel
    var selectedColor: (start: UIColor, end: UIColor)? = nil
    var cards: [CardTypes] = {
        return [.AmericanExpress, .DinersClub, .MasterCard, .Viza, .UnionPay, .kortimilli]
    }()
    weak var coordinator: CardsCoordinator? = nil
    
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    
    init(viewModel: CardsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "CARD_ADDING".localized
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.rootView)
        self.rootView.addSubview(self.cardView)
        self.rootView.addSubview(self.colorSelectorView)
        self.rootView.addSubview(self.cardNumerField)
        self.rootView.addSubview(self.cardDateField)
        self.rootView.addSubview(self.cardCvvField)
        self.rootView.addSubview(self.cardPhoneNumber)
        self.rootView.addSubview(self.nextButton)
        let rootHeight = self.rootView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        rootHeight.priority = UILayoutPriority(rawValue: 250)
        self.nextButtonBottom = self.nextButton.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -20)
        NSLayoutConstraint.activate([
            self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.rootView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.rootView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.rootView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            self.rootView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            rootView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            rootHeight,
            self.cardView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
            self.cardView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 0),
            self.cardView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
            self.cardView.heightAnchor.constraint(equalTo: self.cardView.widthAnchor, multiplier: 0.561797753, constant: 10),
            self.colorSelectorView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.colorSelectorView.topAnchor.constraint(equalTo: self.cardView.bottomAnchor, constant: 20),
            self.colorSelectorView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.colorSelectorView.heightAnchor.constraint(equalToConstant: 36),
            self.cardNumerField.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.cardNumerField.topAnchor.constraint(equalTo: self.colorSelectorView.bottomAnchor, constant: 20),
            self.cardNumerField.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.cardNumerField.heightAnchor.constraint(equalToConstant: 74),
            self.cardDateField.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.cardDateField.topAnchor.constraint(equalTo: self.cardNumerField.bottomAnchor, constant: 20),
            self.cardDateField.rightAnchor.constraint(equalTo: self.rootView.centerXAnchor, constant: -10),
            self.cardDateField.heightAnchor.constraint(equalToConstant: 74),
            self.cardCvvField.leftAnchor.constraint(equalTo: self.rootView.centerXAnchor, constant: 10),
            self.cardCvvField.topAnchor.constraint(equalTo: self.cardNumerField.bottomAnchor, constant: 20),
            self.cardCvvField.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.cardCvvField.heightAnchor.constraint(equalToConstant: 74),
            self.cardPhoneNumber.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.cardPhoneNumber.topAnchor.constraint(equalTo: self.cardCvvField.bottomAnchor, constant: 20),
            self.cardPhoneNumber.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.cardPhoneNumber.heightAnchor.constraint(equalToConstant: 74),
            self.nextButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.nextButton.topAnchor.constraint(greaterThanOrEqualTo: self.cardPhoneNumber.bottomAnchor, constant: 20),
            self.nextButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButtonBottom,
            self.nextButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
        ])
        self.rootView.isUserInteractionEnabled = true
        self.rootView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hideKeyView)))
        self.colorSelectorView.addTarget(self, action: #selector(self.optionTapped(_:)), for: .valueChanged)
        self.cardNumerField.textField.delegate = self
        self.cardDateField.textField.delegate = self
        self.cardCvvField.textField.delegate = self
        self.cardPhoneNumber.textField.delegate = self
        self.cardNumerField.textField.addTarget(self, action: #selector(reformatAsCardNumber), for: [.editingChanged])
        self.cardCvvField.textField.addTarget(self, action: #selector(reformatAsCardNumber), for: [.editingChanged])
        self.cardDateField.textField.addTarget(self, action: #selector(reformatAsCardNumber), for: [.editingChanged])
        self.cardPhoneNumber.textField.addTarget(self, action: #selector(reformatAsCardNumber), for: [.editingChanged])
        self.nextButton.addTarget(self, action: #selector(self.addCard), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func addCard() {
        let colorId = self.colorSelectorView.selectedColor + 1
        let dateStr = self.cardDateField.textField.text ?? ""
        let components = dateStr.split(separator: "/")
        if components.count == 2 {
            let monthString = String(components[0])
            let yearString = String(components[1])
            self.showProgressView()
            self.viewModel.cardService.addUserCard(cardHolder: self.cardPhoneNumber.textField.text ?? "", colorID: colorId,
                                                   cvv: self.cardCvvField.textField.text ?? "", pan: self.cardNumerField.textField.text?.digits ?? "",
                                                   validMonth: monthString, validYear: yearString)
                .observe(on: MainScheduler.instance)
                .subscribe { [weak self] _ in
                    guard let self = self else { return }
                    self.successProgress(text: "ADDED".localized)
                    self.coordinator?.navigateBack()
                } onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.hideProgressView()
                    self.showServerErrorAlert()
                }.disposed(by: self.viewModel.disposeBag)
        } else {
            //error
        }
    }
    
    @objc func optionTapped(_ sender: ColorOptionView) {
        let color = Constants.cardColors[sender.selectedColor]
        self.selectedColor = color
        self.cardView.setColors(selectedColor: color)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        var visibleHeight: CGFloat = 0
        if let userInfo = notification.userInfo {
            if let windowFrame = UIApplication.shared.keyWindow?.frame,
                let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                visibleHeight = windowFrame.intersection(keyboardRect).height
            }
        }
        self.nextButtonBottom.constant = -(visibleHeight - 20 + 2)
    }
     
    @objc func keyboardWillHide(_ notification: Notification) {
        self.nextButtonBottom.constant = -20
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.cardNumerField.textField {
            previousTextFieldContent = textField.text
            previousSelection = textField.selectedTextRange
            return true
        } else if textField == self.cardDateField.textField {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 5
        } else if textField == self.cardCvvField.textField {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 3
        } else if textField == self.cardPhoneNumber.textField {
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.checkFields() {
            view.endEditing(true)
        }
        return false
    }
    
    @objc func hideKeyView() {
        if self.checkFields() {
            view.endEditing(true)
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
        guard let phone = self.cardPhoneNumber.textField.text, phone.count >= 6 else {
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
            let cardNumberWithSpaces = self.insertCreditCardSpaces(cardNumberWithoutSpaces, preserveCursorPosition: &targetCursorPosition)
            textField.text = cardNumberWithSpaces
            self.cardView.cardNumberView.text = cardNumberWithSpaces
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
            self.cardView.cardExpireView.text = cardNumberWithSpaces
            if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
                textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
            }
            if cardNumberWithSpaces.count >= 5 {
                //if self.regexCheck(pattern: "(0[1-9]|1[0-2]{1})\\/(1[8-9]|[2-9][0-9])$", text: cardNumberWithSpaces) {
                if self.checkDate(text: cardNumberWithSpaces) {
                    if self.checkFields() {
                        self.cardDateField.textField.resignFirstResponder()
                    } else {
                        self.cardCvvField.textField.becomeFirstResponder()
                    }
                } else {
                    self.snackView(viewToShake: self.cardDateField.textField)
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
            self.cardView.cardCvvView.text = "CVV \(cardNumberWithoutSpaces)"
            textField.text = cardNumberWithoutSpaces
            if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
                textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
            }
            if cardNumberWithoutSpaces.count >= 3 {
                if self.regexCheck(pattern: "[0-9]{3}$", text: cardNumberWithoutSpaces) {
                    if self.checkFields() {
                        self.cardCvvField.textField.resignFirstResponder()
                    } else {
                        self.cardPhoneNumber.textField.becomeFirstResponder()
                    }
                } else {
                    self.snackView(viewToShake: self.cardCvvField.textField)
                }
            }
        } else if textField == self.cardPhoneNumber.textField {
            self.cardView.cardHolderView.text = textField.text ?? ""
            let _ = self.checkFields()
        }
    }
    
    func insertCreditCardSpaces(_ creditCard: String, preserveCursorPosition cursorPosition: inout Int) -> String {
        var card: CardTypes? = nil
        for cardItem in self.cards {
            if self.regexCheck(pattern: cardItem.pattern, text: creditCard) {
                card = cardItem
            }
        }
        self.cardView.cardTypeIconView.image = card?.image
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
            debugPrint(error)
            return false
        }
    }
    
    private func checkDate(text: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: Date())
        let currentYear = components.year!
        let currentMonth = components.month!
        if self.regexCheck(pattern: "(0[1-9]|1[0-2]{1})\\/(1[8-9]|[2-9][0-9])$", text: text) {
            if let date = dateFormatter.date(from: text), currentYear > calendar.component(.year, from: date)
                || (currentYear == calendar.component(.year, from: date) && currentMonth > calendar.component(.month, from: date)) {
                return false
            } else {
                return true
            }
        }
        return false
    }
}
