//
//  PasscodeCoordinator.swift
//  BarakatWallet
//
//  Created by km1tj on 20/11/23.
//

import Foundation
import UIKit
import RxSwift

class PasscodeCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    
    var children: [Coordinator] = []
    let nav: BaseNavigationController
    let authService: AccountService
    let account: CoreAccount?
    let disposeBag = DisposeBag()
    
    weak var parent: Coordinator? = nil
    
    init(nav: BaseNavigationController, account: CoreAccount?, authService: AccountService) {
        self.authService = authService
        self.account = account
        self.nav = nav
        self.nav.navigationBar.isHidden = true
    }
    
    func navigateBack() {
        self.nav.popViewController(animated: true)
    }
    
    func start() {
        if let account = self.account {
            let vc = PasscodeViewController(account: account, authService: self.authService)
            vc.coordinator = self
            self.nav.pushViewController(vc, animated: true)
        }
    }
    
    func navigateToConfirm(phoneNumber: String, key: String, delegate: VerifyCodeViewControllerDelegate) {
        let vc = VerifyCodeViewController(viewModel: .init(service: self.authService, phoneNumber: phoneNumber, key: key))
        vc.delegate = delegate
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToSetPasscode(key: String, exist: Bool, wallet: String) {
        let vc = PasscodeSetViewController(viewModel: .init(authService: self.authService, startFor: .setup(key: key, exist: exist, wallet: wallet)))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToChangePasscode(account: CoreAccount) {
        let vc = PasscodeSetViewController(viewModel: .init(authService: self.authService, startFor: .change(account: account)))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToResetPasscode(key: String, wallet: String) {
        let vc = PasscodeResetViewController(viewModel: .init(authService: self.authService, startFor: .setup(key: key, exist: true, wallet: wallet)), key: key)
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
    
    func presentBioAuth(auth: LocalAuthBiometricAuthentication, accountInfo: AppStructs.AccountInfo, delegate: BioAuthViewControllerDelegate?) {
        let vc = BioAuthViewController(authType: auth, accountInfo: accountInfo)
        vc.delegate = delegate
        self.nav.present(vc, animated: true)
    }
}
