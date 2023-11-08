//
//  TransferResultViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 25/10/23.
//

import Foundation
import UIKit

class TransferResultViewController: BaseViewController {
    
    let bgView: GradientView = {
        let view = GradientView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startColor = Theme.current.mainGradientStartColor
        view.endColor = Theme.current.mainGradientEndColor
        view.alpha = 1
        return view
    }()
    let imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(name: .success)
        view.tintColor = .white
        return view
    }()
    let rootView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.navigationColor
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
    let titleView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .systemGreen
        view.font = UIFont.bold(size: 20)
        view.text = "TRANSFER_CONFIRM".localized
        view.textAlignment = .center
        return view
    }()
    let sumView: GradientLabel = {
        let view = GradientLabel(shadowEnabled: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 38)
        view.text = "1111.11 TJS"
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.4
        view.textAlignment = .center
        return view
    }()
    let sumInfoView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.secondaryTextColor
        view.font = UIFont.regular(size: 16)
        view.text = "Комиссия 40.00 RUB"
        view.textAlignment = .center
        return view
    }()
    lazy var sendCheckView: VerticalButtonView = {
        let view = VerticalButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.nameView.text = "SEND_CHECK".localized
        view.iconView.image = UIImage(name: .share).tintedWithLinearGradientColors()
        return view
    }()
    lazy var checkView: VerticalButtonView = {
        let view = VerticalButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.nameView.text = "SHOW_CHECK".localized
        view.iconView.image = UIImage(name: .recipe).tintedWithLinearGradientColors()
        return view
    }()
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
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
    
    let type: TransferType
    let sender: TransferIdentifier
    let receiver: TransferIdentifier
    let amount: Double
    let currency: Currency
    let result: Bool
    weak var coordinator: TransferCoordinator?
    
    init(type: TransferType, sender: TransferIdentifier, receiver: TransferIdentifier, amount: Double, currency: Currency, result: Bool) {
        self.type = type
        self.amount = amount
        self.currency = currency
        self.sender = sender
        self.receiver = receiver
        self.result = result
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.view.addSubview(self.bgView)
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.rootView)
        self.rootView.addSubview(self.topAnchorView)
        self.rootView.addSubview(self.titleView)
        self.rootView.addSubview(self.containerView)
        self.containerView.addSubview(self.sumView)
        self.containerView.addSubview(self.sumInfoView)
        self.containerView.addSubview(self.checkView)
        self.containerView.addSubview(self.sendCheckView)
        self.containerView.addSubview(self.nextButton)
        NSLayoutConstraint.activate([
            self.bgView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.bgView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.bgView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.bgView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.imageView.heightAnchor.constraint(equalToConstant: 100),
            self.imageView.widthAnchor.constraint(equalToConstant: 100),
            self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIApplication.statusBarHeight + 44 + 10),
            self.rootView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.rootView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 40),
            self.rootView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.rootView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.topAnchorView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 16),
            self.topAnchorView.centerXAnchor.constraint(equalTo: self.rootView.centerXAnchor),
            self.topAnchorView.heightAnchor.constraint(equalToConstant: 6),
            self.topAnchorView.widthAnchor.constraint(equalToConstant: 42),
            self.titleView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 16),
            self.titleView.topAnchor.constraint(equalTo: self.topAnchorView.bottomAnchor, constant: 50),
            self.titleView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -16),
            self.containerView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 30),
            self.containerView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
            self.containerView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
            self.containerView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0),
            self.sumView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 0),
            self.sumView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 16),
            self.sumView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -16),
            self.sumInfoView.topAnchor.constraint(equalTo: self.sumView.bottomAnchor, constant: 10),
            self.sumInfoView.leftAnchor.constraint(equalTo: self.sumView.leftAnchor, constant: 16),
            self.sumInfoView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -16),
            self.sendCheckView.topAnchor.constraint(equalTo: self.sumInfoView.bottomAnchor, constant: 30),
            self.sendCheckView.rightAnchor.constraint(equalTo: self.containerView.centerXAnchor, constant: -30),
            self.sendCheckView.widthAnchor.constraint(equalToConstant: 64),
            self.checkView.topAnchor.constraint(equalTo: self.sumInfoView.bottomAnchor, constant: 30),
            self.checkView.leftAnchor.constraint(equalTo: self.containerView.centerXAnchor, constant: 30),
            self.checkView.widthAnchor.constraint(equalToConstant: 64),
            self.nextButton.topAnchor.constraint(greaterThanOrEqualTo: self.checkView.bottomAnchor, constant: 50),
            self.nextButton.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 24),
            self.nextButton.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -24),
            self.nextButton.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -40),
            self.nextButton.heightAnchor.constraint(equalToConstant: 56),
        ])
        self.rootView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        
        self.nextButton.addTarget(self, action: #selector(self.animateDismis), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.animateView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    func animateView() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.rootView.transform = .identity
        }, completion: {(finished: Bool) -> Void in })
    }
    
    @objc func animateDismis() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {() -> Void in
            self.rootView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        }, completion: {(finished: Bool) -> Void in
            self.dismiss(animated: true)
            self.coordinator?.navigateToMain()
        })
    }
}
