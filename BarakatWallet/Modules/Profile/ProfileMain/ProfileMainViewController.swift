//
//  ProfileMainViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 30/10/23.
//

import Foundation
import UIKit
import MobileCoreServices

class ProfileMainViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
   
    let topBar: ProfileTopBar = {
        let view = ProfileTopBar(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInset = .init(top: 20, left: 0, bottom: 0, right: 0)
        view.backgroundColor = .clear
        view.register(ProfileTabelCell.self, forCellReuseIdentifier: "cell")
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
        self.view.addSubview(self.topBar)
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.topBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.topBar.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.topBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.topBar.bottomAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        self.topBar.backButton.tintColor = .white
        self.topBar.backButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        self.topBar.statusView.addTarget(self, action: #selector(self.goIdentify), for: .touchUpInside)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.topBar.subTitleLabel.text = self.viewModel.clientInfo.wallet.formatedPrefix()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            self.coordinator?.navigateToEditProfile()
        } else if indexPath.row == 1 {
            self.coordinator?.navigateToSettings()
        }
    }
    
    override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
        self.topBar.themeChanged(newTheme: newTheme)
        self.topBar.statusView.roundCorners(corners: [.bottomLeft, .topRight], radius: 12, thickness: 1.5, color: Theme.current.secondTintColor)
        self.tableView.reloadData()
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
    
    @objc func goIdentify() {
        self.coordinator?.navigateToIdentify()
    }
    
    @objc func goBack() {
        self.coordinator?.navigateBack()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
}
