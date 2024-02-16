//
//  ProfileSettingsViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 30/10/23.
//

import Foundation
import UIKit

protocol AlertViewControllerDelegate: AnyObject {
    func didDismisAlert()
}

class ProfileSettingsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, AlertViewControllerDelegate {
    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInset = .init(top: 20, left: 0, bottom: 0, right: 0)
        view.backgroundColor = .clear
        view.register(SettingsTableCell.self, forCellReuseIdentifier: "cell")
        view.register(SettingsSwitchCell.self, forCellReuseIdentifier: "switch_cell")
        view.separatorStyle = .none
        return view
    }()
    var authType: LocalAuthBiometricAuthentication?
    let viewModel: ProfileViewModel
    weak var coordinator: ProfileCoordinator?
    
    enum SettingsItem { case language, theme, changePin, smsSignIn, useBiometricAuth, push, docs, about, logout }
    var settings: [SettingsItem]
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        let type = LocalAuth.biometricAuthentication
        if type != nil {
            self.settings = [.language, .theme, .changePin, .smsSignIn, .useBiometricAuth, .push, .docs, .about, .logout]
        } else {
            self.settings = [.language, .theme, .changePin, .smsSignIn, .push, .docs, .about, .logout]
        }
        self.authType = type
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "PROFILE_SETTINGS".localized
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setStatusBarStyle(dark: nil)
    }
    
    override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.tableView.reloadData()
    }
    
    override func languageChanged() {
        super.languageChanged()
        self.navigationItem.title = "PROFILE_SETTINGS".localized
        self.tableView.reloadData()
    }
    
    func didDismisAlert() {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.settings[indexPath.row]
        switch item {
        case .language:
            self.coordinator?.presentLanguage(delegate: self)
        case .theme:
            self.coordinator?.presentTheme(delegate: self)
        case .changePin:
            guard let account = self.viewModel.account() else { return }
            self.coordinator?.navigateToChangePasscode(account: account)
        case .smsSignIn:
            break
        case .useBiometricAuth:
            break
        case .push:
            break
        case .docs:
            self.coordinator?.navigateToDocs()
        case .about:
            self.coordinator?.navigateToAboutApp()
        case .logout:
            self.coordinator?.presentLogout()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.settings[indexPath.row]
        switch item {
        case .language, .theme, .changePin, .docs, .about, .logout:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsTableCell
            cell.iconView.backgroundColor = .clear
            cell.iconView.tintColor = Theme.current.secondTintColor
            cell.iconView.image = UIImage(name: .arrow_right)
            cell.rootView.backgroundColor = Theme.current.plainTableCellColor
            cell.titleLabel.textColor = Theme.current.primaryTextColor
            cell.infoLabel.textColor = Theme.current.secondaryTextColor
            switch item {
            case .language:
                cell.titleLabel.text = "LANGUAGE".localized
                cell.infoLabel.text = Localize.currentLanguage.rawValue.localized
            case .theme:
                cell.titleLabel.text = "THEME".localized
                cell.infoLabel.text = Constants.Theme.localized
            case .changePin:
                cell.titleLabel.text = "CHANGE_PASSCODE_TITLE".localized
                cell.infoLabel.text = nil
            case .docs:
                cell.titleLabel.text = "PRIVACY_DOCS".localized
                cell.infoLabel.text = nil
            case .about:
                cell.titleLabel.text = "ABOUT_APP".localized
                cell.infoLabel.text = "APP_VERSION".localizedFormat(arguments: Constants.Version)
            case .logout:
                cell.titleLabel.text = "LOGOUT_FROM_ACC".localized
                cell.infoLabel.text = nil
                cell.iconView.backgroundColor = .systemRed
                cell.iconView.tintColor = .white
                cell.iconView.image = UIImage(name: .logout)
            default:break
            }
            return cell
        case .smsSignIn, .useBiometricAuth, .push:
            let cell = tableView.dequeueReusableCell(withIdentifier: "switch_cell", for: indexPath) as! SettingsSwitchCell
            cell.rootView.backgroundColor = Theme.current.plainTableCellColor
            cell.titleLabel.textColor = Theme.current.primaryTextColor
            switch item {
            case .smsSignIn:
                cell.titleLabel.text = "SMS_SIGN_IN".localized
                cell.switchView.setOn(self.viewModel.accountInfo.client.smsPush, animated: false)
                cell.switchDelegate = { (state) -> Void in
                    self.viewModel.setSettings(pushNotify: self.viewModel.accountInfo.client.pushNotify, smsPush: state)
                }
            case .useBiometricAuth:
                cell.titleLabel.text = "USE_BIO_AUTH".localized
                cell.switchView.setOn(Constants.DeviceBio, animated: false)
                cell.switchDelegate = { (state) -> Void in
                    if !state {
                        Constants.DeviceBio = state
                    } else if let authType = self.authType {
                        self.coordinator?.presentBioAuth(auth: authType, delegate: self)
                    }
                }
            case .push:
                cell.titleLabel.text = "USE_PUSH".localized
                cell.switchView.setOn(self.viewModel.accountInfo.client.pushNotify, animated: false)
                cell.switchDelegate = { (state) -> Void in
                    self.viewModel.setSettings(pushNotify: state, smsPush: self.viewModel.accountInfo.client.smsPush)
                }
            default:break
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settings.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
}
