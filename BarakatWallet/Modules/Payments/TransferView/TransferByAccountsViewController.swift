//
//  TransferAccountsView.swift
//  BarakatWallet
//
//  Created by km1tj on 22/11/23.
//

import Foundation
import UIKit
import RxSwift

class TransferByAccountsViewController: BaseViewController, TransferConfirmViewDelegate, PaymentViewsDelegate, AddFavoriteViewControllerDelegate, BalanceSelectViewDelegate, CurrencyFormatFieldDelegate {
    
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
    private let payBalanceView: BalanceSelectView = {
        let view = BalanceSelectView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let topupBalanceView: BalanceSelectView = {
        let view = BalanceSelectView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleView.text = "TO_CARD_OR_WALLET".localized
        return view
    }()
    private let sumFieldView: BaseSumFiled = {
        let view = BaseSumFiled()
        view.bottomLabel.isHidden = true
        view.bottomLabel.text = "NO_BALANCE_FOR_PAY".localized
        view.bottomLabel.textColor = .systemRed
        return view
    }()
    var nextButtonBottom: NSLayoutConstraint!
    weak var coordinator: PaymentsCoordinator? = nil
    
    let viewModel: PaymentsViewModel
    var topupCreditCard: AppStructs.CreditDebitCard?
    var verifyResult: AppMethods.Payments.TransactionVerify.VerifyResult? = nil
    var verifyKey: String? = nil
    
    init(viewModel: PaymentsViewModel, topupCreditCard: AppStructs.CreditDebitCard?) {
        self.viewModel = viewModel
        self.topupCreditCard = topupCreditCard
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
        self.edgesForExtendedLayout = .all
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.navigationItem.title = "BEETWIN_ACCOUNT_TRANSFER".localized
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.rootView)
        self.rootView.addSubview(self.payBalanceView)
        self.rootView.addSubview(self.topupBalanceView)
        self.rootView.addSubview(self.sumFieldView)
        self.rootView.addSubview(self.nextButton)
        let rootHeight = self.rootView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        rootHeight.priority = UILayoutPriority(rawValue: 250)
        self.nextButtonBottom = self.nextButton.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -20)
        let width = self.view.frame.width - (Theme.current.mainPaddings * 2)
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
            self.payBalanceView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
            self.payBalanceView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 10),
            self.payBalanceView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
            self.payBalanceView.heightAnchor.constraint(equalToConstant: width * 0.325 + 48),
            self.topupBalanceView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
            self.topupBalanceView.topAnchor.constraint(equalTo: self.payBalanceView.bottomAnchor, constant: 6),
            self.topupBalanceView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
            self.topupBalanceView.heightAnchor.constraint(equalToConstant: width * 0.325 + 48),
            self.sumFieldView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.sumFieldView.topAnchor.constraint(equalTo: self.topupBalanceView.bottomAnchor, constant: 10),
            self.sumFieldView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.sumFieldView.heightAnchor.constraint(equalToConstant: 82),
            self.nextButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.nextButton.topAnchor.constraint(greaterThanOrEqualTo: self.sumFieldView.bottomAnchor, constant: 6),
            self.nextButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButtonBottom,
            self.nextButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
        ])
        self.sumFieldView.textField.delegate = self
        self.payBalanceView.delegate = self
        self.topupBalanceView.delegate = self
        self.nextButton.addTarget(self, action: #selector(self.makePayment), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.sumFieldView.configure(param: self.viewModel.sumParam, value: nil)
        self.topupBalanceView.configure(clientBalances: self.viewModel.accountInfo.clientBalances)
        self.payBalanceView.configure(clientBalances: self.viewModel.accountInfo.clientBalances)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: nil)
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
                let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardRect.height , right: 0.0)
                self.scrollView.contentInset = contentInsets
                self.scrollView.scrollIndicatorInsets = contentInsets
            }
        }
        self.nextButtonBottom.constant = -(visibleHeight - 20 + 2)
    }
     
    @objc func keyboardWillHide(_ notification: Notification) {
        self.nextButtonBottom.constant = -20
        self.scrollView.contentInset = .zero
        self.scrollView.scrollIndicatorInsets = .zero
    }
    
    @objc func editingCheck() {
        self.checkFields()
    }
    
    func currencyFieldDidChanged() {
        self.checkFields()
    }
    
    func balanceSelected(view: BalanceSelectView) {
        self.checkFields()
    }
    
    @discardableResult
    func checkFields() -> Bool {
        guard let pay = self.payBalanceView.selectedBalance else {
            self.nextButton.isEnabled = false
            return false
        }
        guard let top = self.topupBalanceView.selectedBalance else {
            self.nextButton.isEnabled = false
            return false
        }
        guard pay.account != top.account else {
            self.nextButton.isEnabled = false
            return false
        }
        guard let sum = self.sumFieldView.textField.value, sum > 0 else {
            self.nextButton.isEnabled = false
            return false
        }
        if let b = pay.balance, b < sum {
            self.sumFieldView.showHide(show: true)
            self.nextButton.isEnabled = false
            return false
        } else {
            self.sumFieldView.showHide(show: false)
        }
        self.nextButton.isEnabled = true
        return true
    }
    
    @objc func makePayment() {
        guard let pay = self.payBalanceView.selectedBalance else { return }
        guard let top = self.topupBalanceView.selectedBalance else { return }
        let sum = self.sumFieldView.textField.value ?? 0.0
        self.showProgressView()
        self.viewModel.service.verifyPayment(account: pay.account, accountType: pay.accountType, amount: sum, comment: "", params: [top.account], serviceID: AppStructs.TransferType.transferBetweenAccounts.rawValue)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self = self else { return }
                self.hideProgressView()
                self.showConfirmView(amount: sum, pay: pay, top: top, result: result)
            } onFailure: { [weak self] error in
                guard let self = self else { return }
                self.hideProgressView()
                self.showApiError(title: "ERROR".localized, error: error)
            }.disposed(by: self.viewModel.disposeBag)
    }
    
    func commitPayment(viewToRemove: UIView, amount: Double, pay: AppStructs.AccountInfo.BalanceType, result: AppMethods.Payments.TransactionVerify.VerifyResult, verifyKey: String, enteredCode: String) {
        self.showProgressView()
        self.viewModel.service.commitPayment(tranID: result.tranID, code: enteredCode, key: verifyKey)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.hideProgressView()
                self.configureResult(amount: amount, pay: pay, result: result)
                viewToRemove.removeFromSuperview()
            } onFailure: { [weak self] error in
                guard let self = self else { return }
                self.hideProgressView()
                self.showApiError(title: "ERROR".localized, error: error)
            }.disposed(by: self.viewModel.disposeBag)
    }
    
    private func showConfirmView(amount: Double, pay: AppStructs.AccountInfo.BalanceType, top: AppStructs.AccountInfo.BalanceType, result: AppMethods.Payments.TransactionVerify.VerifyResult) {
        self.navigationController?.navigationBar.isHidden = true
        self.setStatusBarStyle(dark: false)
        self.view.endEditing(true)
        self.verifyResult = result
        let confirmView = TransferConfirmView(bottomInset: self.view.safeAreaInsets.bottom)
        confirmView.delegate = self
        confirmView.rootView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        switch pay {
        case .wallet(account: let account):
            if account.isBonus {
                confirmView.senderView.titleLabel.text = "FROM_BONUS".localized
            } else {
                confirmView.senderView.titleLabel.text = "FROM_WALLET".localized
            }
            confirmView.senderView.subTitleLabel.text = account.account.formatedPrefix()
            confirmView.senderView.typeIcon.image = UIImage(name: .wallet_inset)
            confirmView.senderView.typeIcon.tintColor = Theme.current.tintColor
            confirmView.senderView.typeIcon.layer.borderColor = Theme.current.tintColor.cgColor
            confirmView.senderView.typeIcon.backgroundColor = Theme.current.plainTableBackColor
        case .card(card: let card):
            confirmView.senderView.titleLabel.text = "FROM_CARD".localizedFormat(arguments: card.cardHolder)
            confirmView.senderView.subTitleLabel.text = card.pan
            confirmView.senderView.itemIcon.loadImage(filePath: card.logo)
            confirmView.senderView.typeIcon.image = UIImage(name: .card_icon)
            confirmView.senderView.typeIcon.tintColor = .white
            confirmView.senderView.typeIcon.layer.borderColor = Theme.current.tintColor.cgColor
            confirmView.senderView.typeIcon.backgroundColor = Theme.current.tintColor
        }
        switch top {
        case .wallet(account: let account):
            if account.isBonus {
                confirmView.receiverView.titleLabel.text = "TO_BONUS".localized
            } else {
                confirmView.receiverView.titleLabel.text = "TO_WALLET".localized
            }
            confirmView.receiverView.subTitleLabel.text = account.account.formatedPrefix()
            confirmView.receiverView.typeIcon.image = UIImage(name: .wallet_inset)
            confirmView.receiverView.typeIcon.tintColor = Theme.current.tintColor
            confirmView.receiverView.typeIcon.layer.borderColor = Theme.current.tintColor.cgColor
            confirmView.receiverView.typeIcon.backgroundColor = Theme.current.plainTableBackColor
            confirmView.receiverInfoView.infoLabel.text = ""
        case .card(card: let card):
            confirmView.receiverView.titleLabel.text = "TO_CARD".localizedFormat(arguments: card.cardHolder)
            confirmView.receiverView.subTitleLabel.text = card.pan
            confirmView.receiverView.itemIcon.loadImage(filePath: card.logo)
            confirmView.receiverView.typeIcon.image = UIImage(name: .card_icon)
            confirmView.receiverView.typeIcon.tintColor = .white
            confirmView.receiverView.typeIcon.layer.borderColor = Theme.current.tintColor.cgColor
            confirmView.receiverView.typeIcon.backgroundColor = Theme.current.tintColor
            confirmView.receiverInfoView.infoLabel.text = card.bankName
        }
        confirmView.receiverCurrencyView.infoLabel.text = "TJS"
        confirmView.sumPlusView.infoLabel.text = result.admission.balanceText
        confirmView.sumMinusView.infoLabel.text = amount.balanceText
        confirmView.sumComView.titleLabel.text = "HISTORY_FEE".localized
        confirmView.sumComView.infoLabel.text = result.commission.balanceText
        self.view.addSubview(confirmView)
        NSLayoutConstraint.activate([
            confirmView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            confirmView.topAnchor.constraint(equalTo: self.view.topAnchor),
            confirmView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            confirmView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        confirmView.animateView()
    }
    
    func configureCode(amount: Double, pay: AppStructs.AccountInfo.BalanceType, result: AppMethods.Payments.TransactionVerify.VerifyResult) {
        self.navigationController?.navigationBar.isHidden = true
        self.setStatusBarStyle(dark: false)
        let confirmView = PaymentCodeView(amount: amount, balance: pay, result: result, walletNumber: self.viewModel.accountInfo.client.wallet, bottomInset: self.view.safeAreaInsets.bottom)
        confirmView.delegate = self
        confirmView.rootView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        self.view.addSubview(confirmView)
        NSLayoutConstraint.activate([
            confirmView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            confirmView.topAnchor.constraint(equalTo: self.view.topAnchor),
            confirmView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            confirmView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        confirmView.animateView()
    }
    
    func configureResult(amount: Double, pay: AppStructs.AccountInfo.BalanceType, result: AppMethods.Payments.TransactionVerify.VerifyResult) {
        self.navigationController?.navigationBar.isHidden = true
        self.setStatusBarStyle(dark: false)
        let confirmView = PaymentResultView(amount: amount, balance: pay, result: result, service: self.viewModel.transferAccountsService, bottomInset: self.view.safeAreaInsets.bottom)
        confirmView.delegate = self
        confirmView.rootView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        self.view.addSubview(confirmView)
        NSLayoutConstraint.activate([
            confirmView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            confirmView.topAnchor.constraint(equalTo: self.view.topAnchor),
            confirmView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            confirmView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        confirmView.animateView()
    }
    
    func confirmViewClose(view: PaymentConfirmView) {}
    func confirmViewClose(view: TransferConfirmView) {
        self.verifyResult = nil
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: nil)
    }
    
    func confirmViewNext(view: PaymentConfirmView) {}
    func confirmViewNext(view: TransferConfirmView) {
        guard let result = self.verifyResult else {
            view.removeFromSuperview()
            return
        }
        guard let pay = self.payBalanceView.selectedBalance else {
            view.removeFromSuperview()
            return
        }
        let sum = self.sumFieldView.textField.value ?? 0.0
        if result.isCheckVerify {
            self.showProgressView()
            self.viewModel.service.verifySendCode(tranID: result.tranID)
                .observe(on: MainScheduler.instance)
                .subscribe { [weak self] item in
                    guard let self = self else { return }
                    self.hideProgressView()
                    self.verifyKey = item.verifyKey
                    self.configureCode(amount: sum, pay: pay, result: result)
                } onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.hideProgressView()
                    self.showApiError(title: "ERROR".localized, error: error)
                }.disposed(by: self.viewModel.disposeBag)
        } else {
            self.commitPayment(viewToRemove:view, amount: sum, pay: pay, result: result, verifyKey: "", enteredCode: "")
        }
        view.removeFromSuperview()
    }
    
    func codeViewClose(view: PaymentCodeView) {
        self.verifyResult = nil
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: nil)
    }
    
    func codeViewNext(view: PaymentCodeView, enteredCode: String) {
        self.commitPayment(viewToRemove: view, amount: view.amount, pay: view.balance, result: view.result, verifyKey: self.verifyKey ?? "", enteredCode: enteredCode)
    }
    
    func resultViewClose(view: PaymentResultView, close: Bool, addFav: Bool, repeatPay: Bool, recipe: Bool) {
        if addFav {
            let vc = AddFavoriteViewController()
            vc.delegate = self
            self.present(vc, animated: true)
        } else if repeatPay {
            self.navigationController?.navigationBar.isHidden = false
            self.setStatusBarStyle(dark: nil)
        } else if recipe {
            self.showProgressView()
            self.viewModel.historyService.getHistoryById(tranId: view.result.tranID)
                .observe(on: MainScheduler.instance)
                .subscribe { [weak self] item in
                    guard let self = self else { return }
                    self.hideProgressView()
                    self.coordinator?.navigateToHistoryRecipe(item: item)
                } onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.hideProgressView()
                    self.showApiError(title: "ERROR".localized, error: error)
                }.disposed(by: self.viewModel.disposeBag)
        } else {
            self.navigationController?.navigationBar.isHidden = false
            self.setStatusBarStyle(dark: nil)
            self.coordinator?.navigateToRootViewController()
        }
    }
    
    func addFavorite(name: String) {
        guard let pay = self.payBalanceView.selectedBalance else { return }
        guard let top = self.topupBalanceView.selectedBalance else { return }
        let sum = self.sumFieldView.textField.value ?? 0.0
        self.viewModel.addFavorite(account: pay.account, amount: sum, comment: "", params: [top.account], name: name, serviceID: AppStructs.TransferType.transferBetweenAccounts.rawValue)
    }
}
