//
//  TransferAccountsView.swift
//  BarakatWallet
//
//  Created by km1tj on 22/11/23.
//

import Foundation
import UIKit

class TransferAccountsViewController: BaseViewController {
    
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
        view.isEnabled = true
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
        return view
    }()
    private let sumFieldView: PaymentFieldView = {
        let view = PaymentFieldView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var nextButtonBottom: NSLayoutConstraint!
    
    let viewModel: PaymentsViewModel
    var topupCreditCard: AppStructs.CreditDebitCard?
    weak var coordinator: PaymentsCoordinator? = nil
    
    init(viewModel: PaymentsViewModel, topupCreditCard: AppStructs.CreditDebitCard?) {
        self.viewModel = viewModel
        self.topupCreditCard = topupCreditCard
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
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
            self.topupBalanceView.topAnchor.constraint(equalTo: self.payBalanceView.bottomAnchor, constant: 10),
            self.topupBalanceView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
            self.topupBalanceView.heightAnchor.constraint(equalToConstant: width * 0.325 + 48),
            self.sumFieldView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.sumFieldView.topAnchor.constraint(equalTo: self.topupBalanceView.bottomAnchor, constant: 10),
            self.sumFieldView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.nextButton.topAnchor.constraint(greaterThanOrEqualTo: self.sumFieldView.bottomAnchor, constant: 10),
            self.nextButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButtonBottom,
            self.nextButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
        ])
        self.nextButton.addTarget(self, action: #selector(self.makePayment), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.configure()
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
    
    func configure() {
        self.sumFieldView.configure(param: self.viewModel.sumParam)
        self.topupBalanceView.configure(accounts: self.viewModel.accountInfo.accounts)
        self.payBalanceView.configure(accounts: self.viewModel.accountInfo.accounts)
    }
    
    @objc func makePayment() {
        
    }
}
