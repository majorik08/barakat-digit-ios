//
//  HistoryDetails.swift
//  BarakatWallet
//
//  Created by km1tj on 06/11/23.
//

import Foundation
import UIKit
import RxSwift

class HistoryDetailsViewController: BaseViewController, AddFavoriteViewControllerDelegate {
    
    let bgView: GradientView = {
        let view = GradientView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startColor = Theme.current.mainGradientStartColor
        view.endColor = Theme.current.mainGradientEndColor
        view.alpha = 1
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
    let statusLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .systemGreen
        view.font = UIFont.medium(size: 20)
        view.text = "Платеж выполнен"
        view.numberOfLines = 0
        return view
    }()
    let sumLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.tintColor
        view.font = UIFont.medium(size: 30)
        view.numberOfLines = 0
        return view
    }()
    let statusIcon: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(name: .success)
        view.tintColor = Theme.current.tintColor
        return view
    }()
    let saveFavButton: VerticalButtonView = {
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
    let retryButton: VerticalButtonView = {
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
    let recipeButton: VerticalButtonView = {
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
    let stackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let viewModel: HistoryViewModel
    let item: AppStructs.HistoryItem
    weak var coordinator: HistoryCoordinator? = nil
     
    init(viewModel: HistoryViewModel, item: AppStructs.HistoryItem) {
        self.viewModel = viewModel
        self.item = item
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.view.addSubview(self.bgView)
        self.view.addSubview(self.rootView)
        self.rootView.addSubview(self.topAnchorView)
        self.rootView.addSubview(self.scrollView)
        self.scrollView.addSubview(self.containerView)
        self.containerView.addSubview(self.statusLabel)
        self.containerView.addSubview(self.sumLabel)
        self.containerView.addSubview(self.statusIcon)
        self.containerView.addSubview(self.saveFavButton)
        self.containerView.addSubview(self.retryButton)
        self.containerView.addSubview(self.recipeButton)
        self.containerView.addSubview(self.stackView)
        let rootHeight = self.containerView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        rootHeight.priority = UILayoutPriority(rawValue: 250)
        NSLayoutConstraint.activate([
            self.bgView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.bgView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.bgView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.bgView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.rootView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.rootView.topAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.rootView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.rootView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.rootView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.8),
            self.topAnchorView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 16),
            self.topAnchorView.centerXAnchor.constraint(equalTo: self.rootView.centerXAnchor),
            self.topAnchorView.heightAnchor.constraint(equalToConstant: 6),
            self.topAnchorView.widthAnchor.constraint(equalToConstant: 48),
            self.scrollView.topAnchor.constraint(equalTo: self.topAnchorView.bottomAnchor, constant: 20),
            self.scrollView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings + 20),
            self.scrollView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -(Theme.current.mainPaddings + 20)),
            self.scrollView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -(self.view.safeAreaInsets.bottom + 30)),
            self.containerView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.containerView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.containerView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.containerView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            rootHeight,
            self.statusLabel.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 0),
            self.statusLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.statusLabel.rightAnchor.constraint(equalTo: self.statusIcon.leftAnchor, constant: -10),
            self.sumLabel.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 0),
            self.sumLabel.topAnchor.constraint(equalTo: self.statusLabel.bottomAnchor, constant: 6),
            self.sumLabel.rightAnchor.constraint(equalTo: self.statusIcon.leftAnchor, constant: -10),
            self.statusIcon.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.statusIcon.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: 0),
            self.statusIcon.widthAnchor.constraint(equalToConstant: 55),
            self.statusIcon.heightAnchor.constraint(equalToConstant: 55),
            self.retryButton.topAnchor.constraint(equalTo: self.statusIcon.bottomAnchor, constant: 40),
            self.retryButton.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.retryButton.heightAnchor.constraint(equalToConstant: 76),
            self.saveFavButton.leftAnchor.constraint(equalTo: self.containerView.leftAnchor),
            self.saveFavButton.topAnchor.constraint(equalTo: self.statusIcon.bottomAnchor, constant: 40),
            self.saveFavButton.rightAnchor.constraint(equalTo: self.retryButton.leftAnchor, constant: -30),
            self.saveFavButton.heightAnchor.constraint(equalToConstant: 76),
            self.recipeButton.leftAnchor.constraint(equalTo: self.retryButton.rightAnchor, constant: 30),
            self.recipeButton.topAnchor.constraint(equalTo: self.statusIcon.bottomAnchor, constant: 40),
            self.recipeButton.rightAnchor.constraint(equalTo: self.containerView.rightAnchor),
            self.recipeButton.heightAnchor.constraint(equalToConstant: 76),
            self.stackView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 0),
            self.stackView.topAnchor.constraint(equalTo: self.retryButton.bottomAnchor, constant: 40),
            self.stackView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: 0),
            self.stackView.bottomAnchor.constraint(lessThanOrEqualTo: self.containerView.bottomAnchor, constant: -10),
        ])
        self.bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismisIfCan)))
        self.recipeButton.addTarget(self, action: #selector(self.goToRecipe), for: .touchUpInside)
        self.saveFavButton.addTarget(self, action: #selector(self.goToSave), for: .touchUpInside)
        self.retryButton.addTarget(self, action: #selector(self.goToRepeat), for: .touchUpInside)
        self.rootView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        self.configure()
    }
    
    override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setStatusBarStyle(dark: false)
        self.navigationController?.navigationBar.isHidden = true
        self.setNeedsStatusBarAppearanceUpdate()
        self.animateView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            return .default
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    func animateView() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.rootView.transform = .identity
        }, completion: {(finished: Bool) -> Void in })
    }
    
    func animateDismis() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {() -> Void in
            self.rootView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        }, completion: {(finished: Bool) -> Void in
            self.coordinator?.navigateBack()
        })
    }
    
    @objc func dismisIfCan() {
        self.animateDismis()
    }
    
    @objc func goToRecipe() {
        self.coordinator?.navigateToRecipeView(item: self.item)
    }
    
    @objc func goToRepeat() {
        if let serviceId = Int(self.item.service), let service = self.viewModel.accountInfo.getService(serviceID: serviceId) {
            self.coordinator?.navigateToRepetPayment(service: service)
        }
    }
    
    @objc func goToSave() {
        let c = AddFavoriteViewController()
        c.delegate = self
        self.present(c, animated: true)
    }
    
    func addFavorite(name: String) {
        if let serviceId = Int(self.item.service) {
            self.showProgressView()
            self.viewModel.paymentsService.addFavorite(account: self.item.accountFrom, amount: self.item.amount, comment: "", params: [self.item.accountTo], name: name, serviceID: serviceId)
                .observe(on: MainScheduler.instance).subscribe { [weak self] _ in
                    guard let self = self else { return }
                    self.successProgress(text: "ADDED".localized)
                } onFailure: { [weak self] error in
                    guard let self = self else { return }
                    if let error = error as? NetworkError {
                        self.viewModel.didLoadError.onNext((error.message ?? error.error) ?? error.localizedDescription)
                    } else {
                        self.viewModel.didLoadError.onNext(error.localizedDescription)
                    }
                }.disposed(by: self.viewModel.disposeBag)
        }
    }
    
    func configure() {
        self.sumLabel.text = self.item.amount.balanceText
        if self.item.status == 0 {
            self.statusLabel.textColor = .systemGreen
            self.statusLabel.text = "PAYMENT_SUCCESS".localized
        } else {
            self.statusLabel.textColor = .systemRed
            self.statusLabel.text = "PAYMENT_FAILED".localized
        }
        if let serviceId = Int(self.item.service), let service = self.viewModel.accountInfo.getService(serviceID: serviceId) {
            let infoView = HistoryInfoItemView(frame: .zero)
            infoView.titleLabel.text = "HISTORY_TITLE".localized
            infoView.infoLabel.text = service.name
            self.stackView.addArrangedSubview(infoView)
        }
        let tranView = HistoryInfoItemView(frame: .zero)
        tranView.titleLabel.text = "HISTORY_TRANSACTIONS".localized
        tranView.infoLabel.text = self.item.tran_id
        self.stackView.addArrangedSubview(tranView)
        let toBillView = HistoryInfoItemView(frame: .zero)
        toBillView.titleLabel.text = "HISTORY_TO_BILL".localized
        toBillView.infoLabel.text = self.item.accountTo
        self.stackView.addArrangedSubview(toBillView)
        let dateView = HistoryInfoItemView(frame: .zero)
        dateView.titleLabel.text = "HISTORY_DATE".localized
        dateView.infoLabel.text = self.item.datetime
        self.stackView.addArrangedSubview(dateView)
        let sumView = HistoryInfoItemView(frame: .zero)
        sumView.titleLabel.text = "HISTORY_SUM".localized
        sumView.infoLabel.text = self.item.amount.balanceText
        self.stackView.addArrangedSubview(sumView)
        let feeView = HistoryInfoItemView(frame: .zero)
        feeView.titleLabel.text = "HISTORY_FEE".localized
        feeView.infoLabel.text = self.item.commission.balanceText
        self.stackView.addArrangedSubview(feeView)
        let totalView = HistoryInfoItemView(frame: .zero)
        totalView.titleLabel.text = "HISTORY_TOTAL".localized
        totalView.infoLabel.text = self.item.amount.balanceText
        self.stackView.addArrangedSubview(totalView)
        let fromBill = HistoryInfoItemView(frame: .zero)
        fromBill.titleLabel.text = "HISTORY_FROM_BILL".localized
        fromBill.infoLabel.text = self.item.accountFrom
        self.stackView.addArrangedSubview(fromBill)
    }
}
