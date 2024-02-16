//
//  PaymentViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 08/11/23.
//

import Foundation
import UIKit
import RxSwift

protocol PaymentViewsDelegate: AnyObject {
    func confirmViewClose(view: PaymentConfirmView)
    func confirmViewNext(view: PaymentConfirmView)
    func codeViewClose(view: PaymentCodeView)
    func codeViewNext(view: PaymentCodeView, enteredCode: String)
    func resultViewClose(view: PaymentResultView, close: Bool, addFav: Bool, repeatPay: Bool, recipe: Bool)
}

class PaymentViewController: BaseViewController, AddFavoriteViewControllerDelegate, PaymentFieldDelegate, PaymentViewsDelegate {
   
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
        view.setTitle("SEND".localized, for: .normal)
        view.isEnabled = true
        return view
    }()
    private let balanceView: BalanceSelectView = {
        let view = BalanceSelectView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let stackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var nextButtonBottom: NSLayoutConstraint!
    let addFavoriteMode: Bool
    let viewModel: PaymentsViewModel
    let service: AppStructs.PaymentGroup.ServiceItem
    let favorite: AppStructs.Favourite?
    let merchant: AppStructs.Merchant?
    weak var coordinator: PaymentsCoordinator? = nil
    
    init(viewModel: PaymentsViewModel, service: AppStructs.PaymentGroup.ServiceItem, merchant: AppStructs.Merchant?, favorite: AppStructs.Favourite?, addFavoriteMode: Bool) {
        self.viewModel = viewModel
        self.addFavoriteMode = addFavoriteMode
        self.favorite = favorite
        self.service = service
        self.merchant = merchant
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
        self.navigationItem.title = self.service.name
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.rootView)
        self.rootView.addSubview(self.balanceView)
        self.rootView.addSubview(self.stackView)
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
        ])
        if let merchant = self.merchant {
            let merView = PaymentMerchantView(title: merchant.name, info: merchant.merchantAddress, image: nil)
            self.rootView.addSubview(merView)
            NSLayoutConstraint.activate([
                merView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
                merView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 10),
                merView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
                self.balanceView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
                self.balanceView.topAnchor.constraint(equalTo: merView.bottomAnchor, constant: 20),
                self.balanceView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
                self.balanceView.heightAnchor.constraint(equalToConstant: width * 0.325 + 48),
                self.stackView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
                self.stackView.topAnchor.constraint(equalTo: self.balanceView.bottomAnchor, constant: 20),
                self.stackView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
                self.nextButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
                self.nextButton.topAnchor.constraint(greaterThanOrEqualTo: self.stackView.bottomAnchor, constant: 20),
                self.nextButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
                self.nextButtonBottom,
                self.nextButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
            ])
        } else {
            NSLayoutConstraint.activate([
                self.balanceView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
                self.balanceView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 10),
                self.balanceView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
                self.balanceView.heightAnchor.constraint(equalToConstant: width * 0.325 + 48),
                self.stackView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
                self.stackView.topAnchor.constraint(equalTo: self.balanceView.bottomAnchor, constant: 20),
                self.stackView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
                self.nextButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
                self.nextButton.topAnchor.constraint(greaterThanOrEqualTo: self.stackView.bottomAnchor, constant: 20),
                self.nextButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
                self.nextButtonBottom,
                self.nextButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
            ])
        }
        if self.addFavoriteMode {
            self.nextButton.setTitle("ADD_FAV".localized, for: .normal)
        }
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: nil)
        self.nextButton.addTarget(self, action: #selector(self.makePayment), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.viewModel.didAddFavorite.subscribe { _ in
            self.coordinator?.navigateToRootViewController()
        }.disposed(by: self.viewModel.disposeBag)
        self.viewModel.didLoadServiceInfo.subscribe { [weak self] info in
            self?.addClientInfo(info: info)
        }.disposed(by: self.viewModel.disposeBag)
        self.configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    func getServiceAccountInfo(account: String) {
        if self.service.isCheck == 1, !account.isEmpty {
            self.viewModel.checkServiceInfo(service: "\(self.service.id)", account: account)
        }
    }
    
    @objc func makePayment() {
        if self.addFavoriteMode {
            let vc = AddFavoriteViewController()
            vc.delegate = self
            self.present(vc, animated: true)
        } else {
            self.makePayemnt()
        }
    }
    
    func addFavorite(name: String) {
        let balance = self.balanceView.selectedBalance
        self.viewModel.addFavorite(account: balance?.account ?? "", amount: self.getEnteredSum() ?? 0, comment: "", params: self.getParams(), name: name, serviceID: self.service.id)
    }
    
    func configure() {
        self.balanceView.configure(clientBalances: self.viewModel.accountInfo.clientBalances)
        let sorted = self.service.params.sorted(by: { $0.param < $1.param })
        for param in sorted {
            let fieldView = PaymentFieldView(frame: .zero)
            fieldView.delegate = self
            fieldView.configure(param: param, validate: true)
            self.stackView.addArrangedSubview(fieldView)
        }
        let fieldView = PaymentFieldView(frame: .zero)
        fieldView.configure(param: self.viewModel.sumParam, validate: false)
        self.stackView.addArrangedSubview(fieldView)
    }
    
    func addClientInfo(info: String) {
        guard !info.isEmpty else { return }
        if let v = self.stackView.arrangedSubviews.first(where: { $0 is PaymentServiceInfoView }) {
            v.removeFromSuperview()
        }
        let infoView = PaymentServiceInfoView(frame: .zero)
        infoView.infoLabel.text = info
        self.stackView.insertArrangedSubview(infoView, at: self.stackView.arrangedSubviews.count - 1)
    }
    
    private func getEnteredSum() -> Double? {
        if let sumView = self.stackView.arrangedSubviews.first(where: { $0.tag == self.viewModel.sumParam.id }) as? PaymentFieldView {
            return Double(sumView.fieldView.text ?? "0") ?? 0
        }
        return nil
    }
    
    private func getParams() -> [String] {
        var params: [String] = []
        for item in self.stackView.arrangedSubviews {
            guard let enterView = item as? PaymentFieldView, item.tag != self.viewModel.sumParam.id else { continue }
            params.append(enterView.fieldView.text ?? "")
        }
        return params
    }
    
    private func verifyParams() -> Bool {
        if let _ = self.merchant {
            return true
        } else {
            var result = true
            for item in self.stackView.arrangedSubviews {
                guard let enterView = item as? PaymentFieldView, item.tag != self.viewModel.sumParam.id, let param = enterView.param else { continue }
                if !enterView.regexCheck(pattern: param.mask, text: enterView.fieldView.text ?? "") {
                    result = false
                }
            }
            return result
        }
    }
    
    func makePayemnt() {
        guard let selectedBalance = self.balanceView.selectedBalance else { return }
        guard let sum = self.getEnteredSum(), self.verifyParams() else { return }
        let params = self.getParams()
        self.showProgressView()
        self.viewModel.service.verifyPayment(account: selectedBalance.account, accountType: selectedBalance.accountType, amount: sum, comment: "", params: params, serviceID: self.service.id)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self = self else { return }
                self.hideProgressView()
                self.configureConfirm(amount: sum, balance: selectedBalance, result: result, params: params)
            } onFailure: { [weak self] error in
                guard let self = self else { return }
                self.hideProgressView()
                self.showServerErrorAlert()
            }.disposed(by: self.viewModel.disposeBag)
    }
    
    func commitPayment(viewToRemove: UIView, amount: Double, balance: AppStructs.AccountInfo.BalanceType, result: AppMethods.Payments.TransactionVerify.VerifyResult, enteredCode: String) {
        self.showProgressView()
        self.viewModel.service.commitPayment(tranID: result.tranID, code: enteredCode, key: result.verifyKey)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.hideProgressView()
                self.configureResult(amount: amount, balance: balance, result: result)
                viewToRemove.removeFromSuperview()
            } onFailure: { [weak self] error in
                guard let self = self else { return }
                self.hideProgressView()
                self.showServerErrorAlert()
            }.disposed(by: self.viewModel.disposeBag)
    }
    
    func configureConfirm(amount: Double, balance: AppStructs.AccountInfo.BalanceType, result: AppMethods.Payments.TransactionVerify.VerifyResult, params: [String]) {
        self.navigationController?.navigationBar.isHidden = true
        self.setStatusBarStyle(dark: false)
        let confirmView = PaymentConfirmView(amount: amount, balance: balance, result: result, service: self.service, params: params, bottomInset: self.view.safeAreaInsets.bottom)
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
        self.navigationController?.navigationBar.isHidden = true
        self.setStatusBarStyle(dark: false)
        let confirmView = PaymentResultView(amount: amount, balance: balance, result: result, service: self.service, bottomInset: self.view.safeAreaInsets.bottom)
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
    
    func confirmViewClose(view: PaymentConfirmView) {
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: nil)
    }
    
    func confirmViewNext(view: PaymentConfirmView) {
        if view.result.isCheckVerify {
            self.configureCode(amount: view.amount, balance: view.balance, result: view.result)
        } else {
            self.commitPayment(viewToRemove:view, amount: view.amount, balance: view.balance, result: view.result, enteredCode: "")
        }
        view.removeFromSuperview()
    }
    
    func codeViewClose(view: PaymentCodeView) {
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: nil)
    }
    
    func codeViewNext(view: PaymentCodeView, enteredCode: String) {
        self.commitPayment(viewToRemove: view, amount: view.amount, balance: view.balance, result: view.result, enteredCode: enteredCode)
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
                } onFailure: { [weak self] _ in
                    guard let self = self else { return }
                    self.hideProgressView()
                    self.showServerErrorAlert()
                }.disposed(by: self.viewModel.disposeBag)
        } else {
            self.navigationController?.navigationBar.isHidden = false
            self.setStatusBarStyle(dark: nil)
            self.coordinator?.navigateToRootViewController()
        }
    }
}
