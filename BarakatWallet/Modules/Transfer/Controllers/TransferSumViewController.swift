//
//  TransferSumViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 24/10/23.
//

import Foundation
import UIKit
import RxSwift

class TransferSumViewController: BaseViewController, UITabBarControllerDelegate, TransferSumViewControllerDelegate, UITextFieldDelegate, TransferConfirmViewDelegate, WalletWebViewControllerDelegate {
 
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
        view.rootView.startColor = UIColor(red: 0.49, green: 0.88, blue: 0.89, alpha: 1.00)
        view.rootView.endColor = UIColor(red: 0.77, green: 0.98, blue: 0.98, alpha: 1.00)
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
        view.rootView.startColor = UIColor(red: 0.49, green: 0.88, blue: 0.89, alpha: 1.00)
        view.rootView.endColor = UIColor(red: 0.77, green: 0.98, blue: 0.98, alpha: 1.00)
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
    private var lastRublEntered: Bool = true
    var type: TransferType
    var receiver: TransferIdentifier
    var transferData: AppMethods.Transfers.GetTransgerData.GetTransgerDataResult
    let viewModel: TransferViewModel
    weak var coordinator: TransferCoordinator?
    
    init(viewModel: TransferViewModel, type: TransferType, receiver: TransferIdentifier, transferData: AppMethods.Transfers.GetTransgerData.GetTransgerDataResult) {
        self.type = type
        self.receiver = receiver
        self.transferData = transferData
        self.viewModel = viewModel
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
        self.coordinator?.navigateBack()
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
            self.cardNumberReceiverView.numberLabel.text = number.formatedPrefix()
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
            self.lastRublEntered = false
            let value = self.sumRootView.topSumField.updateTextField()
            let decimalRubVal = Decimal(value.amount)
            if let com = self.getCommisionForRub(sumInRub: decimalRubVal) {
                let comInSom = com.comRubValue * Decimal(self.transferData.rate.sale)
                //print("decimalRubVal:\(decimalRubVal), comRubValue: \(com.comRubValue)")
                if com.commision.calcMethod == 1 {
                    self.sumRootView.transferTaxView.titleLabel.text = comInSom.formattedAmount(.TJS)
                    self.sumRootView.transferTaxView.subTitleLabel.text = "\("HISTORY_FEE".localized) \(com.commision.commissionValue)%"
                } else {
                    self.sumRootView.transferTaxView.titleLabel.text = comInSom.formattedAmount(.TJS)
                    self.sumRootView.transferTaxView.subTitleLabel.text = "\("HISTORY_FEE".localized) \(comInSom.formattedAmount(.TJS))"
                }
                let somValueDecimal = (decimalRubVal - com.comRubValue) * Decimal(self.transferData.rate.sale)
                self.sumRootView.bottomSumField.startingValue = NSDecimalNumber(decimal:somValueDecimal).doubleValue
                self.sumRootView.bottomSumField.textFieldDidChange()
                self.nextButton.isEnabled = true
            } else {
                self.sumRootView.bottomSumField.startingValue = 0.0
                self.sumRootView.bottomSumField.textFieldDidChange()
                self.nextButton.isEnabled = false
            }
        } else if textField == self.sumRootView.bottomSumField.field {
            self.lastRublEntered = false
            let value = self.sumRootView.bottomSumField.updateTextField()
            let decimalSomVal = Decimal(value.amount)
            let sumInRubDecimal = decimalSomVal / Decimal(self.transferData.rate.sale)
            //print("sumInRubDecimal:\(sumInRubDecimal), decimalSomVal: \(decimalSomVal)")
            if let com = self.getCommisionForSom(sumInRub: sumInRubDecimal) {
                let comInSom = com.comRubValue * Decimal(self.transferData.rate.sale)
                if com.commision.calcMethod == 1 {
                    self.sumRootView.transferTaxView.titleLabel.text = comInSom.formattedAmount(.TJS)
                    self.sumRootView.transferTaxView.subTitleLabel.text = "\("HISTORY_FEE".localized) \(com.commision.commissionValue)%"
                } else {
                    self.sumRootView.transferTaxView.titleLabel.text = comInSom.formattedAmount(.TJS)
                    self.sumRootView.transferTaxView.subTitleLabel.text = "\("HISTORY_FEE".localized) \(comInSom.formattedAmount(.TJS))"
                }
                let rubl = sumInRubDecimal + com.comRubValue
                self.sumRootView.topSumField.startingValue = NSDecimalNumber(decimal:rubl).doubleValue
                self.sumRootView.topSumField.textFieldDidChange()
                self.nextButton.isEnabled = true
            } else {
                self.sumRootView.topSumField.startingValue = 0.0
                self.sumRootView.topSumField.textFieldDidChange()
                self.nextButton.isEnabled = false
            }
        }
    }
    
    private func getCommisionForRub(sumInRub: Decimal) -> (commision: AppMethods.Transfers.GetTransgerData.GetTransgerDataResult.Commissions, comRubValue: Decimal)? {
        if let com = self.transferData.commissions.first(where: { Decimal($0.minValue) <= sumInRub && ($0.maxValue == -1 || Decimal($0.maxValue) >= sumInRub) }) {
            if com.calcMethod == 1 {
                let comValueRub = sumInRub * (Decimal(com.commissionValue) / 100)
                return (com, comValueRub)
            } else {
                let comValueRub = Decimal(com.commissionValue)
                return (com, comValueRub)
            }
        }
        return nil
    }
    
    private func getCommisionForSom(sumInRub: Decimal) -> (commision: AppMethods.Transfers.GetTransgerData.GetTransgerDataResult.Commissions, comRubValue: Decimal)? {
        if let com = self.transferData.commissions.first(where: { Decimal($0.minValue) <= sumInRub && ($0.maxValue == -1 || Decimal($0.maxValue) >= sumInRub) }) {
            if com.calcMethod == 1 {
                let dk: Decimal = 100 - Decimal(com.commissionValue)
                let rub = (sumInRub * 100) / dk
                let comValueRub = rub * (Decimal(com.commissionValue) / 100)
                return (com, comValueRub)
            } else {
                let comValueRub = Decimal(com.commissionValue)
                return (com, comValueRub)
            }
        }
        return nil
    }
    
    
    @objc func goToConfirm() {
        if self.lastRublEntered {
            let value = self.sumRootView.topSumField.updateTextField()
            let decimalRubVal = Decimal(value.amount)
            if let com = self.getCommisionForRub(sumInRub: decimalRubVal) {
                let comInSom = com.comRubValue * Decimal(self.transferData.rate.sale)
                let somValueDecimal = (decimalRubVal - com.comRubValue) * Decimal(self.transferData.rate.sale)
                let rublValue = (decimalRubVal - com.comRubValue)
                if rublValue > 0 {
                    self.configureConfirmView(type: self.type, receiver: self.receiver, commision: com.commision, plusAmount: somValueDecimal.intValue(currency: .TJS), minusAmount: rublValue.intValue(currency: .RUB), commisionAmout: comInSom.intValue(currency: .TJS))
                }
            }
        } else {
            let value = self.sumRootView.bottomSumField.updateTextField()
            let decimalSomVal = Decimal(value.amount)
            let sumInRubDecimal = decimalSomVal / Decimal(self.transferData.rate.sale)
            if let com = self.getCommisionForSom(sumInRub: sumInRubDecimal) {
                let comInSom = com.comRubValue * Decimal(self.transferData.rate.sale)
                let rublValueDecimal = sumInRubDecimal + com.comRubValue
                if rublValueDecimal > 0 {
                    self.configureConfirmView(type: self.type, receiver: self.receiver, commision: com.commision, plusAmount: decimalSomVal.intValue(currency: .TJS), minusAmount: rublValueDecimal.intValue(currency: .RUB), commisionAmout: comInSom.intValue(currency: .TJS))
                }
            }
        }
    }
    
    private func configureConfirmView(type: TransferType, receiver: TransferIdentifier, commision: AppMethods.Transfers.GetTransgerData.GetTransgerDataResult.Commissions, plusAmount: Int, minusAmount: Int, commisionAmout: Int) {
        self.view.endEditing(true)
        let confirmView = TransferConfirmView(bottomInset: self.view.safeAreaInsets.bottom, showSender: false)
        confirmView.delegate = self
        confirmView.rootView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
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
        confirmView.sumPlusView.infoLabel.text = plusAmount.formattedAmount(.TJS)
        confirmView.sumMinusView.infoLabel.text = minusAmount.formattedAmount(.RUB)
        if commision.calcMethod == 1 {
            confirmView.sumComView.infoLabel.text = commisionAmout.formattedAmount(.TJS)
            confirmView.sumComView.titleLabel.text = "\("HISTORY_FEE".localized) \(commision.commissionValue)%"
        } else {
            confirmView.sumComView.infoLabel.text = commisionAmout.formattedAmount(.TJS)
            let comRublDecimal = Decimal(commision.commissionValue)
            let comSomDecimal = comRublDecimal * Decimal(self.transferData.rate.sale)
            confirmView.sumComView.titleLabel.text = "\("HISTORY_FEE".localized) \(comSomDecimal.formattedAmount(.TJS))"
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
        let value = self.sumRootView.topSumField.updateTextField()
        let doubleVal = value.amount
        let decimalVal = Decimal(doubleVal)
        self.showProgressView()
        self.viewModel.service.sendTransfer(accountFrom: "", accountTo: self.receiver.account.digits, accountType: self.receiver.accountType, amountCurrency: decimalVal.intValue(currency: .RUB), phoneNumber: "+\(self.receiver.phoneNumber.digits)", serviceID: self.receiver.serviceId)
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
}
