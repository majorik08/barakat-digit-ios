//
//  PasscodeCoordinator.swift
//  BarakatWallet
//
//  Created by km1tj on 20/11/23.
//

import Foundation
import UIKit

class PasscodeCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    
    var children: [Coordinator] = []
    let nav: BaseNavigationController
    let authService: AccountService
    let account: CoreAccount
    
    weak var parent: Coordinator? = nil
    
    init(nav: BaseNavigationController, account: CoreAccount, authService: AccountService) {
        self.authService = authService
        self.account = account
        self.nav = nav
        self.nav.navigationBar.isHidden = true
    }
    
    func navigateBack() {
        self.nav.popViewController(animated: true)
    }
    
    func start() {
        if let pin = self.account.pin {
            let vc = PasscodeViewController(viewModel: .init(authService: self.authService, account: self.account, startFor: .check(pin: pin)))
            vc.coordinator = self
            self.nav.pushViewController(vc, animated: true)
        } else {
            let vc = PasscodeSetViewController(viewModel: .init(authService: self.authService, account: self.account, startFor: .setup))
            vc.coordinator = self
            self.nav.pushViewController(vc, animated: true)
        }
    }
    
    func navigateToResetPasscode() {
        let vc = PasscodeResetViewController(viewModel: .init(authService: self.authService, account: self.account, startFor: .change(old: self.account.pin ?? "")))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToSetPasscode() {
        let vc: PasscodeSetViewController
        if let pin = self.account.pin {
            vc = PasscodeSetViewController(viewModel: .init(authService: self.authService, account: self.account, startFor: .change(old: pin)))
        } else {
            vc = PasscodeSetViewController(viewModel: .init(authService: self.authService, account: self.account, startFor: .setup))
        }
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func authSuccess(accountInfo: AppStructs.AccountInfo) {
        if let app = self.parent as? AppCoordinator {
            app.showMain(accountInfo: accountInfo)
        } else if let profile = self.parent as? ProfileCoordinator {
            profile.navigateToRoot()
        }
    }
    
    func presentBioAuth(auth: LocalAuthBiometricAuthentication, delegate: AlertViewControllerDelegate?) {
        let vc = BioAuthViewController(authType: auth)
        vc.delegate = delegate
        self.nav.present(vc, animated: true)
    }
}
