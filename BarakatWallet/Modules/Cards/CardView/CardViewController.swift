//
//  CardViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 18/11/23.
//

import Foundation
import UIKit
import RxSwift
import Toast

class CardViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CardItemCellDelegate {
  
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
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.keyboardDismissMode = .interactive
        view.register(CardItemCell.self, forCellWithReuseIdentifier: "card_item_cell")
        view.backgroundColor = .clear
        view.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        view.isPagingEnabled = true
        view.allowsSelection = false
        return view
    }()
    let controlView: AdvancedPageControlView = {
        let view = AdvancedPageControlView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let buttonsStackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.layer.borderColor = Theme.current.borderColor.withAlphaComponent(0.8).cgColor
        view.layer.borderWidth = 1
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = .init(top: 14, leading: 16, bottom: 14, trailing: 16)
        view.layoutMargins = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
        return view
    }()
    private let actionsStackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .vertical
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.layer.borderColor = Theme.current.borderColor.withAlphaComponent(0.8).cgColor
        view.layer.borderWidth = 1
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
        view.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return view
    }()
    
    let viewModel: CardsViewModel
    var selectedCard: AppStructs.CreditDebitCard
    var selectedColor: (start: UIColor, end: UIColor)? = nil
    weak var coordinator: CardsCoordinator? = nil
    
    init(viewModel: CardsViewModel, selectedCard: AppStructs.CreditDebitCard) {
        self.viewModel = viewModel
        self.selectedCard = selectedCard
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(name: .hide_eyes), style: .plain, target: self, action: #selector(self.showHideCardTapped))
        self.navigationItem.title = "MY_CARDS".localized
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.rootView)
        self.rootView.addSubview(self.collectionView)
        self.rootView.addSubview(self.controlView)
        self.rootView.addSubview(self.buttonsStackView)
        self.rootView.addSubview(self.actionsStackView)
        let rootHeight = self.rootView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        rootHeight.priority = UILayoutPriority(rawValue: 250)
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
            self.collectionView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
            self.collectionView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 0),
            self.collectionView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
            self.collectionView.heightAnchor.constraint(equalTo: self.collectionView.widthAnchor, multiplier: 0.561797753, constant: 10),
            self.controlView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.controlView.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: 8),
            self.controlView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.controlView.heightAnchor.constraint(equalToConstant: 12),
            self.buttonsStackView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.buttonsStackView.topAnchor.constraint(equalTo: self.controlView.bottomAnchor, constant: 20),
            self.buttonsStackView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.buttonsStackView.heightAnchor.constraint(equalToConstant: 92),
            self.actionsStackView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.actionsStackView.topAnchor.constraint(equalTo: self.buttonsStackView.bottomAnchor, constant: 20),
            self.actionsStackView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.actionsStackView.bottomAnchor.constraint(lessThanOrEqualTo: self.rootView.bottomAnchor, constant: -20),
        ])
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.contentInsetAdjustmentBehavior = .never
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.controlView.drawer = ExtendedDotDrawer(numberOfPages: 1, space: 8, indicatorColor: Theme.current.tintColor, dotsColor: Theme.current.secondTintColor, isBordered: false, borderWidth: 0.0, indicatorBorderColor: .clear, indicatorBorderWidth: 0.0)
        self.configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: nil)
    }
    
    @objc func showHideCardTapped() {
        self.viewModel.showCardInfo = !self.viewModel.showCardInfo
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "card_item_cell", for: indexPath) as! CardItemCell
        cell.delegate = self
        let card = self.viewModel.userCards[indexPath.item]
        cell.configure(card: card, show: self.viewModel.showCardInfo, showCopy: true, selectedColor: self.selectedColor)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.viewModel.userCards.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width - (scrollView.contentInset.left + scrollView.contentInset.right)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = index.rounded(.up)
        if self.controlView.numberOfPages > Int(roundedIndex) {
            self.controlView.setPage(Int(roundedIndex))
        } else {
            self.controlView.setPage(self.controlView.numberOfPages - 1)
        }
    }
    
    func configure() {
        self.controlView.numberOfPages = self.viewModel.userCards.count
        
        if let index = self.viewModel.userCards.firstIndex(where: { $0.id == self.selectedCard.id }) {
            self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
        }
        
        self.buttonsStackView.addArrangedSubview(self.getActions(action: .pay))
        self.buttonsStackView.addArrangedSubview(self.getActions(action: .topup))
        self.buttonsStackView.addArrangedSubview(self.getActions(action: .transfer))
        self.buttonsStackView.addArrangedSubview(self.getActions(action: .history))
        
        self.actionsStackView.addArrangedSubview(self.getOption(option: .title))
        self.actionsStackView.addArrangedSubview(self.getOption(option: .payPin))
        self.actionsStackView.addArrangedSubview(self.getOption(option: .payInternet))
        self.actionsStackView.addArrangedSubview(self.getOption(option: .block))
        self.actionsStackView.addArrangedSubview(self.getOption(option: .changePin))
        self.actionsStackView.addArrangedSubview(self.getOption(option: .remove))
        self.actionsStackView.addArrangedSubview(self.getOption(option: .changeColor))
    }
    
    func copyInfo(cell: CardItemCell, number: Bool, date: Bool, cvv: Bool) {
        guard let cell = self.collectionView.indexPath(for: cell) else { return }
        if cell.item < self.viewModel.userCards.count {
            let card = self.viewModel.userCards[cell.item]
            if number {
                UIPasteboard.general.string = card.pan
            } else if date {
                UIPasteboard.general.string = "\(card.validMonth)/\(card.validYear)"
            } else if cvv {
                UIPasteboard.general.string = card.cvv
            }
            let toast = Toast.default(
                image: UIImage(name: .copy_value),
                title: "CARD_INFO_COPY".localized
            )
            toast.show(haptic: .success)
        }
    }
    
    enum CardAction: Int {
        case pay = 0, topup = 1, transfer = 2, history = 3
    }
    
    func getActions(action: CardAction) -> CardActionButton {
        let view = CardActionButton(frame: .zero)
        view.tag = action.rawValue
        view.translatesAutoresizingMaskIntoConstraints = false
        switch action {
        case .pay:
            view.nameView.text = "CARD_ACTION_PAY".localized
            view.iconView.imageView.image = UIImage(name: .card_action_pay)
        case .topup:
            view.nameView.text = "CARD_ACTION_TOPUP".localized
            view.iconView.imageView.image = UIImage(name: .card_action_topup)
        case .transfer:
            view.nameView.text = "CARD_ACTION_TRANSFER".localized
            view.iconView.imageView.image = UIImage(name: .card_action_transfer)
        case .history:
            view.nameView.text = "CARD_ACTION_HISTORY".localized
            view.iconView.imageView.image = UIImage(name: .card_action_history)
        }
        view.addTarget(self, action: #selector(self.actionTapped(_:)), for: .touchUpInside)
        return view
    }
    
    @objc func actionTapped(_ sender: CardActionButton) {
        guard let action = CardAction(rawValue: sender.tag) else { return }
        switch action {
        case .pay:
            self.coordinator?.presentTransferPaymentChoose(paymentCard: self.selectedCard, showTransfers: false)
        case .topup:
            self.coordinator?.navigateToTransferAccounts(topupCreditCard: self.selectedCard)
        case .transfer:
            self.coordinator?.presentTransferPaymentChoose(paymentCard: self.selectedCard, showTransfers: true)
        case .history:
            self.coordinator?.navigateToHistoryView(forCreditCard: self.selectedCard)
        }
    }
    
    enum CardOption: Int {
        case title = 0, changePin = 1, payPin = 2, payInternet = 3, block = 4, changeColor = 5, remove = 6
    }
    
    func getOption(option: CardOption) -> UIView {
        switch option {
        case .title:
            let view = UILabel(frame: .zero)
            view.tag = option.rawValue
            view.textColor = Theme.current.primaryTextColor
            view.font = UIFont.regular(size: 16)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.text = "CARD_SETTINGS".localized
            return view
        case .changePin:
            let view = DisclosureOptionView(frame: .zero)
            view.titleView.text = "CARD_CHANGE_PIN".localized
            view.tag = option.rawValue
            view.translatesAutoresizingMaskIntoConstraints = false
            view.addTarget(self, action: #selector(self.optionTapped(_:)), for: .touchUpInside)
            return view
        case .remove:
            let view = DisclosureOptionView(frame: .zero)
            view.titleView.text = "REMOVE_CARD".localized
            view.tag = option.rawValue
            view.translatesAutoresizingMaskIntoConstraints = false
            view.addTarget(self, action: #selector(self.optionTapped(_:)), for: .touchUpInside)
            return view
        case .payPin:
            let view = SwitchOptionView(frame: .zero)
            view.titleView.text = "CARD_PAY_PIN".localized
            view.tag = option.rawValue
            view.translatesAutoresizingMaskIntoConstraints = false
            view.addTarget(self, action: #selector(self.optionTapped(_:)), for: .valueChanged)
            view.switchView.isOn = self.selectedCard.PINOnPay
            return view
        case .payInternet:
            let view = SwitchOptionView(frame: .zero)
            view.titleView.text = "CARD_PAY_INTERNET".localized
            view.tag = option.rawValue
            view.translatesAutoresizingMaskIntoConstraints = false
            view.addTarget(self, action: #selector(self.optionTapped(_:)), for: .valueChanged)
            view.switchView.isOn = self.selectedCard.internetPay
            return view
        case .block:
            let view = SwitchOptionView(frame: .zero)
            view.titleView.text = "CARD_BLOCK".localized
            view.tag = option.rawValue
            view.translatesAutoresizingMaskIntoConstraints = false
            view.addTarget(self, action: #selector(self.optionTapped(_:)), for: .valueChanged)
            view.switchView.isOn = self.selectedCard.block
            return view
        case .changeColor:
            let view = ColorOptionView(frame: .zero)
            view.titleView.text = "CARD_CHANGE_COLOR".localized
            view.tag = option.rawValue
            view.translatesAutoresizingMaskIntoConstraints = false
            view.addTarget(self, action: #selector(self.optionTapped(_:)), for: .valueChanged)
            view.setCurrentColor(color: self.selectedCard.colorID - 1)
            return view
        }
    }
    
    @objc func optionTapped(_ sender: UIView) {
        guard let action = CardOption(rawValue: sender.tag) else { return }
        switch action {
        case .title:break
        case .remove:
            let vc = ConfirmViewController(title: "REMOVE_CARD".localized, subTitle: "REMOVE_CARD_INFO".localized, image: nil) { result in
                if result {
                    self.removeCard()
                }
            }
            self.present(vc, animated: true)
        case .changePin:
            self.coordinator?.navigateToPinChange(card: self.selectedCard)
        case .payPin:
            guard let switchView = sender as? SwitchOptionView else { return }
            self.makeOp(PINOnPay: switchView.switchView.isOn, block: nil, colorID: nil, internetPay: nil, newPin: nil, changeView: switchView.switchView)
        case .payInternet:
            guard let switchView = sender as? SwitchOptionView else { return }
            self.makeOp(PINOnPay: nil, block: nil, colorID: nil, internetPay: switchView.switchView.isOn, newPin: nil, changeView: switchView.switchView)
        case .block:
            guard let switchView = sender as? SwitchOptionView else { return }
            self.makeOp(PINOnPay: nil, block: switchView.switchView.isOn, colorID: nil, internetPay: nil, newPin: nil, changeView: switchView.switchView)
        case .changeColor:
            guard let view = sender as? ColorOptionView else { return }
            let color = Constants.cardColors[view.selectedColor]
            self.selectedColor = color
            self.collectionView.reloadData()
            self.makeOp(PINOnPay: nil, block: nil, colorID: view.selectedColor + 1, internetPay: nil, newPin: nil, changeView: nil)
        }
    }
    
    private func makeOp(PINOnPay: Bool?, block: Bool?, colorID: Int?, internetPay: Bool?, newPin: String?, changeView: UISwitch?) {
        self.showProgressView()
        self.viewModel.cardService.updateUserCard(PINOnPay: PINOnPay, block: block, colorID: colorID, id: self.selectedCard.id, internetPay: internetPay, newPin: newPin)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.successProgress(text: "OPERATION_SUCCESS".localized)
            } onFailure: { [weak self] error in
                guard let self = self else { return }
                self.hideProgressView()
                if let v = changeView {
                    v.isOn = !v.isOn
                }
            }.disposed(by: self.viewModel.disposeBag)
    }
    
    private func removeCard() {
        self.showProgressView()
        self.viewModel.cardService.removeUserCard(id: self.selectedCard.id)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.successProgress(text: "DELETE_SUCCESS".localized)
                self.coordinator?.navigateBack()
            } onFailure: { [weak self] error in
                guard let self = self else { return }
                self.hideProgressView()
            }.disposed(by: self.viewModel.disposeBag)
    }
}
