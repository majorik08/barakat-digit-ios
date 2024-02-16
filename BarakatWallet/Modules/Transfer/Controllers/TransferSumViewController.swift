//
//  TransferSumViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 24/10/23.
//

import Foundation
import UIKit

class TransferSumViewController: BaseViewController, UITabBarControllerDelegate, TransferSumViewControllerDelegate, UITextFieldDelegate {
 
    lazy var topBar: TransferTopView = {
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
    private let cardReceiverView: TransferCardView = {
        let view = TransferCardView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rootView.startColor = UIColor(red: 0.66, green: 0.81, blue: 0.93, alpha: 1.00)
        view.rootView.endColor = UIColor(red: 0.90, green: 0.96, blue: 0.98, alpha: 1.00)
        view.titleLabel.text = "TRANSFER_RECEIVER".localized
        //view.logoImageView.image = UIImage(name: .card_milli)
        view.iconView.layer.borderColor = Theme.current.tintColor.cgColor
        view.iconView.backgroundColor = Theme.current.tintColor
        view.isUserInteractionEnabled = true
        return view
    }()
    private let cardNumberReceiverView: TransferCardNumberView = {
        let view = TransferCardNumberView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rootView.startColor = UIColor(red: 0.66, green: 0.81, blue: 0.93, alpha: 1.00)
        view.rootView.endColor = UIColor(red: 0.90, green: 0.96, blue: 0.98, alpha: 1.00)
        view.titleLabel.text = "TRANSFER_RECEIVER".localized
        //view.logoImageView.image = UIImage(name: .main_logo)
        view.iconView.layer.borderColor = Theme.current.tintColor.cgColor
        view.iconView.backgroundColor = Theme.current.plainTableCellColor
        view.isUserInteractionEnabled = true
        return view
    }()
    private let sumRootView: TransferSumView = {
        let view = TransferSumView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var nextButtonBottom: NSLayoutConstraint!
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    var type: TransferType
    var receiver: TransferIdentifier
    var transferData: AppMethods.Transfers.GetTransgerData.GetTransgerDataResult
    weak var coordinator: TransferCoordinator?
    
    init(type: TransferType, receiver: TransferIdentifier, transferData: AppMethods.Transfers.GetTransgerData.GetTransgerDataResult) {
        self.type = type
        self.receiver = receiver
        self.transferData = transferData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.current.plainTableBackColor
        let receiverHeight: CGFloat
        let receiverView: UIControl
        switch self.type {
        case .byNumber:
            receiverView = self.cardNumberReceiverView
            receiverHeight = 90
            self.topBar.subTitleLabel.text = "TRANSFER_BY_NUMBER_INFO".localized
        case .byCard:
            receiverView = self.cardReceiverView
            receiverHeight = 56
            self.topBar.subTitleLabel.text = "TRANSFER_BY_CARD_INFO".localized
        }
        self.view.addSubview(receiverView)
        self.view.addSubview(self.topBar)
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.rootView)
        self.rootView.addSubview(self.sumRootView)
        self.rootView.addSubview(self.nextButton)
        let rootHeight = self.rootView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        rootHeight.priority = UILayoutPriority(rawValue: 250)
        self.nextButtonBottom = self.nextButton.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -20)
        NSLayoutConstraint.activate([
            self.topBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.topBar.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.topBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.topBar.heightAnchor.constraint(equalToConstant: 160),
            receiverView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            receiverView.topAnchor.constraint(equalTo: self.view.topAnchor),
            receiverView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            receiverView.heightAnchor.constraint(equalToConstant: 160 + receiverHeight),
            self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.scrollView.topAnchor.constraint(equalTo: receiverView.bottomAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.rootView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.rootView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.rootView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            self.rootView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            rootView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            rootHeight,
            self.sumRootView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.sumRootView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 30),
            self.sumRootView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.nextButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.topAnchor.constraint(greaterThanOrEqualTo: self.sumRootView.bottomAnchor, constant: 20),
            self.nextButtonBottom,
            self.nextButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight)
        ])
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard)))
        self.topBar.backButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        self.nextButton.addTarget(self, action: #selector(self.goToConfirm), for: .touchUpInside)
        self.cardReceiverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToPickReceiver)))
        self.cardNumberReceiverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToPickReceiver)))
        self.sumRootView.topSumField.field.addTarget(self, action: #selector(reformatAsCardNumber), for: [.editingChanged])
        self.sumRootView.bottomSumField.field.addTarget(self, action: #selector(reformatAsCardNumber), for: [.editingChanged])
        self.sumRootView.topSumField.field.becomeFirstResponder()
        self.configure()
    }
    
    override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
        self.topBar.themeChanged(newTheme: newTheme)
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
    
    @objc func goToPickReceiver() {
        self.coordinator?.navigateToPickReceiver(type: self.type, delegate: self)
    }
    
    func receiverPicked(receiver: TransferIdentifier) {
        self.receiver = receiver
        self.configure()
    }
    
    private func configure() {
        switch self.receiver {
        case .card(number: let number, _):
            self.cardReceiverView.subTitleLabel.text = number
            self.cardReceiverView.logoImageView.image = CardTypes.getCardType(creditCard: number.digits)?.image
        case .number(number: let number, service: let service, info: let info):
            self.cardNumberReceiverView.subTitleLabel.text = info
            self.cardNumberReceiverView.numberLabel.text = number
            self.cardNumberReceiverView.accountLabel.text = service.name
            self.cardNumberReceiverView.logoImageView.loadImage(filePath: Theme.current.dark ? service.darkImage : service.image)
        }
        self.sumRootView.transferRateView.subTitleLabel.text = "CUR_RATE".localized
        self.sumRootView.transferRateView.titleLabel.text = "1 \(self.transferData.rate.name) = \(self.transferData.rate.sale.currencyText)"
        self.sumRootView.transferTaxView.titleLabel.text = "0 TJS"
        self.sumRootView.transferTaxView.subTitleLabel.text = "\("HISTORY_FEE".localized) 0%"
    }
    
    @objc func reformatAsCardNumber(textField: UITextField) {
        if textField == self.sumRootView.topSumField.field {
            let value = self.sumRootView.topSumField.updateTextField()
            let doubleVal = value.amount
            let convertToSom = doubleVal * self.transferData.rate.sale
            let somDecimal = Decimal(convertToSom)
            let somInt = somDecimal.intValue(currency: .TJS)
            if let com = self.setGetCommision(sumInSomoni: somInt) {
                let getSum = somInt - com
                let getSumDecimal = getSum.decimalValue(currency: .TJS)
                self.sumRootView.bottomSumField.startingValue = NSDecimalNumber(decimal:getSumDecimal).doubleValue
                self.sumRootView.bottomSumField.textFieldDidChange()
                self.nextButton.isEnabled = true
            } else {
                self.nextButton.isEnabled = false
            }
        } else if textField == self.sumRootView.bottomSumField.field {
            let value = self.sumRootView.bottomSumField.updateTextField()
            let doubleVal = value.amount
            let somDecimal = Decimal(doubleVal)
            let somInt = somDecimal.intValue(currency: .TJS)
            if let com = self.setGetCommision(sumInSomoni: somInt) {
                let getSum = somInt + com
                let getSumDecimal = getSum.decimalValue(currency: .TJS)
                let convertToRub = getSumDecimal / Decimal(self.transferData.rate.sale)
                self.sumRootView.topSumField.startingValue = NSDecimalNumber(decimal:convertToRub).doubleValue
                self.sumRootView.topSumField.textFieldDidChange()
                self.nextButton.isEnabled = true
            } else {
                self.nextButton.isEnabled = false
            }
        }
    }
    
    private func setGetCommision(sumInSomoni: Int) -> Int? {
        if let com = self.transferData.commissions.first(where: { $0.minValue <= sumInSomoni && ($0.maxValue == -1 || $0.maxValue >= sumInSomoni) }) {
            if com.calcMethod == 1 {
                let c = (com.commissionValue * sumInSomoni) / 100
                self.sumRootView.transferTaxView.titleLabel.text = c.formattedAmount(.TJS)
                self.sumRootView.transferTaxView.subTitleLabel.text = "\("HISTORY_FEE".localized) \(com.commissionValue)%"
                return c
            } else {
                self.sumRootView.transferTaxView.titleLabel.text = com.commissionValue.formattedAmount(.TJS)
                self.sumRootView.transferTaxView.subTitleLabel.text = "\("HISTORY_FEE".localized) \(com.commissionValue.formattedAmount(.TJS))"
                return com.commissionValue
            }
        }
        return nil
    }
    
    @objc func goToConfirm() {
        let value = self.sumRootView.topSumField.updateTextField()
        let doubleVal = value.amount
        let decimalVal = Decimal(doubleVal)
        let convertToSom = doubleVal * self.transferData.rate.sale
        let somDecimal = Decimal(convertToSom)
        let somInt = somDecimal.intValue(currency: .TJS)
        if let com = self.transferData.commissions.first(where: { $0.minValue <= somInt && ($0.maxValue == -1 || $0.maxValue >= somInt) }) {
            if com.calcMethod == 1 {
                let commisionValue = (com.commissionValue * somInt) / 100
                let getSumValue = somInt - commisionValue
                self.coordinator?.navigateToPickSender(type: self.type, receiver: self.receiver, commision: com, plusAmount: getSumValue, minusAmount: decimalVal.intValue(currency: .RUB), commisionAmout: commisionValue)
            } else {
                let getSumValue = somInt - com.commissionValue
                self.coordinator?.navigateToPickSender(type: self.type, receiver: self.receiver, commision: com, plusAmount: getSumValue, minusAmount: decimalVal.intValue(currency: .RUB), commisionAmout: com.commissionValue)
            }
        }
    }
}
