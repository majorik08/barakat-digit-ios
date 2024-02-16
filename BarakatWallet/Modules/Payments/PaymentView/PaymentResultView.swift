//
//  PaymentResultView.swift
//  BarakatWallet
//
//  Created by km1tj on 03/02/24.
//

import Foundation
import UIKit

class PaymentResultView: UIView {
    
    let bgView: GradientView = {
        let view = GradientView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startColor = Theme.current.mainGradientStartColor
        view.endColor = Theme.current.mainGradientEndColor
        view.alpha = 1
        return view
    }()
    let imageView: InnerImageView = {
        let view = InnerImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageView.contentMode = .scaleAspectFit
        view.imageView.image = UIImage(name: .success)
        view.imageView.tintColor = .white
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
        view.text = "TRANSFER_CONFIRM".localized
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
        view.textAlignment = .center
        return view
    }()
    let serviceView: HorizontalImageText = {
        let view = HorizontalImageText(frame: .zero)
        return view
    }()
    lazy var saveFavButton: VerticalButtonView = {
        let view = VerticalButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.nameView.text = "TO_FAVORITES".localized
        view.iconView.imageView.image = UIImage(name: .fav_icon).tintedWithLinearGradientColors()
        view.iconView.imageView.layer.borderWidth = 1
        view.iconView.imageView.layer.borderColor = Theme.current.borderColor.cgColor
        view.iconView.startColor = .clear
        view.iconView.endColor = .clear
        return view
    }()
    lazy var retryButton: VerticalButtonView = {
        let view = VerticalButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.nameView.text = "REPEAT".localized
        view.iconView.imageView.image = UIImage(name: .repeat_icon).tintedWithLinearGradientColors()
        view.iconView.imageView.layer.borderWidth = 1
        view.iconView.imageView.layer.borderColor = Theme.current.borderColor.cgColor
        view.iconView.startColor = .clear
        view.iconView.endColor = .clear
        return view
    }()
    lazy var recipeButton: VerticalButtonView = {
        let view = VerticalButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.nameView.text = "SHOW_CHECK".localized
        view.iconView.imageView.image = UIImage(name: .recipe).tintedWithLinearGradientColors()
        view.iconView.imageView.layer.borderWidth = 1
        view.iconView.imageView.layer.borderColor = Theme.current.borderColor.cgColor
        view.iconView.startColor = .clear
        view.iconView.endColor = .clear
        return view
    }()
    let nextButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.radius = 14
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.setTitle("OK".localized, for: .normal)
        return view
    }()
    weak var delegate: PaymentViewsDelegate?
    let result: AppMethods.Payments.TransactionVerify.VerifyResult
    let amount: Double
    let balance: AppStructs.AccountInfo.BalanceType
    
    init(amount: Double, balance: AppStructs.AccountInfo.BalanceType, result: AppMethods.Payments.TransactionVerify.VerifyResult, service: AppStructs.PaymentGroup.ServiceItem, bottomInset: CGFloat) {
        self.result = result
        self.amount = amount
        self.balance = balance
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.bgView)
        self.addSubview(self.imageView)
        self.addSubview(self.rootView)
        self.rootView.addSubview(self.topAnchorView)
        self.rootView.addSubview(self.scrollView)
        self.scrollView.addSubview(self.containerView)
        self.containerView.addSubview(self.titleView)
        self.containerView.addSubview(self.sumView)
        self.containerView.addSubview(self.serviceView)
        self.containerView.addSubview(self.recipeButton)
        self.containerView.addSubview(self.saveFavButton)
        self.containerView.addSubview(self.retryButton)
        self.containerView.addSubview(self.nextButton)
        let rootHeight = self.containerView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        rootHeight.priority = UILayoutPriority(rawValue: 250)
        NSLayoutConstraint.activate([
            self.bgView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.bgView.topAnchor.constraint(equalTo: self.topAnchor),
            self.bgView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.bgView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.rootView.topAnchor),
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
            self.serviceView.leftAnchor.constraint(greaterThanOrEqualTo: self.containerView.leftAnchor, constant: Theme.current.mainPaddings),
            self.serviceView.topAnchor.constraint(equalTo: self.sumView.bottomAnchor, constant: 20),
            self.serviceView.rightAnchor.constraint(lessThanOrEqualTo: self.containerView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.serviceView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.serviceView.heightAnchor.constraint(equalToConstant: 38),
            self.retryButton.topAnchor.constraint(equalTo: self.serviceView.bottomAnchor, constant: 30),
            self.retryButton.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.retryButton.heightAnchor.constraint(equalToConstant: 76),
            self.retryButton.widthAnchor.constraint(equalToConstant: 68),
            self.saveFavButton.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 10),
            self.saveFavButton.topAnchor.constraint(equalTo: self.serviceView.bottomAnchor, constant: 30),
            self.saveFavButton.rightAnchor.constraint(equalTo: self.retryButton.leftAnchor, constant: -10),
            self.saveFavButton.heightAnchor.constraint(equalToConstant: 76),
            self.recipeButton.leftAnchor.constraint(equalTo: self.retryButton.rightAnchor, constant: 10),
            self.recipeButton.topAnchor.constraint(equalTo: self.serviceView.bottomAnchor, constant: 30),
            self.recipeButton.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -10),
            self.recipeButton.heightAnchor.constraint(equalToConstant: 76),
            self.nextButton.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: Theme.current.mainPaddings),
            self.nextButton.topAnchor.constraint(greaterThanOrEqualTo: self.retryButton.bottomAnchor, constant: 20),
            self.nextButton.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -(20 + bottomInset)),
            self.nextButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
        ])
        self.recipeButton.addTarget(self, action: #selector(self.buttonTapped(_:)), for: .touchUpInside)
        self.retryButton.addTarget(self, action: #selector(self.buttonTapped(_:)), for: .touchUpInside)
        self.saveFavButton.addTarget(self, action: #selector(self.buttonTapped(_:)), for: .touchUpInside)
        self.nextButton.addTarget(self, action: #selector(self.buttonTapped(_:)), for: .touchUpInside)
        
        self.titleView.text = "\("PAYMENT_IN_PROGRESS".localized)\n\(result.dateTran), \(result.timeTran)"
        self.sumView.text = amount.balanceText
        self.serviceView.iconView.loadImage(filePath: Theme.current.dark ? service.darkListImage : service.listImage)
        self.serviceView.textView.text = service.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonTapped(_ sender: UIControl) {
        if sender === self.nextButton {
            self.animateDismis {
                self.delegate?.resultViewClose(view: self, close: true, addFav: false, repeatPay: false, recipe: false)
            }
        } else if sender === self.recipeButton {
            self.delegate?.resultViewClose(view: self, close: false, addFav: false, repeatPay: false, recipe: true)
        } else if sender === self.retryButton {
            self.animateDismis {
                self.delegate?.resultViewClose(view: self, close: false, addFav: false, repeatPay: true, recipe: false)
            }
        } else if sender === self .saveFavButton {
            self.delegate?.resultViewClose(view: self, close: false, addFav: true, repeatPay: false, recipe: false)
        }
    }
    
    func animateView() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.rootView.transform = .identity
        }, completion: {(finished: Bool) -> Void in })
    }
    
    func animateDismis(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {() -> Void in
            self.rootView.transform = CGAffineTransform(translationX: 0, y: self.bounds.height)
        }, completion: {(finished: Bool) -> Void in
            self.removeFromSuperview()
            completion?()
        })
    }
}
