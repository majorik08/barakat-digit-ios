//
//  TransferSenderViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 24/10/23.
//

import Foundation
import UIKit
import RxSwift

class TransferSenderViewController: BaseViewController, UITextFieldDelegate, TransferConfirmViewDelegate, WalletWebViewControllerDelegate {
  
    private let topBar: TransferTopView = {
        let view = TransferTopView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backButton.tintColor = .white
        view.titleLabel.text = "MONEY_TRANSERS".localized
        view.subTitleLabel.text = ""
        return view
    }()
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
    private let nextButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.radius = 14
        view.setTitle("CONTINUE".localized, for: .normal)
        view.isEnabled = false
        return view
    }()
    private let cardNumerField: CardTextFiled = {
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
    private var nextButtonBottom: NSLayoutConstraint!
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    weak var coordinator: TransferCoordinator?
    let viewModel: TransferViewModel
    let type: TransferType
    let receiver: TransferIdentifier
    let commision: AppMethods.Transfers.GetTransgerData.GetTransgerDataResult.Commissions
    let plusAmount: Int
    let minusAmount: Int
    let commisionAmout: Int
    var cards: [CardTypes] = {
        return [.AmericanExpress, .DinersClub, .MasterCard, .Viza, .UnionPay, .kortimilli]
    }()
    
    init(viewModel: TransferViewModel, type: TransferType, receiver: TransferIdentifier, commision: AppMethods.Transfers.GetTransgerData.GetTransgerDataResult.Commissions, plusAmount: Int, minusAmount: Int, commisionAmout: Int) {
        self.type = type
        self.viewModel = viewModel
        self.receiver = receiver
        self.commision = commision
        self.plusAmount = plusAmount
        self.minusAmount = minusAmount
        self.commisionAmout = commisionAmout
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.topBar)
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.rootView)
        self.rootView.addSubview(self.cardNumerField)
        self.rootView.addSubview(self.nextButton)
        let rootHeight = self.rootView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        rootHeight.priority = UILayoutPriority(rawValue: 250)
        self.nextButtonBottom = self.nextButton.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -20)
        NSLayoutConstraint.activate([
            self.topBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.topBar.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.topBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.topBar.heightAnchor.constraint(equalToConstant: 160),
            self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.topBar.bottomAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.rootView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.rootView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.rootView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            self.rootView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            rootView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            rootHeight,
            self.cardNumerField.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.cardNumerField.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 30),
            self.cardNumerField.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.cardNumerField.heightAnchor.constraint(equalToConstant: 74),
            self.nextButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.nextButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.topAnchor.constraint(greaterThanOrEqualTo: self.cardNumerField.bottomAnchor, constant: 20),
            self.nextButtonBottom,
            self.nextButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight)
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
        self.cardNumerField.textField.addTarget(self, action: #selector(reformatAsCardNumber), for: [.editingChanged])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.cardNumerField.textField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        var visibleHeight: CGFloat = 0
        if let userInfo = notification.userInfo {
            if let windowFrame = UIApplication.shared.keyWindow?.frame,
                let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                visibleHeight = windowFrame.intersection(keyboardRect).height
            }
        }
        self.nextButtonBottom.constant = -(visibleHeight - (self.tabBarController?.tabBar.frame.height ?? 0) + 6)
    }
     
    @objc func keyboardWillHide(_ notification: Notification) {
        self.nextButtonBottom.constant = -20
    }
    
    @objc func goBack() {
        self.coordinator?.navigateBack()
    }
    
    @objc func goToReceiver() {
        guard let cardNumber = self.cardNumerField.textField.text, cardNumber.count >= 14 else {
            self.snackView(viewToShake: self.cardNumerField)
            return
        }
        self.view.endEditing(true)
        let confirmView = TransferConfirmView(bottomInset: self.view.safeAreaInsets.bottom)
        confirmView.delegate = self
        confirmView.rootView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        confirmView.senderView.subTitleLabel.text = cardNumber
        confirmView.senderView.itemIcon.image = CardTypes.getCardType(creditCard: cardNumber.digits)?.image
        switch receiver {
        case .card(let number, _):
            confirmView.receiverView.subTitleLabel.text = number
            confirmView.receiverView.itemIcon.image = CardTypes.getCardType(creditCard: number.digits)?.image
            confirmView.receiverView.typeIcon.image = UIImage(name: .card_icon)
            confirmView.receiverView.typeIcon.tintColor = .white
            confirmView.receiverView.typeIcon.layer.borderColor = Theme.current.tintColor.cgColor
            confirmView.receiverView.typeIcon.backgroundColor = Theme.current.tintColor
            confirmView.receiverInfoView.infoLabel.text = CardTypes.getBankName(number: number.digits)
            confirmView.receiverCurrencyView.infoLabel.text = "TJS"
        case .number(let number, let service, let info):
            confirmView.receiverView.subTitleLabel.text = number.formatedPrefix()
            confirmView.receiverView.itemIcon.loadImage(filePath: Theme.current.dark ? service.darkImage : service.image)
            confirmView.receiverView.typeIcon.image = UIImage(name: .wallet_inset)
            confirmView.receiverView.typeIcon.tintColor = Theme.current.tintColor
            confirmView.receiverView.typeIcon.layer.borderColor = Theme.current.tintColor.cgColor
            confirmView.receiverView.typeIcon.backgroundColor = Theme.current.plainTableCellColor
            confirmView.receiverInfoView.infoLabel.text = info
            confirmView.receiverCurrencyView.infoLabel.text = "TJS"
        }
        confirmView.sumPlusView.infoLabel.text = self.plusAmount.formattedAmount(.TJS)
        confirmView.sumMinusView.infoLabel.text = self.minusAmount.formattedAmount(.RUB)
        if self.commision.calcMethod == 1 {
            confirmView.sumComView.infoLabel.text = self.commisionAmout.formattedAmount(.TJS)
            confirmView.sumComView.titleLabel.text = "\("HISTORY_FEE".localized) \(self.commision.commissionValue)%"
        } else {
            confirmView.sumComView.infoLabel.text = self.commisionAmout.formattedAmount(.TJS)
            confirmView.sumComView.titleLabel.text = "\("HISTORY_FEE".localized) \(self.commision.commissionValue.formattedAmount(.TJS))"
        }
        self.view.addSubview(confirmView)
        NSLayoutConstraint.activate([
            confirmView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            confirmView.topAnchor.constraint(equalTo: self.view.topAnchor),
            confirmView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            confirmView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        confirmView.animateView()
    }
    
    func confirmViewClose(view: TransferConfirmView) { }
    
    func confirmViewNext(view: TransferConfirmView) {
        let cardNumber = self.cardNumerField.textField.text?.digits ?? ""
        self.showProgressView()
        self.viewModel.service.sendTransfer(accountFrom: cardNumber, accountTo: self.receiver.account.digits, accountType: self.receiver.accountType, amountCurrency: self.minusAmount, phoneNumber: "+\(self.receiver.phoneNumber.digits)", serviceID: self.receiver.serviceId)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self = self, let url = URL(string: result.formURL) else { return }
                self.hideProgressView()
                self.openWebAction(url: url)
            } onFailure: { [weak self] error in
                guard let self = self else { return }
                self.hideProgressView()
                self.showServerErrorAlert()
            }.disposed(by: self.viewModel.disposeBag)
    }
    
    func openWebAction(url: URL) {
        let view = WalletWebViewController(url: url, delegate: self)
        self.present(BaseNavigationController(rootViewController: view, title: nil, image: nil, tag: -1), animated: true, completion: nil)
    }
    
    func getUpdatedIntent(result: Bool) {
        self.coordinator?.navigateToResult(result: result)
    }
    
    override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
        self.topBar.themeChanged(newTheme: newTheme)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.cardNumerField.textField {
            self.previousTextFieldContent = textField.text
            self.previousSelection = textField.selectedTextRange
            return true
        }
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.checkFields() {
            self.view.endEditing(true)
        }
    }
    
    @discardableResult
    func checkFields() -> Bool {
        guard let cardNumber = self.cardNumerField.textField.text?.digits, cardNumber.count >= 14 else {
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
                self.checkFields()
                return
            }
            self.checkFields()
            let cardNumberWithSpaces = self.insertCreditCardSpaces(cardNumberWithoutSpaces, preserveCursorPosition: &targetCursorPosition)
            textField.text = cardNumberWithSpaces
            if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
                textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
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
        self.cardNumerField.rightImage.image = card?.image
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
