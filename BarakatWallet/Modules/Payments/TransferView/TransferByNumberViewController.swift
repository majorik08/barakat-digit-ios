//
//  TransferByNumberViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 08/11/23.
//

import Foundation
import UIKit
import PhoneNumberKit
import RxSwift
import RxCocoa
import ContactsUI

class TransferByNumberViewController: BaseViewController, CNContactPickerDelegate, PaymentServiceSelectViewDelegate, TransferConfirmViewDelegate, PaymentViewsDelegate, AddFavoriteViewControllerDelegate, BalanceSelectViewDelegate, CurrencyFormatFieldDelegate, UITextFieldDelegate {
   
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
    private let balanceView: BalanceSelectView = {
        let view = BalanceSelectView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let numberView: BasePrefixTextField = {
        let view = UITextField(frame: .zero)
        let filedView = BasePrefixTextField(textField: view, keyboardType: .phoneNumber)
        filedView.topLabel.text = "PHONE_NUMBER".localized
        filedView.translatesAutoresizingMaskIntoConstraints = false
        filedView.rightImage.image = UIImage(name: .add_number)
        filedView.countryCodeLable.text = "+992"
        view.leftViewMode = .always
        view.keyboardType = UIKeyboardType.phonePad
        view.borderStyle = .none
        view.attributedPlaceholder = NSAttributedString(string: "918000000", attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryTextColor])
        return filedView
    }()
    private let selectorView: PaymentServiceSelectView = {
        let view = PaymentServiceSelectView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.controlView.isHidden = true
        return view
    }()
    private let sumView: BaseSumFiled = {
        let view = BaseSumFiled()
        view.bottomLabel.isHidden = true
        view.bottomLabel.text = "NO_BALANCE_FOR_PAY".localized
        view.bottomLabel.textColor = .systemRed
        return view
    }()
    private let infoView: PaymentServiceInfoView = {
        let view = PaymentServiceInfoView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    private let commentView: PaymentFieldView = {
        let view = PaymentFieldView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let nextButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.radius = 14
        view.setTitle("SEND".localized, for: .normal)
        view.isEnabled = false
        return view
    }()
    private var nextButtonBottom: NSLayoutConstraint!
    private var infoViewHeight: NSLayoutConstraint!
    let viewModel: PaymentsViewModel
    var verifyResult: AppMethods.Payments.TransactionVerify.VerifyResult? = nil
    var verifyKey: String? = nil
    var phoneNumber: String?
    weak var coordinator: PaymentsCoordinator? = nil
    
    init(viewModel: PaymentsViewModel, transferParam: String?) {
        self.viewModel = viewModel
        self.phoneNumber = transferParam
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
        self.navigationItem.title = "TRANSFER_TO_NUMBER_OPERATION".localized
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.rootView)
        self.rootView.addSubview(self.balanceView)
        self.rootView.addSubview(self.numberView)
        self.rootView.addSubview(self.selectorView)
        self.rootView.addSubview(self.infoView)
        self.rootView.addSubview(self.sumView)
        self.rootView.addSubview(self.commentView)
        self.rootView.addSubview(self.nextButton)
        let rootHeight = self.rootView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        rootHeight.priority = UILayoutPriority(rawValue: 250)
        self.nextButtonBottom = self.nextButton.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -20)
        self.infoViewHeight = self.infoView.heightAnchor.constraint(equalToConstant: 0)
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
            self.balanceView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
            self.balanceView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 10),
            self.balanceView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
            self.balanceView.heightAnchor.constraint(equalToConstant: width * 0.325 + 48),
            self.numberView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.numberView.topAnchor.constraint(equalTo: self.balanceView.bottomAnchor, constant: 20),
            self.numberView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.numberView.heightAnchor.constraint(equalToConstant: 64),
            self.selectorView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
            self.selectorView.topAnchor.constraint(equalTo: self.numberView.bottomAnchor, constant: 10),
            self.selectorView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
            self.selectorView.heightAnchor.constraint(equalToConstant: 140),
            self.infoView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.infoView.topAnchor.constraint(equalTo: self.selectorView.bottomAnchor, constant: 10),
            self.infoView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.infoViewHeight,
            self.sumView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.sumView.topAnchor.constraint(equalTo: self.infoView.bottomAnchor, constant: 10),
            self.sumView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.sumView.heightAnchor.constraint(equalToConstant: 82),
            self.commentView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.commentView.topAnchor.constraint(equalTo: self.sumView.bottomAnchor, constant: 6),
            self.commentView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.nextButton.topAnchor.constraint(greaterThanOrEqualTo: self.commentView.bottomAnchor, constant: 20),
            self.nextButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButtonBottom,
            self.nextButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
        ])
        self.sumView.textField.delegate = self
        self.balanceView.delegate = self
        self.selectorView.delegate = self
        self.nextButton.addTarget(self, action: #selector(self.nextTapped), for: .touchUpInside)
        self.numberView.rightImage.isUserInteractionEnabled = true
        self.numberView.rightImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.contactPick)))
        self.numberView.textField.addTarget(self, action: #selector(reformatAsCardNumber), for: [.editingChanged])
        self.numberView.textField.delegate = self
        self.sumView.configure(param: self.viewModel.sumParam, value: nil)
        self.commentView.configure(param: self.viewModel.messageParam, value: nil, getInfo: false)
        self.balanceView.configure(clientBalances: self.viewModel.accountInfo.clientBalances)
        let validNumber = self.numberView.textField.rx.text.orEmpty
        validNumber
            .debounce(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter({ $0.count >= 6 })
            .flatMap { str in
                self.selectorView.configure(services: [])
                self.serviceSelected()
                return self.viewModel.loadNumberServices(number: "\(self.numberView.selectedCountry.countryPhoneCode)\(str.digits)")
            }
            .subscribe { [weak self] services in
                self?.selectorView.configure(services: services)
                self?.checkFields()
            } onError: { _ in
                
            }.disposed(by: self.viewModel.disposeBag)
        if let ph = self.phoneNumber {
            let val = self.parseParams(parse: ph)
            self.numberView.textField.text = val
            self.numberView.textField.sendActions(for: .editingChanged)
        }
    }
    
    private func parseParams(parse: String) -> String {
        do {
            let pn = try Constants.phoneNumberKit.parse(parse)
            return pn.adjustedNationalNumber()
        } catch {
            return parse
        }
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
    
    @objc func contactPick() {
        let vc = CNContactPickerViewController(nibName: nil, bundle: nil)
        vc.predicateForSelectionOfProperty = NSPredicate(format: "key == 'phoneNumbers'")
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        guard let item = contactProperty.value as? CNPhoneNumber else { return }
        var txt = item.stringValue.digits
        if txt.starts(with: "992") {
            txt = txt.replacingOccurrences(of: "992", with: "")
        }
        self.numberView.textField.text = txt
        self.numberView.textFieldTopLabel.text = "\(contactProperty.contact.givenName) \(contactProperty.contact.familyName)"
        self.numberView.textField.sendActions(for: .editingChanged)
        if self.checkFields() {
            self.view.endEditing(true)
        }
    }
    
    func serviceSelected() {
        self.checkFields()
        guard let selectedService = self.selectorView.selectedService else {
            self.infoViewHeight.isActive = true
            self.infoView.infoLabel.text = nil
            self.infoView.isHidden = true
            return
        }
        self.infoViewHeight.isActive = false
        self.infoView.isHidden = false
        self.infoView.infoLabel.text = selectedService.accountInfo.info
    }
    
    func balanceSelected(view: BalanceSelectView) {
        self.checkFields()
    }
    
    func currencyFieldDidChanged() {
        self.checkFields()
    }
    
    @objc func reformatAsCardNumber(textField: UITextField) {
        if textField == self.numberView.textField {
            self.numberView.textFieldTopLabel.text = nil
            self.checkFields()
            if let t = textField.text, t.count == 9 {
                self.numberView.textField.resignFirstResponder()
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.numberView.textField {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 9
        }
        return false
    }
    
    @discardableResult
    func checkFields() -> Bool {
        guard let phoneNumber = self.numberView.textField.text?.digits, phoneNumber.count >= 8 else {
            self.nextButton.isEnabled = false
            return false
        }
        guard let s = self.selectorView.selectedService, s.accountInfo.available else {
            self.nextButton.isEnabled = false
            return false
        }
        guard let sum = self.sumView.textField.value, sum > 0 else {
            self.nextButton.isEnabled = false
            return false
        }
        guard let balance = self.balanceView.selectedBalance else {
            return false
        }
        if let b = balance.balance, b < sum {
            self.sumView.showHide(show: true)
            self.nextButton.isEnabled = false
            return false
        } else {
            self.sumView.showHide(show: false)
        }
        self.nextButton.isEnabled = true
        return true
    }
    
    @objc func nextTapped() {
        guard let selectedBalance = self.balanceView.selectedBalance else { return }
        guard let selectedService = self.selectorView.selectedService else { return }
        let comment = self.commentView.fieldView.text ?? ""
        let sum = self.sumView.textField.value ?? 0.0
        let phoneNumber = "+992\(self.numberView.textField.text?.digits ?? "")"
        self.showProgressView()
        self.viewModel.service.verifyPayment(account: selectedBalance.account, accountType: selectedBalance.accountType, amount: sum, comment: comment, params: [phoneNumber], serviceID: selectedService.service.id)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self = self else { return }
                self.hideProgressView()
                self.showConfirmView(amount: sum, phoneNumber: phoneNumber, balance: selectedBalance, result: result, service: selectedService)
            } onFailure: { [weak self] error in
                guard let self = self else { return }
                self.hideProgressView()
                self.showApiError(title: "ERROR".localized, error: error)
            }.disposed(by: self.viewModel.disposeBag)
    }
    
    func commitPayment(viewToRemove: UIView, amount: Double, balance: AppStructs.AccountInfo.BalanceType, result: AppMethods.Payments.TransactionVerify.VerifyResult, verifyKey: String, enteredCode: String) {
        self.showProgressView()
        self.viewModel.service.commitPayment(tranID: result.tranID, code: enteredCode, key: verifyKey)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.hideProgressView()
                self.configureResult(amount: amount, balance: balance, result: result)
                viewToRemove.removeFromSuperview()
            } onFailure: { [weak self] error in
                guard let self = self else { return }
                self.hideProgressView()
                self.showApiError(title: "ERROR".localized, error: error)
            }.disposed(by: self.viewModel.disposeBag)
    }
    
    private func showConfirmView(amount: Double, phoneNumber: String, balance: AppStructs.AccountInfo.BalanceType, result: AppMethods.Payments.TransactionVerify.VerifyResult, service: PaymentsViewModel.NumberServiceInfo) {
        self.navigationController?.navigationBar.isHidden = true
        self.setStatusBarStyle(dark: false)
        self.view.endEditing(true)
        self.verifyResult = result
        let confirmView = TransferConfirmView(bottomInset: self.view.safeAreaInsets.bottom)
        confirmView.delegate = self
        confirmView.rootView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        switch balance {
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
            confirmView.senderView.typeIcon.image = UIImage(name: .card_icon)
            confirmView.senderView.typeIcon.tintColor = .white
            confirmView.senderView.typeIcon.layer.borderColor = Theme.current.tintColor.cgColor
            confirmView.senderView.typeIcon.backgroundColor = Theme.current.tintColor
        }
        confirmView.receiverView.titleLabel.text = "\("TO_DEST".localized) \(service.service.name)"
        confirmView.receiverView.subTitleLabel.text = phoneNumber.formatedPrefix()
        confirmView.receiverView.itemIcon.loadImage(filePath: Theme.current.dark ? service.service.darkImage : service.service.image)
        confirmView.receiverView.typeIcon.image = UIImage(name: .wallet_inset)
        confirmView.receiverView.typeIcon.tintColor = Theme.current.tintColor
        confirmView.receiverView.typeIcon.layer.borderColor = Theme.current.tintColor.cgColor
        confirmView.receiverView.typeIcon.backgroundColor = Theme.current.plainTableBackColor
        confirmView.receiverInfoView.infoLabel.text = service.accountInfo.info
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
    
    func configureCode(amount: Double, balance: AppStructs.AccountInfo.BalanceType, result: AppMethods.Payments.TransactionVerify.VerifyResult) {
        self.navigationController?.navigationBar.isHidden = true
        self.setStatusBarStyle(dark: false)
        let confirmView = PaymentCodeView(amount: amount, balance: balance, result: result, walletNumber: self.viewModel.accountInfo.client.wallet, bottomInset: self.view.safeAreaInsets.bottom)
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
    
    func configureResult(amount: Double, balance: AppStructs.AccountInfo.BalanceType, result: AppMethods.Payments.TransactionVerify.VerifyResult) {
        guard let selectedService = self.selectorView.selectedService else { return }
        self.navigationController?.navigationBar.isHidden = true
        self.setStatusBarStyle(dark: false)
        let confirmView = PaymentResultView(amount: amount, balance: balance, result: result, service: selectedService.service, bottomInset: self.view.safeAreaInsets.bottom)
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
        guard let selectedBalance = self.balanceView.selectedBalance else {
            view.removeFromSuperview()
            return
        }
        let sum = self.sumView.textField.value ?? 0.0
        if result.isCheckVerify {
            self.showProgressView()
            self.viewModel.service.verifySendCode(tranID: result.tranID)
                .observe(on: MainScheduler.instance)
                .subscribe { [weak self] item in
                    guard let self = self else { return }
                    self.hideProgressView()
                    self.verifyKey = item.verifyKey
                    self.configureCode(amount: sum, balance: selectedBalance, result: result)
                } onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.hideProgressView()
                    self.showApiError(title: "ERROR".localized, error: error)
                }.disposed(by: self.viewModel.disposeBag)
        } else {
            self.commitPayment(viewToRemove:view, amount: sum, balance: selectedBalance, result: result, verifyKey: "", enteredCode: "")
        }
        view.removeFromSuperview()
    }
    
    func codeViewClose(view: PaymentCodeView) {
        self.verifyResult = nil
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: nil)
    }
    
    func codeViewNext(view: PaymentCodeView, enteredCode: String) {
        self.commitPayment(viewToRemove: view, amount: view.amount, balance: view.balance, result: view.result, verifyKey: self.verifyKey ?? "", enteredCode: enteredCode)
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
        guard let service = self.selectorView.selectedService else { return }
        let phoneNumber = "+992\(self.numberView.textField.text?.digits ?? "")"
        let comment = self.commentView.fieldView.text ?? ""
        let sum = self.sumView.textField.value ?? 0.0
        let balance = self.balanceView.selectedBalance
        self.viewModel.addFavorite(account: balance?.account ?? "", amount: sum, comment: comment, params: [phoneNumber], name: name, serviceID: service.service.id)
    }
}
