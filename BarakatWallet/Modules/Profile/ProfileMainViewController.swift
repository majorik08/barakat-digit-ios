//
//  ProfileMainViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 30/10/23.
//

import Foundation
import UIKit
import MobileCoreServices
import RxSwift

class ProfileMainViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, ProfileQrCellDelegate {
  
    let topBar: ProfileTopBar = {
        let view = ProfileTopBar(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let topAlertBar: ProfileAlertView = {
        let view = ProfileAlertView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInset = .init(top: 10, left: 0, bottom: 0, right: 0)
        view.backgroundColor = .clear
        view.register(ProfileTabelCell.self, forCellReuseIdentifier: "cell")
        view.register(ProfileQrCell.self, forCellReuseIdentifier: "qr_cell")
        view.separatorStyle = .none
        return view
    }()
    let viewModel: ProfileViewModel
    weak var coordinator: ProfileCoordinator?
    
    let imagePickerController = UIImagePickerController()
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.topAlertBar)
        self.view.addSubview(self.topBar)
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.topBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.topBar.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.topBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.topAlertBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.topAlertBar.topAnchor.constraint(equalTo: self.topBar.bottomAnchor, constant: -30),
            self.topAlertBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.topAlertBar.bottomAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        self.topBar.backButton.tintColor = .white
        self.topBar.backButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        self.topBar.statusView.addTarget(self, action: #selector(self.goIdentify), for: .touchUpInside)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.viewModel.didProfileUpdate.subscribe(onNext: { [weak self] _ in
            self?.setInfo()
        }).disposed(by: self.viewModel.disposeBag)
        self.viewModel.didIdentifyUpdate.subscribe(onNext: { [weak self] result in
            self?.setStatus(result: result)
        }).disposed(by: self.viewModel.disposeBag)
        self.setInfo()
    }
    
    func setStatus(result: AppMethods.Client.IdentifyGet.IdentifyResult) {
        switch result.idStatus {
        case .notidentified:
            self.topAlertBar.isHidden = true
            self.topAlertBar.infoLabel.text = ""
        case .success:
            self.topAlertBar.isHidden = true
            self.topAlertBar.infoLabel.text = ""
        case .rejected:
            self.topAlertBar.isHidden = false
            if let cause = result.cause {
                self.topAlertBar.infoLabel.text = "IDEN_IN_DECLINED".localizedFormat(arguments: cause)
            } else {
                self.topAlertBar.infoLabel.text = "IDEN_IN_DECLINED_WITHOUTT".localized
            }
        case .inReview:
            self.topAlertBar.isHidden = false
            self.topAlertBar.infoLabel.text = "IDEN_IN_REVIEW".localized
        }
    }
    
    func setInfo() {
        self.topBar.subTitleLabel.text = self.viewModel.accountInfo.client.wallet.formatedPrefix()
        self.topBar.statusView.configure(limits: self.viewModel.accountInfo.client.limit)
        APIManager.instance.loadImage(into: self.topBar.avatarView, filePath: self.viewModel.accountInfo.client.avatar)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            self.coordinator?.navigateToEditProfile()
        } else if indexPath.row == 1 {
            self.coordinator?.navigateToSettings()
        } else if indexPath.row == 2 {
            self.goToSupport()
        } else if indexPath.row == 3 {
            self.coordinator?.navigateToDocs()
        } else if indexPath.row == 4 {
            let activity: UIActivityViewController
            activity = UIActivityViewController(activityItems: ["INVITE".localizedFormat(arguments: Constants.AppName, Constants.AppUrl)], applicationActivities: nil)
            activity.popoverPresentationController?.sourceView = self.tableView.cellForRow(at: indexPath)
            self.present(activity, animated: true, completion: nil)
        }
    }
    
    override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
        self.topBar.themeChanged(newTheme: newTheme)
        self.topBar.statusView.roundCorners(corners: [.bottomLeft, .topRight], radius: 12, thickness: 1.5, color: Theme.current.secondTintColor)
        self.tableView.reloadData()
    }
    
    override func languageChanged() {
        super.languageChanged()
        self.tableView.reloadData()
        self.topBar.languageChanged()
        self.topBar.statusView.configure(limits: self.viewModel.accountInfo.client.limit)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.topBar.statusView.roundCorners(corners: [.bottomLeft, .topRight], radius: 12, thickness: 1.5, color: Theme.current.secondTintColor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.setStatusBarStyle(dark: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.loadIdentifyStatus()
    }
    
    @objc func goIdentify() {
        switch self.viewModel.accountInfo.client.limit.identifyed {
        case .noIdentified:
            self.showProgressView()
            self.viewModel.identifyService.getIdentify().subscribe { [weak self] result in
                self?.hideProgressView()
                self?.coordinator?.navigateToIdentify(identify: result)
            } onFailure: { [weak self] _ in
                self?.hideProgressView()
            }.disposed(by: self.viewModel.disposeBag)
        case .identified, .onlineIdentified:
            self.coordinator?.navigateToIdentify(identify: nil)
        }
    }
    
    @objc func goToSupport() {
        self.coordinator?.navigateToHelp()
    }
    
    @objc func goBack() {
        self.coordinator?.navigateBack()
    }
    
    func didTapDownload() {
        guard let image = UIImage.generateAppQRCode(from: self.viewModel.accountInfo.client.wallet) else { return }
        let activity: UIActivityViewController
        activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activity.popoverPresentationController?.sourceView = self.tableView.cellForRow(at: .init(row: 6, section: 0))
        self.present(activity, animated: true, completion: nil)
    }
    
    func didTapShare() {
        guard let image = UIImage.generateAppQRCode(from: self.viewModel.accountInfo.client.wallet) else { return }
        let activity: UIActivityViewController
        activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activity.popoverPresentationController?.sourceView = self.tableView.cellForRow(at: .init(row: 6, section: 0))
        self.present(activity, animated: true, completion: nil)
    }
    
    func didTapMyQr() {
        self.coordinator?.navigateToMyQr()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "qr_cell", for: indexPath) as! ProfileQrCell
            cell.configure(clientInfo: self.viewModel.accountInfo.client)
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileTabelCell
            cell.configure()
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "PROFILE_TITLE".localized
                cell.iconView.imageView.image = UIImage(name: .profile_icon)
            case 1:
                cell.titleLabel.text = "PROFILE_SETTINGS".localized
                cell.iconView.imageView.image = UIImage(name: .profile_settings)
            case 2:
                cell.titleLabel.text = "PROFILE_HELP".localized
                cell.iconView.imageView.image = UIImage(name: .profile_chat)
            case 3:
                cell.titleLabel.text = "PROFILE_PRIVACY".localized
                cell.iconView.imageView.image = UIImage(name: .profile_save)
            case 4:
                cell.titleLabel.text = "PROFILE_SHARE".localized
                cell.iconView.imageView.image = UIImage(name: .profile_share)
            default:break
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 5 {
            return UITableView.automaticDimension
        }
        return 84
    }
}
