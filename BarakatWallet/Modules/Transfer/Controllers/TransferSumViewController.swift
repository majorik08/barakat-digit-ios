//
//  TransferSumViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 24/10/23.
//

import Foundation
import UIKit

class TransferSumViewController: BaseViewController, UITabBarControllerDelegate, TransferSumViewControllerDelegate {
 
    lazy var topBar: TransferTopView = {
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
        //view.isEnabled = false
        return view
    }()
    let senderView: TransferCardView = {
        let view = TransferCardView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rootView.startColor = UIColor(red: 0.20, green: 0.60, blue: 0.91, alpha: 1.00)
        view.rootView.endColor = UIColor(red: 0.75, green: 0.89, blue: 0.94, alpha: 1.00)
        view.titleLabel.text = "TRANSFER_SENDER".localized
        view.logoImageView.image = UIImage(name: .card_visa)
        view.subTitleLabel.text = "*3443"
        view.iconView.layer.borderColor = UIColor.white.cgColor
        view.iconView.backgroundColor = UIColor(red: 0.20, green: 0.60, blue: 0.91, alpha: 1.00)
        view.isUserInteractionEnabled = true
        return view
    }()
    let cardReceiverView: TransferCardView = {
        let view = TransferCardView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rootView.startColor = UIColor(red: 0.66, green: 0.81, blue: 0.93, alpha: 1.00)
        view.rootView.endColor = UIColor(red: 0.90, green: 0.96, blue: 0.98, alpha: 1.00)
        view.titleLabel.text = "TRANSFER_RECEIVER".localized
        view.logoImageView.image = UIImage(name: .card_milli)
        view.subTitleLabel.text = "*1111"
        view.iconView.layer.borderColor = Theme.current.tintColor.cgColor
        view.iconView.backgroundColor = Theme.current.tintColor
        view.isUserInteractionEnabled = true
        return view
    }()
    let cardNumberReceiverView: TransferCardNumberView = {
        let view = TransferCardNumberView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rootView.startColor = UIColor(red: 0.66, green: 0.81, blue: 0.93, alpha: 1.00)
        view.rootView.endColor = UIColor(red: 0.90, green: 0.96, blue: 0.98, alpha: 1.00)
        view.titleLabel.text = "TRANSFER_RECEIVER".localized
        view.subTitleLabel.text = "Разработчик"
        view.numberLabel.text = "+992 1231231231"
        view.accountLabel.text = "на Barakat mobi"
        view.logoImageView.image = UIImage(name: .main_logo)
        view.iconView.layer.borderColor = Theme.current.tintColor.cgColor
        view.iconView.backgroundColor = Theme.current.plainTableCellColor
        view.isUserInteractionEnabled = true
        return view
    }()
    let sumRootView: TransferSumView = {
        let view = TransferSumView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var type: TransferType
    var sender: TransferIdentifier
    var receiver: TransferIdentifier
    weak var coordinator: TransferCoordinator?
    
    init(type: TransferType, sender: TransferIdentifier, receiver: TransferIdentifier) {
        self.type = type
        self.sender = sender
        self.receiver = receiver
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
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
        self.view.addSubview(self.senderView)
        self.view.addSubview(self.topBar)
        self.view.addSubview(self.sumRootView)
        self.view.addSubview(self.nextButton)
        NSLayoutConstraint.activate([
            self.topBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.topBar.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.topBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.topBar.heightAnchor.constraint(equalToConstant: 160),
            self.senderView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.senderView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.senderView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.senderView.heightAnchor.constraint(equalToConstant: 160 + 56),
            receiverView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            receiverView.topAnchor.constraint(equalTo: self.view.topAnchor),
            receiverView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            receiverView.heightAnchor.constraint(equalToConstant: 160 + 56 + receiverHeight),
            self.sumRootView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24),
            self.sumRootView.topAnchor.constraint(equalTo: receiverView.bottomAnchor, constant: 30),
            self.sumRootView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24),
            self.nextButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24),
            self.nextButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24),
            self.nextButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            self.nextButton.heightAnchor.constraint(equalToConstant: 56),
        ])
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard)))
        self.topBar.backButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        self.nextButton.addTarget(self, action: #selector(self.goToConfirm), for: .touchUpInside)
        self.senderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToPickSender)))
        self.cardReceiverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToPickReceiver)))
        self.cardNumberReceiverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToPickReceiver)))
        self.sumRootView.topSumField.becomeFirstResponder()
    }
    
    func senderPicked(sender: TransferIdentifier) {
        self.sender = sender
    }
    
    func receiverPicked(receiver: TransferIdentifier) {
        self.receiver = receiver
    }
    
    @objc func goBack() {
        self.coordinator?.navigateBack()
    }
    
    @objc func goToConfirm() {
        self.coordinator?.presentConfirm(type: self.type, sender: self.sender, receiver: self.receiver, amount: 222.22, currency: .TJS)
    }
    
    @objc func goToPickSender() {
        self.coordinator?.navigateToPickSender(type: self.type, delegate: self)
    }
    
    @objc func goToPickReceiver() {
        self.coordinator?.navigateToPickReceiver(type: self.type, sender: self.sender, delegate: self)
    }
    
    override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
        self.topBar.themeChanged(newTheme: newTheme)
    }
}
