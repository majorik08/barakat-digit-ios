//
//  FirstLaunchViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 21/10/23.
//

import Foundation
import UIKit

class FirstLaunchViewController: BaseViewController {
    
    lazy var topViewMaxHeight: CGFloat = {
        return UIScreen.main.bounds.height * 0.4
    }()
    let topBar: LaunchTopView = {
        let view = LaunchTopView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let transferButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.radius = 14
        view.setTitle("TRANSFER_TO_TJ".localized, for: .normal)
        return view
    }()
    let loginButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.radius = 14
        view.setTitle("LOGIN_SIGNIN".localized, for: .normal)
        return view
    }()
    let versionLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 10)
        view.textAlignment = .center
        view.textColor = Theme.current.primaryTextColor
        view.text = "©LLC MDO «BARAKAT MOLIYA» 2023"
        return view
    }()
    weak var coordinator: LoginCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.topBar)
        self.view.addSubview(self.transferButton)
        self.view.addSubview(self.loginButton)
        self.view.addSubview(self.versionLabel)
        NSLayoutConstraint.activate([
            self.topBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.topBar.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.topBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.topBar.heightAnchor.constraint(equalToConstant: self.topViewMaxHeight),
            self.transferButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36),
            self.transferButton.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 30),
            self.transferButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36),
            self.transferButton.heightAnchor.constraint(equalToConstant: 56),
            self.loginButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 36),
            self.loginButton.topAnchor.constraint(equalTo: self.transferButton.bottomAnchor, constant: 20),
            self.loginButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -36),
            self.loginButton.heightAnchor.constraint(equalToConstant: 56),
            self.versionLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.versionLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            self.versionLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
        self.transferButton.addTarget(self, action: #selector(self.openTransfer), for: .touchUpInside)
        self.loginButton.addTarget(self, action: #selector(self.openLogin), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setStatusBarStyle(dark: false)
    }
    
    @objc func openTransfer() {
        self.coordinator?.navigateToTransfer()
    }
    
    @objc func openLogin() {
        self.coordinator?.navigateToLogin()
    }
    
    override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.topBar.themeChanged(newTheme: newTheme)
        self.versionLabel.textColor = Theme.current.primaryTextColor
    }
}
