//
//  TransferConfirmView.swift
//  BarakatWallet
//
//  Created by km1tj on 15/02/24.
//

import Foundation
import UIKit

protocol TransferConfirmViewDelegate: AnyObject {
    func confirmViewClose(view: TransferConfirmView)
    func confirmViewNext(view: TransferConfirmView)
}

class TransferConfirmView: UIView {
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
        view.font = UIFont.medium(size: 18)
        view.text = "TRANSFER_CONFIRM".localized
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    let senderView: TransferSubjectView = {
        let view = TransferSubjectView(frame: .zero)
        view.titleLabel.text = "TRANSFER_SENDER".localized
        view.typeIcon.image = UIImage(name: .card_icon)
        view.typeIcon.tintColor = .white
        view.typeIcon.layer.borderColor = Theme.current.tintColor.cgColor
        view.typeIcon.backgroundColor = Theme.current.tintColor
        return view
    }()
    let receiverView: TransferSubjectView = {
        let view = TransferSubjectView(frame: .zero)
        view.titleLabel.text = "TRANSFER_RECEIVER".localized
        return view
    }()
    let receiverInfoView: HistoryInfoItemView = {
        let view = HistoryInfoItemView(withNoLine: .zero)
        view.titleLabel.textColor = Theme.current.secondaryTextColor
        view.infoLabel.textColor = Theme.current.primaryTextColor
        view.titleLabel.font = UIFont.regular(size: 14)
        view.infoLabel.font = UIFont.regular(size: 16)
        view.titleLabel.text = "RECEIVER_TRANSFER_INFO".localized
        return view
    }()
    let receiverCurrencyView: HistoryInfoItemView = {
        let view = HistoryInfoItemView(withNoLine: .zero)
        view.titleLabel.textColor = Theme.current.secondaryTextColor
        view.infoLabel.textColor = Theme.current.primaryTextColor
        view.titleLabel.font = UIFont.regular(size: 14)
        view.infoLabel.font = UIFont.bold(size: 16)
        view.titleLabel.text = "RECEIVER_TRANSFER_CURRENCY".localized
        return view
    }()
    let sumPlusView: PaymentResultItemView = {
        let view = PaymentResultItemView(title: "PLUS_AMOUNT".localized, info: "")
        view.titleLabel.textColor = Theme.current.secondaryTextColor
        view.infoLabel.textColor = Theme.current.tintColor
        view.titleLabel.font = UIFont.regular(size: 18)
        view.infoLabel.font = UIFont.bold(size: 30)
        view.titleLabel.textAlignment = .center
        view.infoLabel.textAlignment = .center
        return view
    }()
    let sumMinusView: PaymentResultItemView = {
        let view = PaymentResultItemView(title: "MINUS_AMOUNT".localized, info: "")
        view.titleLabel.textColor = Theme.current.secondaryTextColor
        view.infoLabel.textColor = Theme.current.primaryTextColor
        view.titleLabel.font = UIFont.regular(size: 14)
        view.infoLabel.font = UIFont.regular(size: 16)
        view.titleLabel.textAlignment = .center
        view.infoLabel.textAlignment = .center
        return view
    }()
    let sumComView: PaymentResultItemView = {
        let view = PaymentResultItemView(title: "", info: "")
        view.titleLabel.textColor = Theme.current.secondaryTextColor
        view.infoLabel.textColor = Theme.current.primaryTextColor
        view.titleLabel.font = UIFont.regular(size: 14)
        view.infoLabel.font = UIFont.regular(size: 16)
        view.titleLabel.textAlignment = .center
        view.infoLabel.textAlignment = .center
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
    weak var delegate: TransferConfirmViewDelegate?

    init(bottomInset: CGFloat) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.bgView)
        self.addSubview(self.rootView)
        self.rootView.addSubview(self.topAnchorView)
        self.rootView.addSubview(self.scrollView)
        self.scrollView.addSubview(self.containerView)
        self.containerView.addSubview(self.titleView)
        self.containerView.addSubview(self.senderView)
        self.containerView.addSubview(self.receiverView)
        self.containerView.addSubview(self.receiverInfoView)
        self.containerView.addSubview(self.receiverCurrencyView)
        self.containerView.addSubview(self.sumPlusView)
        self.containerView.addSubview(self.sumMinusView)
        self.containerView.addSubview(self.sumComView)
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
            self.rootView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 20),
            self.rootView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.74),
            self.topAnchorView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 16),
            self.topAnchorView.centerXAnchor.constraint(equalTo: self.rootView.centerXAnchor),
            self.topAnchorView.heightAnchor.constraint(equalToConstant: 6),
            self.topAnchorView.widthAnchor.constraint(equalToConstant: 48),
            self.scrollView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.topAnchorView.bottomAnchor, constant: 10),
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
            self.senderView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: Theme.current.mainPaddings),
            self.senderView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 20),
            self.senderView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.senderView.heightAnchor.constraint(equalToConstant: 50),
            self.receiverView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: Theme.current.mainPaddings),
            self.receiverView.topAnchor.constraint(equalTo: self.senderView.bottomAnchor, constant: 20),
            self.receiverView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.receiverView.heightAnchor.constraint(equalToConstant: 50),
            self.receiverInfoView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: Theme.current.mainPaddings),
            self.receiverInfoView.topAnchor.constraint(equalTo: self.receiverView.bottomAnchor, constant: 20),
            self.receiverInfoView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.receiverCurrencyView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: Theme.current.mainPaddings),
            self.receiverCurrencyView.topAnchor.constraint(equalTo: self.receiverInfoView.bottomAnchor, constant: 0),
            self.receiverCurrencyView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.sumPlusView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: Theme.current.mainPaddings),
            self.sumPlusView.topAnchor.constraint(equalTo: self.receiverCurrencyView.bottomAnchor, constant: 30),
            self.sumPlusView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.sumMinusView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: Theme.current.mainPaddings),
            self.sumMinusView.topAnchor.constraint(equalTo: self.sumPlusView.bottomAnchor, constant: 30),
            self.sumMinusView.rightAnchor.constraint(equalTo: self.containerView.centerXAnchor, constant: -10),
            self.sumComView.leftAnchor.constraint(equalTo: self.containerView.centerXAnchor, constant: 10),
            self.sumComView.topAnchor.constraint(equalTo: self.sumPlusView.bottomAnchor, constant: 30),
            self.sumComView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: Theme.current.mainPaddings),
            self.nextButton.topAnchor.constraint(greaterThanOrEqualTo: self.sumComView.bottomAnchor, constant: 20),
            self.nextButton.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -(20 + bottomInset + 20)),
            self.nextButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
        ])
        self.bgView.isUserInteractionEnabled = true
        self.bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.animateDismis)))
        self.nextButton.addTarget(self, action: #selector(self.nextTapped), for: .touchUpInside)
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
