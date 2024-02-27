//
//  TransferMainViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 22/10/23.
//

import Foundation
import UIKit
import RxSwift

class TransferMainViewController: BaseViewController {
    
    let topBar: TransferTopView = {
        let view = TransferTopView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let topHelp: BannerView = {
        return BannerView(frame: .zero)
    }()
    let transferDirrectionLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 16)
        view.textColor = Theme.current.primaryTextColor
        view.textAlignment = .center
        view.text = "Россия --------> Таджикистан"
        return view
    }()
    let transferNumberView: TransferTypeView = {
        let view = TransferTypeView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.nameView.text = "TRANSFER_BY_NUMBER".localized
        view.iconView.image = UIImage(name: .transfer_number)
        return view
    }()
    let transferCardView: TransferTypeView = {
        let view = TransferTypeView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.nameView.text = "TRANSFER_BY_CARD".localized
        view.iconView.image = UIImage(name: .transfer_card)
        return view
    }()
    let bottomView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.current.dark ? .black : .white
        return view
    }()
    let bottomAuthLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 16)
        view.textColor = Theme.current.primaryTextColor
        view.text = "AUTH_TITLE".localized
        view.numberOfLines = 0
        view.textAlignment = .center
        view.isHidden = true
        return view
    }()
    let bottomAuthHintLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 14)
        view.textColor = Theme.current.secondaryTextColor
        view.text = "AUTH_TITLE_HELP".localized
        view.numberOfLines = 0
        view.textAlignment = .center
        view.isHidden = true
        return view
    }()
    let loginButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.radius = 14
        view.setTitle("LOGIN_SIGNIN".localized, for: .normal)
        view.isHidden = true
        return view
    }()
    weak var coordinator: TransferCoordinator?
    
    let viewModel: TransferViewModel
    let disposeBag = DisposeBag()
    
    init(viewModel: TransferViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.topBar)
        self.view.addSubview(self.topHelp)
        self.view.addSubview(self.transferDirrectionLabel)
        self.view.addSubview(self.transferNumberView)
        self.view.addSubview(self.transferCardView)
        self.view.addSubview(self.bottomView)
        self.bottomView.addSubview(self.bottomAuthLabel)
        self.bottomView.addSubview(self.bottomAuthHintLabel)
        self.bottomView.addSubview(self.loginButton)
        NSLayoutConstraint.activate([
            self.topBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.topBar.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.topBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.topBar.heightAnchor.constraint(equalToConstant: 160),
            self.topHelp.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            self.topHelp.topAnchor.constraint(equalTo: self.topBar.centerYAnchor, constant: 30),
            self.topHelp.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            self.topHelp.heightAnchor.constraint(equalToConstant: 108 + 22),
            self.transferDirrectionLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24),
            self.transferDirrectionLabel.topAnchor.constraint(equalTo: self.topHelp.bottomAnchor, constant: 20),
            self.transferDirrectionLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24),
            self.transferNumberView.topAnchor.constraint(equalTo: self.transferDirrectionLabel.bottomAnchor, constant: 20),
            self.transferNumberView.rightAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -30),
            self.transferNumberView.widthAnchor.constraint(equalToConstant: 110),
            self.transferCardView.topAnchor.constraint(equalTo: self.transferDirrectionLabel.bottomAnchor, constant: 20),
            self.transferCardView.leftAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 30),
            self.transferCardView.widthAnchor.constraint(equalToConstant: 110),
            self.bottomView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            self.bottomView.topAnchor.constraint(greaterThanOrEqualTo: self.transferCardView.bottomAnchor),
            self.bottomView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            self.bottomView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            self.bottomAuthLabel.leftAnchor.constraint(equalTo: self.bottomView.leftAnchor, constant: 24),
            self.bottomAuthLabel.topAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 24),
            self.bottomAuthLabel.rightAnchor.constraint(equalTo: self.bottomView.rightAnchor, constant: -24),
            self.bottomAuthHintLabel.leftAnchor.constraint(equalTo: self.bottomView.leftAnchor, constant: 24),
            self.bottomAuthHintLabel.topAnchor.constraint(equalTo: self.bottomAuthLabel.bottomAnchor, constant: 24),
            self.bottomAuthHintLabel.rightAnchor.constraint(equalTo: self.bottomView.rightAnchor, constant: -24),
            self.loginButton.leftAnchor.constraint(equalTo: self.bottomView.leftAnchor, constant: 24),
            self.loginButton.topAnchor.constraint(equalTo: self.bottomAuthHintLabel.bottomAnchor, constant: 24),
            self.loginButton.rightAnchor.constraint(equalTo: self.bottomView.rightAnchor, constant: -24),
            self.loginButton.bottomAnchor.constraint(equalTo: self.bottomView.bottomAnchor, constant: -40),
            self.loginButton.heightAnchor.constraint(equalToConstant: 56),
        ])
        self.topBar.backButton.tintColor = .white
        self.topBar.backButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        self.topBar.titleLabel.text = "MONEY_TRANSERS".localized
        self.topBar.subTitleLabel.text = ""
        self.loginButton.addTarget(self, action: #selector(self.goLogin), for: .touchUpInside)
        self.transferNumberView.addTarget(self, action: #selector(self.byNumber), for: .touchUpInside)
        self.transferCardView.addTarget(self, action: #selector(self.byCard), for: .touchUpInside)
        self.viewModel.bannerService.loadBannerList().observe(on: MainScheduler.instance).subscribe(onSuccess: { [weak self] banners in
            self?.topHelp.configure(banners: banners)
        }).disposed(by: self.disposeBag)
    }
    
    @objc func goBack() {
        self.coordinator?.navigateBack()
    }
    
    @objc func goLogin() {
        self.coordinator?.navigateToLogin()
    }
    
    @objc func byNumber() {
        self.coordinator?.navigateToPickReceiver(type: .byNumber, delegate: nil)
    }
    
    @objc func byCard() {
        self.coordinator?.navigateToPickReceiver(type: .byCard, delegate: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setStatusBarStyle(dark: false)
    }
    
    override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
        self.topBar.themeChanged(newTheme: newTheme)
        self.topHelp.themeChanged(newTheme: newTheme)
        self.transferDirrectionLabel.textColor = Theme.current.primaryTextColor
        self.transferCardView.themeChanged(newTheme: newTheme)
        self.transferNumberView.themeChanged(newTheme: newTheme)
        self.bottomView.backgroundColor = Theme.current.dark ? .black : .white
        self.bottomAuthLabel.textColor = Theme.current.primaryTextColor
        self.bottomAuthHintLabel.textColor = Theme.current.primaryTextColor
    }
}
