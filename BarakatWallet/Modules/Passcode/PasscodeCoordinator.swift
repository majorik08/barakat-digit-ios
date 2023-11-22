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
    
    weak var parent: AppCoordinator? = nil
    
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
        let vc = PasscodeResetViewController(viewModel: .init(authService: self.authService, account: self.account, startFor: .change(old: "")))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func authSuccess(accountInfo: AppStructs.AccountInfo) {
        self.parent?.showMain(accountInfo: accountInfo)
    }
}
