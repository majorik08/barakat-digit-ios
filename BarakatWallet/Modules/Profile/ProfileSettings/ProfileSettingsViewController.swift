//
//  ProfileSettingsViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 30/10/23.
//

import Foundation
import UIKit

class ProfileSettingsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    let viewModel: ProfileViewModel
    weak var coordinator: ProfileCoordinator?
    
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
        self.setStatusBarStyle(dark: true)
    }
    
    override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.tableView.reloadData()
    }
    
    override func languageChanged() {
        super.languageChanged()
        self.navigationItem.title = "PROFILE_SETTINGS".localized
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 8:
            self.coordinator?.presentLogout()
        case 7:
            self.coordinator?.navigateToAboutApp()
        case 6:
            self.coordinator?.navigateToDocs()
        case 2:
            guard let account = self.viewModel.account() else { return }
            self.coordinator?.navigateToChangePasscode(account: account)
        case 1:
            self.coordinator?.presentTheme()
        case 0:
            self.coordinator?.presentLanguage()
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsTableCell
            cell.titleLabel.text = "LANGUAGE".localized
            cell.infoLabel.text = Localize.currentLanguage.rawValue.localized
            cell.iconView.backgroundColor = .clear
            cell.iconView.tintColor = Theme.current.secondTintColor
            cell.iconView.image = UIImage(name: .arrow_right)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsTableCell
            cell.titleLabel.text = "THEME".localized
            cell.infoLabel.text = Constants.Theme.localized
            cell.iconView.backgroundColor = .clear
            cell.iconView.tintColor = Theme.current.secondTintColor
            cell.iconView.image = UIImage(name: .arrow_right)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsTableCell
            cell.titleLabel.text = "CHANGE_PASSCODE_TITLE".localized
            cell.infoLabel.text = nil
            cell.iconView.backgroundColor = .clear
            cell.iconView.tintColor = Theme.current.secondTintColor
            cell.iconView.image = UIImage(name: .arrow_right)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "switch_cell", for: indexPath) as! SettingsSwitchCell
            cell.titleLabel.text = "SMS_SIGN_IN".localized
            cell.switchView.setOn(self.viewModel.clientInfo.smsPush, animated: false)
            cell.switchDelegate = { (state) -> Void in
                
            }
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "switch_cell", for: indexPath) as! SettingsSwitchCell
            cell.titleLabel.text = "USE_BIO_AUTH".localized
            cell.switchView.setOn(Constants.DeviceBio, animated: false)
            cell.switchDelegate = { (state) -> Void in
                Constants.DeviceBio = state
            }
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "switch_cell", for: indexPath) as! SettingsSwitchCell
            cell.titleLabel.text = "USE_PUSH".localized
            cell.switchView.setOn(Constants.DeviceBio, animated: false)
            cell.switchDelegate = { (state) -> Void in
                
            }
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsTableCell
            cell.titleLabel.text = "PRIVACY_DOCS".localized
            cell.infoLabel.text = nil
            cell.iconView.backgroundColor = .clear
            cell.iconView.tintColor = Theme.current.secondTintColor
            cell.iconView.image = UIImage(name: .arrow_right)
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsTableCell
            cell.titleLabel.text = "ABOUT_APP".localized
            cell.infoLabel.text = "APP_VERSION".localizedFormat(arguments: Constants.Version)
            cell.iconView.backgroundColor = .clear
            cell.iconView.tintColor = Theme.current.secondTintColor
            cell.iconView.image = UIImage(name: .arrow_right)
            return cell
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsTableCell
            cell.titleLabel.text = "LOGOUT_FROM_ACC".localized
            cell.infoLabel.text = nil
            cell.iconView.backgroundColor = .systemRed
            cell.iconView.tintColor = .white
            cell.iconView.image = UIImage(name: .logout)
            return cell
        default:return UITableViewCell(frame: .zero)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
}
