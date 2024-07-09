//
//  CardPaymentViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 11/12/23.
//

import Foundation
import UIKit
import RxSwift

protocol CardPaymentViewDelegate: AnyObject {
    func dismisedView()
}

class CardPaymentViewController: BaseViewController, CardPaymentViewDelegate {
    
    private lazy var paymentView: CardPaymentView = {
        let view = CardPaymentView(bottomInset:  self.view.safeAreaInsets.bottom)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var confirmView: CardPaymentConfirmView = {
        let view = CardPaymentConfirmView(bottomInset:  self.view.safeAreaInsets.bottom)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    private lazy var resultView: CardPaymentResultView = {
        let view = CardPaymentResultView(bottomInset: self.view.safeAreaInsets.bottom)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    weak var coordinator: CardsCoordinator? = nil
    let viewModel: CardsViewModel
    let cardItem: AppStructs.CreditDebitCardTypes
    let region: AppStructs.Region
    let receivingType: AppMethods.Card.OrderBankCard.Params.ReceivingType
    let holderMidname: String
    let holderName: String
    let holderSurname: String
    let phoneNumber: String
    let pointId: Int?
    
    init(viewModel: CardsViewModel, cardItem: AppStructs.CreditDebitCardTypes, holderMidname: String, holderName: String, holderSurname: String,
         phoneNumber: String, receivingType: AppMethods.Card.OrderBankCard.Params.ReceivingType, region: AppStructs.Region, pointId: Int?) {
        self.viewModel = viewModel
        self.cardItem = cardItem
        self.holderMidname = holderMidname
        self.holderName = holderName
        self.holderSurname = holderSurname
        self.phoneNumber = phoneNumber
        self.receivingType = receivingType
        self.region = region
        self.pointId = pointId
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
        self.edgesForExtendedLayout = .all
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.navigationItem.title = "ORDER_CARD".localized
        self.paymentView.nextButton.addTarget(self, action: #selector(self.payTapped(_:)), for: .touchUpInside)
        self.confirmView.nextButton.addTarget(self, action: #selector(self.confirmTapped(_:)), for: .touchUpInside)
        self.resultView.nextButton.addTarget(self, action: #selector(self.okTapped(_:)), for: .touchUpInside)
        self.paymentView.balanceView.configure(clientBalances: self.viewModel.accountInfo.clientBalances)
        let total: Double
        if self.receivingType == .ship {
            total = self.cardItem.price + Double(self.region.deliveryPrice)
            self.paymentView.hintView.fieldView.text = "CARD_PAY_INFO_SHIP".localizedFormat(arguments: self.cardItem.name)
            self.confirmView.stackView.addArrangedSubview(PaymentResultItemView(title: "HISTORY_TITLE".localized, info: "\("CARD_PAY_INFO".localizedFormat(arguments: self.cardItem.name)): \(self.cardItem.price.balanceText)"))
            self.confirmView.stackView.addArrangedSubview(PaymentResultItemView(title: "", info: "\("CARD_SHIP_INFO".localizedFormat(arguments: self.cardItem.name)): \(self.region.deliveryPrice.balanceText)"))
            self.confirmView.stackView.addArrangedSubview(PaymentResultItemView(title: "SHIP_DOSTAVKA".localized, info: self.region.name))
        } else {
            total = self.cardItem.price
            self.paymentView.hintView.fieldView.text = "CARD_PAY_INFO".localizedFormat(arguments: self.cardItem.name)
            self.confirmView.stackView.addArrangedSubview(PaymentResultItemView(title: "HISTORY_TITLE".localized, info: "\("CARD_PAY_INFO".localizedFormat(arguments: self.cardItem.name)): \(self.cardItem.price.balanceText)"))
            self.confirmView.stackView.addArrangedSubview(PaymentResultItemView(title: "SHIP_DOSTAVKA".localized, info: "SHIP_SAMOVIVOS".localized))
        }
        self.paymentView.sumView.fieldView.text = total == 0 ? "FREE".localized : total.balanceText
        self.confirmView.sumView.text = total == 0 ? "FREE".localized : total.balanceText
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: nil)
        if total == 0 {
            self.setVerfyResult()
        } else {
            self.view.addSubview(self.paymentView)
            NSLayoutConstraint.activate([
                self.paymentView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                self.paymentView.topAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.topAnchor),
                self.paymentView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                self.paymentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            ])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func payTapped(_ sender: UIButton) {
        self.setVerfyResult()
    }
    
    func dismisedView() {
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: nil)
    }
    
    private func setVerfyResult() {
        self.navigationController?.navigationBar.isHidden = true
        self.setStatusBarStyle(dark: false)
        self.view.addSubview(self.confirmView)
        self.confirmView.rootView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        NSLayoutConstraint.activate([
            self.confirmView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.confirmView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.confirmView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.confirmView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        self.confirmView.animateView()
    }
    
    @objc func confirmTapped(_ sender: UIButton) {
        guard let balance = self.paymentView.balanceView.selectedBalance else {
            return
        }
        let total: Double
        if self.receivingType == .ship {
            total = self.cardItem.price + Double(self.region.deliveryPrice)
        } else {
            total = self.cardItem.price
        }
        self.showProgressView()
        self.viewModel.cardService.orderBankCard(account: balance.account, accountType: balance.accountType, bankCardID: self.cardItem.id, holderMidname: self.holderMidname, holderName: self.holderName, holderSurname: self.holderSurname, phoneNumber: self.phoneNumber, receivingType: self.receivingType, regionID: self.region.id, pointID: self.pointId ?? 0)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self = self else { return }
                self.hideProgressView()
                self.confirmView.removeFromSuperview()
                self.view.addSubview(self.resultView)
                self.resultView.rootView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
                self.resultView.configure(deliveryTranID: result.DeliveryTranID, cardTranID: result.cardTranID, succeedTime: result.succeedTime, sum: total, id: result.id)
                NSLayoutConstraint.activate([
                    self.resultView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                    self.resultView.topAnchor.constraint(equalTo: self.view.topAnchor),
                    self.resultView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                    self.resultView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                ])
                self.resultView.animateView()
            } onFailure: { [weak self] error in
                guard let self = self else { return }
                self.hideProgressView()
                self.showApiError(title: "ERROR".localized, error: error)
            }.disposed(by: self.viewModel.disposeBag)
    }
    
    @objc func okTapped(_ sender: UIButton) {
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: nil)
        self.coordinator?.navigateToRoot()
    }
}

class CardPaymentView: UIView {
    
    let scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alwaysBounceVertical = true
        view.keyboardDismissMode = .interactive
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        return view
    }()
    let rootView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let balanceView: BalanceSelectView = {
        let view = BalanceSelectView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let sumView: PaymentFieldView = {
        let view = PaymentFieldView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.fieldView.keyboardType = .decimalPad
        view.topLabel.text = "SUM".localized
        view.fieldView.isEnabled = false
        return view
    }()
    let hintView: PaymentTextView = {
        let view = PaymentTextView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.fieldView.keyboardType = .default
        view.topLabel.text = "PAYEMNT_FOR_HINT".localized
        view.fieldView.isEditable = false
        view.fieldView.isSelectable = false
        return view
    }()
    let nextButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.radius = 14
        view.setTitle("CONTINUE".localized, for: .normal)
        view.isEnabled = true
        return view
    }()
    
    init(bottomInset: CGFloat) {
        super.init(frame: .zero)
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.rootView)
        self.rootView.addSubview(self.balanceView)
        self.rootView.addSubview(self.sumView)
        self.rootView.addSubview(self.hintView)
        self.rootView.addSubview(self.nextButton)
        let rootHeight = self.rootView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        rootHeight.priority = UILayoutPriority(rawValue: 250)
        NSLayoutConstraint.activate([
            self.scrollView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.rootView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.rootView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.rootView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            self.rootView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            rootView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            rootHeight,
            self.balanceView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
            self.balanceView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 10),
            self.balanceView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
            self.balanceView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.325, constant: 48),
            self.sumView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.sumView.topAnchor.constraint(equalTo: self.balanceView.bottomAnchor, constant: 20),
            self.sumView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.sumView.heightAnchor.constraint(equalToConstant: 74),
            self.hintView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.hintView.topAnchor.constraint(equalTo: self.sumView.bottomAnchor, constant: 10),
            self.hintView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.hintView.heightAnchor.constraint(equalToConstant: 86),
            self.nextButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.nextButton.topAnchor.constraint(greaterThanOrEqualTo: self.hintView.bottomAnchor, constant: 20),
            self.nextButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant:  0),
            self.nextButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CardPaymentConfirmView: UIView {
    
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
    let nextButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.radius = 14
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.setTitle("CONTINUE".localized, for: .normal)
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
    weak var delegate: CardPaymentViewDelegate?

    init(bottomInset: CGFloat) {
        super.init(frame: .zero)
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
            self.nextButton.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -(30 + bottomInset)),
            self.nextButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
        ])
        self.bgView.isUserInteractionEnabled = true
        self.bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.animateDismis)))
    }
    
    @objc func animateDismis() {
        self.delegate?.dismisedView()
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {() -> Void in
            self.rootView.transform = CGAffineTransform(translationX: 0, y: self.bounds.height)
        }, completion: {(finished: Bool) -> Void in
            self.removeFromSuperview()
        })
    }
    
    func animateView() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.rootView.transform = .identity
        }, completion: {(finished: Bool) -> Void in })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CardPaymentResultView: UIView {
    
    let bgView: GradientView = {
        let view = GradientView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startColor = Theme.current.mainGradientStartColor
        view.endColor = Theme.current.mainGradientEndColor
        view.alpha = 1
        view.isUserInteractionEnabled = true
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
    let sumView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 30)
        view.textColor = Theme.current.tintColor
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.4
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
    let nextButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.radius = 14
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.setTitle("OK".localized, for: .normal)
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
    let infoView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.regular(size: 20)
        view.text = "TRANSFER_CONFIRM".localized
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    init(bottomInset: CGFloat) {
        super.init(frame: .zero)
        self.addSubview(self.bgView)
        self.addSubview(self.imageView)
        self.addSubview(self.rootView)
        self.rootView.addSubview(self.topAnchorView)
        self.rootView.addSubview(self.scrollView)
        self.scrollView.addSubview(self.containerView)
        self.containerView.addSubview(self.titleView)
        self.containerView.addSubview(self.sumView)
        self.containerView.addSubview(self.recipeButton)
        self.containerView.addSubview(self.infoView)
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
            self.recipeButton.topAnchor.constraint(equalTo: self.sumView.bottomAnchor, constant: 20),
            self.recipeButton.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.recipeButton.heightAnchor.constraint(equalToConstant: 76),
            self.recipeButton.widthAnchor.constraint(equalToConstant: 64),
            self.infoView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: Theme.current.mainPaddings),
            self.infoView.topAnchor.constraint(equalTo: self.recipeButton.bottomAnchor, constant: 20),
            self.infoView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: Theme.current.mainPaddings),
            self.nextButton.topAnchor.constraint(greaterThanOrEqualTo: self.infoView.bottomAnchor, constant: 20),
            self.nextButton.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -(30 + bottomInset)),
            self.nextButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateView() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.rootView.transform = .identity
        }, completion: {(finished: Bool) -> Void in })
    }
    
    func configure(deliveryTranID: String?, cardTranID: String?, succeedTime: String, sum: Double, id: Int) {
        if sum > 0 {
            self.titleView.text = "\("PAYMENT_IN_PROGRESS".localized)\n\(succeedTime)"
            self.sumView.text = sum.balanceText
            self.infoView.text = "\("ORDER_RECEIVED".localized)\n№\(id)\n\(succeedTime)"
        } else {
            self.titleView.text = "\("ORDER_RECEIVED".localized)\n№\(id)\n\(succeedTime)"
            self.sumView.text = nil
            self.sumView.isHidden = true
            self.infoView.text = nil
        }
    }
}
