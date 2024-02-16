//
//  IndentifyMainViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 30/10/23.
//

import Foundation
import UIKit

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
    let limit: AppStructs.ClientInfo.Limit
    weak var coordinator: IdentifyCoordinator?
    
    init(viewModel: IdentifyViewModel, limit: AppStructs.ClientInfo.Limit, identify: AppMethods.Client.IdentifyGet.IdentifyResult?) {
        self.viewModel = viewModel
        self.identify = identify
        self.limit = limit
        super.init(nibName: nil, bundle: nil)
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
    
    enum SocialNets: Int { case facebook = 1, instagram = 2, telegram = 3, linkedin = 4 }
    
    func getButton(type: SocialNets) -> BaseButtonView {
        let button = BaseButtonView(frame: .zero)
        button.circle = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Theme.current.whiteColor
        button.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 1).isActive = true
        button.addTarget(self, action: #selector(self.socialTapped(_:)), for: .touchUpInside)
        switch type {
        case .facebook:
            button.setImage(UIImage(name: .facebook_icon), for: .normal)
        case .instagram:
            button.setImage(UIImage(name: .instagram_icon), for: .normal)
        case .telegram:
            button.setImage(UIImage(name: .telegram_icon), for: .normal)
        case .linkedin:
            button.setImage(UIImage(name: .linkedin_icon), for: .normal)
        }
        return button
    }
    
    @objc func socialTapped(_ sender: BaseButtonView) {
        guard let type = SocialNets(rawValue: sender.tag) else { return }
        switch type {
        case .facebook:
            UIApplication.shared.open(URL(string: Constants.FacebookUrl)!)
        case .instagram:
            UIApplication.shared.open(URL(string: Constants.InstagramUrl)!)
        case .telegram:
            UIApplication.shared.open(URL(string: Constants.TelegramUrl)!)
        case .linkedin:
            UIApplication.shared.open(URL(string: Constants.LinkedinUrl)!)
        }
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
        case .noIdentified, .onlineIdentified:
            if self.viewModel.accountInfo.client.limit.id == self.limit.id {
                self.showProgressView()
                self.viewModel.service.getLimits().subscribe { [weak self] result in
                    guard let self = self else { return }
                    self.hideProgressView()
                    guard let limit = result.first(where: { $0.id == self.viewModel.accountInfo.client.limit.id + 1 }) else { return }
                    self.coordinator?.navigateToStatusView(identify: self.identify, limit: limit)
                } onFailure: { [weak self] _ in
                    self?.hideProgressView()
                    self?.showServerErrorAlert()
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
        case .identified:
            guard let number = URL(string: "tel://" + Constants.SupportNumber) else { return }
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
            self.buttonsStackView.addArrangedSubview(self.getButton(type: .facebook))
            self.buttonsStackView.addArrangedSubview(self.getButton(type: .facebook))
            self.buttonsStackView.addArrangedSubview(self.getButton(type: .instagram))
            self.buttonsStackView.addArrangedSubview(self.getButton(type: .telegram))
            self.buttonsStackView.addArrangedSubview(self.getButton(type: .linkedin))
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
}
