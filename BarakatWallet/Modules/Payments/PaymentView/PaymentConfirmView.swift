//
//  PaymentConfirmView.swift
//  BarakatWallet
//
//  Created by km1tj on 03/02/24.
//

import Foundation
import UIKit

class PaymentConfirmView: UIView {
    
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
        view.text = "PAYMENT_CONFIRM".localized
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    let sumView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 30)
        view.textColor = Theme.current.tintColor
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.4
        return view
    }()
    let stackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 16
        view.translatesAutoresizingMaskIntoConstraints = false
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
    weak var delegate: PaymentViewsDelegate?
    let result: AppMethods.Payments.TransactionVerify.VerifyResult
    let amount: Double
    let balance: AppStructs.AccountInfo.BalanceType

    init(amount: Double, balance: AppStructs.AccountInfo.BalanceType, result: AppMethods.Payments.TransactionVerify.VerifyResult, service: AppStructs.PaymentGroup.ServiceItem, params: [String], bottomInset: CGFloat) {
        self.result = result
        self.amount = amount
        self.balance = balance
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.bgView)
        self.addSubview(self.rootView)
        self.rootView.addSubview(self.topAnchorView)
        self.rootView.addSubview(self.scrollView)
        self.scrollView.addSubview(self.containerView)
        self.containerView.addSubview(self.titleView)
        self.containerView.addSubview(self.sumView)
        self.containerView.addSubview(self.stackView)
        self.containerView.addSubview(self.nextButton)
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
            self.sumView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: Theme.current.mainPaddings),
            self.sumView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 20),
            self.sumView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.stackView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: Theme.current.mainPaddings),
            self.stackView.topAnchor.constraint(equalTo: self.sumView.bottomAnchor, constant: 20),
            self.stackView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: Theme.current.mainPaddings),
            self.nextButton.topAnchor.constraint(greaterThanOrEqualTo: self.stackView.bottomAnchor, constant: 20),
            self.nextButton.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -(20 + bottomInset)),
            self.nextButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
        ])
        self.bgView.isUserInteractionEnabled = true
        self.bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.animateDismis)))
        self.nextButton.addTarget(self, action: #selector(self.nextTapped), for: .touchUpInside)
        
        self.nextButton.setTitle("PAY_SUM_TEXT".localizedFormat(arguments: amount.balanceText), for: .normal)
        self.sumView.text = amount.balanceText
        self.stackView.addArrangedSubview(PaymentResultItemView(title: "HISTORY_TITLE".localized, info: service.name))
        for param in service.params.enumerated() {
            if params.count > param.offset {
                self.stackView.addArrangedSubview(PaymentResultItemView(title: param.element.name, info: params[param.offset]))
            } else {
                self.stackView.addArrangedSubview(PaymentResultItemView(title: param.element.name, info: ""))
            }
        }
        self.stackView.addArrangedSubview(PaymentResultItemView(title: "HISTORY_FROM_BILL".localized, info: balance.name))
        self.stackView.addArrangedSubview(PaymentResultItemView(title: "HISTORY_FEE".localized, info: result.commission.balanceText))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func nextTapped() {
        self.delegate?.confirmViewNext(view: self)
    }
    
    @objc func animateDismis() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {() -> Void in
            self.rootView.transform = CGAffineTransform(translationX: 0, y: self.bounds.height)
        }, completion: {(finished: Bool) -> Void in
            self.removeFromSuperview()
            self.delegate?.confirmViewClose(view: self)
        })
    }
    
    func animateView() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.rootView.transform = .identity
        }, completion: {(finished: Bool) -> Void in })
    }
}
