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

class TransferByNumberViewController: BaseViewController {
    
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
    let numberView: CardTextFiled = {
        let view = PhoneNumberTextField(withPhoneNumberKit: Constants.phoneNumberKit)
        let filedView = CardTextFiled(textField: view)
        filedView.topLabel.text = "PHONE_NUMBER".localized
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
    let selectorView: PaymentServiceSelectView = {
        let view = PaymentServiceSelectView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let sumView: PaymentFieldView = {
        let view = PaymentFieldView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let commentView: PaymentFieldView = {
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
        view.isEnabled = true
        return view
    }()
    var nextButtonBottom: NSLayoutConstraint!
    let viewModel: PaymentsViewModel
    weak var coordinator: PaymentsCoordinator? = nil
    
    init(viewModel: PaymentsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
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
        self.rootView.addSubview(self.sumView)
        self.rootView.addSubview(self.commentView)
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
            self.sumView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.sumView.topAnchor.constraint(equalTo: self.selectorView.bottomAnchor, constant: 10),
            self.sumView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.commentView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.commentView.topAnchor.constraint(equalTo: self.sumView.bottomAnchor, constant: 10),
            self.commentView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.nextButton.topAnchor.constraint(greaterThanOrEqualTo: self.commentView.bottomAnchor, constant: 20),
            self.nextButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButtonBottom,
            self.nextButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
        ])
        self.sumView.configure(param: self.viewModel.sumParam, validate: false)
        self.commentView.configure(param: self.viewModel.messageParam, validate: false)
        self.balanceView.configure(clientBalances: self.viewModel.accountInfo.clientBalances)
        let validNumber = self.numberView.textField.rx.text.orEmpty
        validNumber
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter({ $0.count >= 6 })
            .flatMap { str in
                return self.viewModel.loadNumberServices(number: str.digits)
            }
            .subscribe { [weak self] services in
                self?.selectorView.configure(services: services)
            } onError: { _ in
                
            }.disposed(by: self.viewModel.disposeBag)
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
            }
        }
        self.nextButtonBottom.constant = -(visibleHeight - 20 + 2)
    }
     
    @objc func keyboardWillHide(_ notification: Notification) {
        self.nextButtonBottom.constant = -20
    }
}
