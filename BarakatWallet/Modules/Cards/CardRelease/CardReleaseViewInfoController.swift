//
//  CardReleaseViewInfoController.swift
//  BarakatWallet
//
//  Created by km1tj on 19/11/23.
//

import Foundation
import UIKit

class CardReleaseViewInfoController: BaseViewController {
    
    private let topBar: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.current.plainTableCellColor
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        return view
    }()
    let backButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(name: .back_arrow), for: .normal)
        view.tintColor = Theme.current.primaryTextColor
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
    private let rootView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let cardView: CardView = {
        let view = CardView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setColors()
        return view
    }()
    private let infoLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 17)
        view.textAlignment = .center
        view.textColor = Theme.current.primaryTextColor
        view.text = "Дебетовая карта Корти милли"
        return view
    }()
    private let nameLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 32)
        view.textAlignment = .center
        view.textColor = Theme.current.primaryTextColor
        view.text = "Barakat"
        return view
    }()
    private let stackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .vertical
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = .init(top: 10, leading: Theme.current.mainPaddings, bottom: 10, trailing: Theme.current.mainPaddings)
        view.layoutMargins = UIEdgeInsets(top: 10, left: Theme.current.mainPaddings, bottom: 10, right: Theme.current.mainPaddings)
        return view
    }()
    private let nextButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.radius = 14
        view.setTitle("ORDER".localized, for: .normal)
        view.isEnabled = true
        return view
    }()
    
    weak var coordinator: CardsCoordinator? = nil
    let viewModel: CardsViewModel
    let cardItem: AppStructs.CreditDebitCardItem
    
    init(viewModel: CardsViewModel, cardItem: AppStructs.CreditDebitCardItem) {
        self.viewModel = viewModel
        self.cardItem = cardItem
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.topBar)
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.cardView)
        self.topBar.addSubview(self.backButton)
        self.scrollView.addSubview(self.rootView)
        self.rootView.addSubview(self.infoLabel)
        self.rootView.addSubview(self.nameLabel)
        self.rootView.addSubview(self.stackView)
        self.rootView.addSubview(self.nextButton)
        let rootHeight = self.rootView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        rootHeight.priority = UILayoutPriority(rawValue: 250)
        NSLayoutConstraint.activate([
            self.topBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.topBar.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.topBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.topBar.heightAnchor.constraint(equalToConstant: UIApplication.statusBarHeight + 200),
            self.backButton.leftAnchor.constraint(equalTo: self.topBar.leftAnchor, constant: 20),
            self.backButton.topAnchor.constraint(equalTo: self.topBar.topAnchor, constant: UIApplication.statusBarHeight),
            self.backButton.heightAnchor.constraint(equalToConstant: 28),
            self.backButton.widthAnchor.constraint(equalToConstant: 28),
            self.cardView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.cardView.topAnchor.constraint(equalTo: self.topBar.centerYAnchor, constant: -30),
            self.cardView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            self.cardView.heightAnchor.constraint(equalTo: self.cardView.widthAnchor, multiplier: 0.561797753, constant: 10),
            self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.cardView.bottomAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            self.rootView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.rootView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.rootView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            self.rootView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.rootView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            rootHeight,
            self.infoLabel.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.infoLabel.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 20),
            self.infoLabel.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nameLabel.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.nameLabel.topAnchor.constraint(equalTo: self.infoLabel.bottomAnchor, constant: 0),
            self.nameLabel.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.stackView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.stackView.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 20),
            self.stackView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.nextButton.topAnchor.constraint(greaterThanOrEqualTo: self.stackView.bottomAnchor, constant: 20),
            self.nextButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -20),
            self.nextButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
        ])
        self.backButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        self.stackView.addArrangedSubview(CardFeatureView(text: "Получение переводов из РФ"))
        self.stackView.addArrangedSubview(CardFeatureView(text: "Обналичивание 0% во всех банкоматах РТ"))
        self.stackView.addArrangedSubview(CardFeatureView(text: "Бесплатное обслуживание в течении всего срока"))
    }
    
    @objc func goBack() {
        self.coordinator?.navigateBack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.setStatusBarStyle(dark: nil)
    }
}
