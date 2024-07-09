//
//  IndentifyMainViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 30/10/23.
//

import Foundation
import UIKit
import RxSwift

class IndentifyMainViewController: BaseViewController {
    
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
    private let statusView: IndentifyStatusView = {
        let view = IndentifyStatusView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let nextButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont.medium(size: 17)
        view.radius = 14
        view.setTitle("GET_LIMIT".localized, for: .normal)
        return view
    }()
    private let buttonsStackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let viewModel: IdentifyViewModel
    let identify: AppMethods.Client.IdentifyGet.IdentifyResult?
    var help: AppMethods.App.GetHelp.GetHelpResult? = nil
    let limit: AppStructs.ClientInfo.Limit
    weak var coordinator: IdentifyCoordinator?
    
    init(viewModel: IdentifyViewModel, limit: AppStructs.ClientInfo.Limit, identify: AppMethods.Client.IdentifyGet.IdentifyResult?) {
        self.viewModel = viewModel
        self.identify = identify
        self.limit = limit
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "IDENTIFICATION".localized
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.rootView)
        self.rootView.addSubview(self.statusView)
        self.rootView.addSubview(self.nextButton)
        self.rootView.addSubview(self.buttonsStackView)
        let rootHeight = self.rootView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        rootHeight.priority = UILayoutPriority(rawValue: 250)
        NSLayoutConstraint.activate([
            self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.rootView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.rootView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.rootView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            self.rootView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            rootView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            rootHeight,
            self.statusView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
            self.statusView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 0),
            self.statusView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
            self.nextButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.nextButton.topAnchor.constraint(equalTo: self.statusView.bottomAnchor, constant: 20),
            self.nextButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.heightAnchor.constraint(equalToConstant: 56),
            self.buttonsStackView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 50),
            self.buttonsStackView.topAnchor.constraint(equalTo: self.nextButton.bottomAnchor, constant: 20),
            self.buttonsStackView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -50),
            self.buttonsStackView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -30),
            self.buttonsStackView.heightAnchor.constraint(equalToConstant: 54),
        ])
        self.nextButton.addTarget(self, action: #selector(self.navigateToVerify), for: .touchUpInside)
        self.setStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: nil)
    }
    
    override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.statusView.themeChanged(newTheme: newTheme)
        self.nextButton.startColor = newTheme.mainGradientStartColor
        self.nextButton.endColor = newTheme.mainGradientEndColor
        self.setStatus()
    }
    
    @objc func navigateToVerify() {
        switch self.viewModel.accountInfo.client.limit.identifyed {
        case .noIdentified:
            if self.viewModel.accountInfo.client.limit.id == self.limit.id {
                self.showProgressView()
                self.viewModel.service.getLimits().subscribe { [weak self] result in
                    guard let self = self else { return }
                    self.hideProgressView()
                    guard let limit = result.first(where: { $0.id == self.viewModel.accountInfo.client.limit.id + 1 }) else { return }
                    self.coordinator?.navigateToStatusView(identify: self.identify, limit: limit)
                } onFailure: { [weak self] error in
                    self?.hideProgressView()
                    self?.showApiError(title: "ERROR".localized, error: error)
                }.disposed(by: self.viewModel.disposeBag)
            } else {
                if let result = self.identify {
                    switch result.idStatus {
                    case .inReview:
                        self.showErrorAlert(title: "ERROR".localized, message: "IDEN_IN_REVIEW".localized)
                    case .rejected, .notidentified, .success:
                        self.coordinator?.navigateToVerify()
                    }
                } else {
                    self.coordinator?.navigateToVerify()
                }
            }
        case .onlineIdentified:
            if self.viewModel.accountInfo.client.limit.id == self.limit.id {
                self.showProgressView()
                self.viewModel.service.getLimits().subscribe { [weak self] result in
                    guard let self = self else { return }
                    self.hideProgressView()
                    guard let limit = result.first(where: { $0.id == self.viewModel.accountInfo.client.limit.id + 1 }) else { return }
                    self.coordinator?.navigateToStatusView(identify: self.identify, limit: limit)
                } onFailure: { [weak self] error in
                    self?.hideProgressView()
                    self?.showApiError(title: "ERROR".localized, error: error)
                }.disposed(by: self.viewModel.disposeBag)
            } else {
                guard let h = self.help?.callCenter, let number = URL(string: "tel://+" + h.digits) else { return }
                UIApplication.shared.open(number, options: [:], completionHandler: nil)
            }
        case .identified:
            guard let h = self.help?.callCenter, let number = URL(string: "tel://+" + h.digits) else { return }
            UIApplication.shared.open(number, options: [:], completionHandler: nil)
        }
    }
    
    func setStatus() {
        switch self.limit.identifyed {
        case .noIdentified:
            self.statusView.topTitle.text = "ID_NOT_IDENTIFY".localized
            self.statusView.topTitle.textColor = .systemRed
            self.nextButton.setTitle("GET_LIMIT".localized, for: .normal)
            self.statusView.topAvatar.image = UIImage(name: .status_one)
        case .onlineIdentified:
            self.statusView.topTitle.text = "IDENTIFY_ONLINE".localized
            self.statusView.topTitle.textColor = Theme.current.tintColor
            self.nextButton.setTitle("GET_LIMIT".localized, for: .normal)
            self.statusView.topAvatar.image = UIImage(name: .status_two)
        case .identified:
            self.statusView.topAvatar.image = UIImage(name: .status_three)
            self.statusView.topTitle.text = "IDENTIFIED".localized
            self.statusView.topTitle.textColor = Theme.current.tintColor
            self.nextButton.setTitle("MAKE_CALL".localized, for: .normal)
            self.loadHelp()
        }
        self.statusView.topAvatar.tintColor = Theme.current.tintColor
        self.statusView.topLimitDetail.text = "\(self.limit.maxInWallet) сомони"
        self.statusView.bottomLimitDetail.text = "\(self.limit.SummaOnMonth) сомони"
        self.statusView.servicePayItem.setStatus(active: self.limit.payment)
        self.statusView.qrItem.setStatus(active: self.limit.QRPayment)
        self.statusView.orderCardItem.setStatus(active: self.limit.cardOrder)
        self.statusView.transferItem.setStatus(active: self.limit.transfer)
        self.statusView.cashItem.setStatus(active: self.limit.cashing)
        self.statusView.convertItem.setStatus(active: self.limit.convert)
        self.statusView.creditItem.setStatus(active: self.limit.creditControl)
    }
    
    func loadHelp() {
        self.showProgressView()
        self.viewModel.service.getHelp()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] item in
                guard let self = self else { return }
                self.hideProgressView()
                self.help = item
                self.setHelp(help: item)
            } onFailure: { [weak self] error in
                guard let self = self else { return }
                self.hideProgressView()
                self.showApiError(title: "ERROR".localized, error: error)
            }.disposed(by: self.viewModel.disposeBag)
    }
    
    func setHelp(help: AppMethods.App.GetHelp.GetHelpResult) {
        for item in help.socials {
            let btn = self.getButton(type: item)
            self.buttonsStackView.addArrangedSubview(btn)
        }
    }
    
    func getButton(type: AppMethods.App.GetHelp.GetHelpResult.Socials) -> CircleImageView {
        let button = CircleImageView(frame: .zero)
        button.tag = type.id
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1).isActive = true
        button.isUserInteractionEnabled = true
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.socialTapped(_:))))
        button.loadImage(filePath: Theme.current.dark ? type.darkLogo : type.logo)
        return button
    }
    
    @objc func socialTapped(_ sender: UITapGestureRecognizer) {
        guard let soc = self.help?.socials, let item = soc.first(where: { $0.id == sender.view?.tag }), let url = URL(string: item.link) else { return }
        UIApplication.shared.open(url)
    }
}
