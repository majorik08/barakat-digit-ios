//
//  PaymentCodeView.swift
//  BarakatWallet
//
//  Created by km1tj on 03/02/24.
//

import Foundation
import UIKit

class PaymentCodeView: UIView {
    
    let bgView: GradientView = {
        let view = GradientView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startColor = Theme.current.mainGradientStartColor
        view.endColor = Theme.current.mainGradientEndColor
        view.alpha = 0.5
        view.isUserInteractionEnabled = true
        return view
    }()
    let rootView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.plainTableBackColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        return view
    }()
    let topAnchorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red:0.73, green:0.74, blue:0.75, alpha:1.0)
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
        return view
    }()
    let scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alwaysBounceVertical = true
        view.keyboardDismissMode = .interactive
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        return view
    }()
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    let titleView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.medium(size: 19)
        view.text = "PAYMENT_CODE_TITLE".localized
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    let numberHint: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 16)
        view.textColor = Theme.current.primaryTextColor
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.text = "SMS_SENDED_TO".localizedFormat(arguments: "")
        return view
    }()
    let numberView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1.8
        view.layer.borderColor = Theme.current.borderColor.cgColor
        return view
    }()
    let codeField: UITextField = {
        let view = UITextField(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 20)
        view.borderStyle = .none
        if #available(iOS 12.0, *) {
            view.textContentType = .oneTimeCode
        }
        view.keyboardType = .numberPad
        view.textAlignment = .center
        view.textColor = Theme.current.primaryTextColor
        view.attributedPlaceholder = NSAttributedString(string: "SMS_CODE".localized, attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryTextColor])
        return view
    }()
    let timerHint: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 14)
        view.textColor = Theme.current.secondaryTextColor
        view.text = "RESEND_AFTER".localized
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.textAlignment = .center
        return view
    }()
    let nextButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.radius = 14
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.setTitle("CONTINUE".localized, for: .normal)
        return view
    }()
    let sendAgainButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        view.layer.borderColor = Theme.current.borderColor.cgColor
        view.layer.borderWidth = 1
        view.setTitle("RESEND_CODE_TITLE".localized, for: .normal)
        view.setTitleColor(Theme.current.tintColor, for: .normal)
        view.isEnabled = false
        return view
    }()
    weak var delegate: PaymentViewsDelegate?
    let result: AppMethods.Payments.TransactionVerify.VerifyResult
    let amount: Double
    let balance: AppStructs.AccountInfo.BalanceType
    var timer: Timer? = nil
    var waitTime: Int = 30
    
    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    init(amount: Double, balance: AppStructs.AccountInfo.BalanceType, result: AppMethods.Payments.TransactionVerify.VerifyResult, walletNumber: String, bottomInset: CGFloat) {
        self.result = result
        self.amount = amount
        self.balance = balance
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.bgView)
        self.addSubview(self.rootView)
        self.rootView.addSubview(self.topAnchorView)
        self.rootView.addSubview(self.scrollView)
        self.scrollView.addSubview(self.containerView)
        self.containerView.addSubview(self.titleView)
        self.containerView.addSubview(self.numberHint)
        self.containerView.addSubview(self.numberView)
        self.containerView.addSubview(self.timerHint)
        self.containerView.addSubview(self.nextButton)
        self.containerView.addSubview(self.sendAgainButton)
        self.numberView.addSubview(self.codeField)
        let rootHeight = self.containerView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        rootHeight.priority = UILayoutPriority(rawValue: 250)
        NSLayoutConstraint.activate([
            self.bgView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.bgView.topAnchor.constraint(equalTo: self.topAnchor),
            self.bgView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.bgView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.rootView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.rootView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.rootView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.rootView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6),
            self.topAnchorView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 16),
            self.topAnchorView.centerXAnchor.constraint(equalTo: self.rootView.centerXAnchor),
            self.topAnchorView.heightAnchor.constraint(equalToConstant: 6),
            self.topAnchorView.widthAnchor.constraint(equalToConstant: 48),
            self.scrollView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.topAnchorView.bottomAnchor, constant: 20),
            self.scrollView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor),
            self.containerView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.containerView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.containerView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.containerView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            rootHeight,
            self.titleView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: Theme.current.mainPaddings),
            self.titleView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 0),
            self.titleView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.numberHint.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: Theme.current.mainPaddings),
            self.numberHint.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 30),
            self.numberHint.rightAnchor.constraint(lessThanOrEqualTo: self.containerView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.numberView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: Theme.current.mainPaddings),
            self.numberView.topAnchor.constraint(equalTo: self.numberHint.bottomAnchor, constant: 10),
            self.numberView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.numberView.heightAnchor.constraint(equalToConstant: 46),
            self.codeField.leftAnchor.constraint(equalTo: self.numberView.leftAnchor, constant: 8),
            self.codeField.topAnchor.constraint(equalTo: self.numberView.topAnchor, constant: 6),
            self.codeField.rightAnchor.constraint(equalTo: self.numberView.rightAnchor, constant: -8),
            self.codeField.bottomAnchor.constraint(equalTo: self.numberView.bottomAnchor, constant: -6),
            self.timerHint.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: Theme.current.mainPaddings),
            self.timerHint.topAnchor.constraint(equalTo: self.numberView.bottomAnchor, constant: 20),
            self.timerHint.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: Theme.current.mainPaddings),
            self.nextButton.topAnchor.constraint(greaterThanOrEqualTo: self.timerHint.bottomAnchor, constant: 20),
            self.nextButton.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
            self.sendAgainButton.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: Theme.current.mainPaddings),
            self.sendAgainButton.topAnchor.constraint(equalTo: self.nextButton.bottomAnchor, constant: 20),
            self.sendAgainButton.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.sendAgainButton.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -(20 + bottomInset)),
            self.sendAgainButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
        ])
        self.bgView.isUserInteractionEnabled = true
        self.bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.animateDismis)))
        self.nextButton.addTarget(self, action: #selector(self.nextTapped), for: .touchUpInside)
        self.sendAgainButton.addTarget(self, action: #selector(self.resendCode), for: .touchUpInside)
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(canResentCode), userInfo: nil, repeats: true)
        self.numberHint.text = "SMS_SENDED_TO".localizedFormat(arguments: walletNumber)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func canResentCode() {
        if self.waitTime > 0 {
            self.waitTime -= 1
            let mutableText = NSMutableAttributedString(string: "\("RESEND_AFTER".localized): ", attributes: [NSAttributedString.Key.foregroundColor : Theme.current.secondaryTextColor])
            mutableText.append(NSAttributedString(string: "\(self.waitTime)", attributes: [NSAttributedString.Key.foregroundColor : Theme.current.tintColor]))
            self.timerHint.attributedText = mutableText
        } else {
            self.sendAgainButton.isEnabled = true
            self.timerHint.attributedText = nil
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    @objc func resendCode() {
        if self.waitTime <= 0 {
            
        }
    }
    
    @objc func nextTapped() {
        self.delegate?.codeViewNext(view: self, enteredCode: self.codeField.text ?? "")
    }
    
    @objc func animateDismis() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {() -> Void in
            self.rootView.transform = CGAffineTransform(translationX: 0, y: self.bounds.height)
        }, completion: {(finished: Bool) -> Void in
            self.removeFromSuperview()
            self.delegate?.codeViewClose(view: self)
        })
    }
    
    func animateView() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.rootView.transform = .identity
        }, completion: {(finished: Bool) -> Void in })
    }
}
