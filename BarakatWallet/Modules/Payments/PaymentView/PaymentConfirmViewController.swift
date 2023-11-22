//
//  PaymentConfirmViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 11/11/23.
//

import Foundation
import UIKit

class PaymentConfirmViewController: BaseViewController {
    
    let bgView: GradientView = {
        let view = GradientView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startColor = Theme.current.mainGradientStartColor
        view.endColor = Theme.current.mainGradientEndColor
        view.alpha = 0.5
        view.isUserInteractionEnabled = true
        return view
    }()
    let imageView: InnerImageView = {
        let view = InnerImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageView.contentMode = .scaleAspectFit
        view.imageView.image = UIImage(name: .success)
        view.imageView.tintColor = .white
        view.isHidden = true
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
    let titleView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.medium(size: 17)
        view.text = "TRANSFER_CONFIRM".localized
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    private let scrollView: UIScrollView = {
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
    let nextButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.radius = 14
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.setTitle("CONTINUE".localized, for: .normal)
        return view
    }()

    let amount: Double
    let currency: Currency
    let viewModel: PaymentsViewModel
    let service: AppStructs.PaymentGroup.ServiceItem
    weak var coordinator: PaymentsCoordinator?
    
    init(viewModel: PaymentsViewModel, service: AppStructs.PaymentGroup.ServiceItem, amount: Double, currency: Currency) {
        self.amount = amount
        self.currency = currency
        self.viewModel = viewModel
        self.service = service
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
        self.modalPresentationCapturesStatusBarAppearance = true
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
        self.rootView.addSubview(self.scrollView)
        self.rootView.addSubview(self.nextButton)
        self.scrollView.addSubview(self.containerView)
        let rootHeight = self.containerView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        rootHeight.priority = UILayoutPriority(rawValue: 250)
        NSLayoutConstraint.activate([
            self.bgView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.bgView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.bgView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.bgView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.imageView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.rootView.topAnchor),
            self.rootView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.rootView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.rootView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.rootView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6),
            self.topAnchorView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 16),
            self.topAnchorView.centerXAnchor.constraint(equalTo: self.rootView.centerXAnchor),
            self.topAnchorView.heightAnchor.constraint(equalToConstant: 6),
            self.topAnchorView.widthAnchor.constraint(equalToConstant: 48),
            self.titleView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.titleView.topAnchor.constraint(equalTo: self.topAnchorView.bottomAnchor, constant: 20),
            self.titleView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.scrollView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 20),
            self.scrollView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.scrollView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.containerView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.containerView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.containerView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.containerView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            rootHeight,
            self.nextButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.nextButton.topAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: 20),
            self.nextButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -(self.view.safeAreaInsets.bottom + 30)),
            self.nextButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
        ])
        self.rootView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        self.bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismisIfCan)))
        self.nextButton.addTarget(self, action: #selector(self.goToPay), for: .touchUpInside)
        self.configureConfirm()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            return .default
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.animateView()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    func animateView() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.rootView.transform = .identity
        }, completion: {(finished: Bool) -> Void in })
    }
    
    func animateDismis() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {() -> Void in
            self.rootView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        }, completion: {(finished: Bool) -> Void in
            self.dismiss(animated: true)
        })
    }
    
    @objc func dismisIfCan() {
        self.animateDismis()
    }
    
    @objc func goToPay() {
        if let view = self.containerView.subviews.first as? PaymentConfirmView {
            view.removeFromSuperview()
            self.configureResult()
        } else if let view = self.containerView.subviews.first as? PaymentResultView {
            view.removeFromSuperview()
            self.animateDismis()
            self.coordinator?.navigateToRootViewController()
        }
    }
    
    @objc func goToCheckView() {
        self.animateDismis()
        self.coordinator?.navigateToRootViewController()
        self.coordinator?.navigateToHistoryView()
    }
    
    @objc func goToSaveService() {
        self.coordinator?.presentSaveToFavorites()
    }
    
    func configureConfirm() {
        self.imageView.isHidden = true
        self.bgView.alpha = 0.5
        let confirmView = PaymentConfirmView(frame: .zero)
        self.containerView.addSubview(confirmView)
        NSLayoutConstraint.activate([
            confirmView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor),
            confirmView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            confirmView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor),
            confirmView.bottomAnchor.constraint(lessThanOrEqualTo: self.containerView.bottomAnchor)
        ])
        confirmView.configure()
    }
    
    func configureResult() {
        self.imageView.isHidden = false
        self.bgView.alpha = 1
        let resultView = PaymentResultView(frame: .zero)
        self.containerView.addSubview(resultView)
        NSLayoutConstraint.activate([
            resultView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor),
            resultView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            resultView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor),
            resultView.bottomAnchor.constraint(lessThanOrEqualTo: self.containerView.bottomAnchor)
        ])
        resultView.recipeButton.addTarget(self, action: #selector(self.goToCheckView), for: .touchUpInside)
        resultView.retryButton.addTarget(self, action: #selector(self.dismisIfCan), for: .touchUpInside)
        resultView.saveFavButton.addTarget(self, action: #selector(self.goToSaveService), for: .touchUpInside)
    }
}
