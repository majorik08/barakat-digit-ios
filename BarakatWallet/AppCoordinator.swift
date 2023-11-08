//
//  Coordinator.swift
//  BarakatWallet
//
//  Created by km1tj on 26/10/23.
//

import Foundation
import UIKit

protocol Service {
    
}

protocol Coordinator: AnyObject {
    var children: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in self.children.enumerated() {
            if coordinator === child {
                self.children.remove(at: index)
                break
            }
        }
    }
}

final class AppCoordinator: Coordinator {
    
    var children: [Coordinator] = []
   
    var window: UIWindow
    
    init(window : UIWindow) {
        self.window = window
    }
    
    var loginService: LoginService {
        return ENVIRONMENT.isMock ? LoginServiceMockImpl() : LoginServiceImpl()
    }
    var passcodeService: PasscodeService {
        return ENVIRONMENT.isMock ? PasscodeServiceMockImpl() : PasscodeServiceImpl()
    }
    
    func start() {
        let accounts = CoreAccount.accounts()
        if accounts.isEmpty {
            self.showLogin()
        } else {
            let account = accounts.first!
            APIManager.instance.setToken(token: account.token)
            self.showMain(account: account)
        }
    }
    
    func showLogin() {
        let login = LoginCoordinator(nav: FirstLaunchNavigation(nibName: nil, bundle: nil), loginService: self.loginService)
        login.parent = self
        login.start()
        self.window.rootViewController = login.nav
        UIView.transition(with: self.window, duration: 0.5, options: .transitionCrossDissolve) {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.window.rootViewController = login.nav
            UIView.setAnimationsEnabled(oldState)
        }
        self.window.makeKeyAndVisible()
        self.children.append(login)
    }
    
    func showMain(account: CoreAccount) {
        APIManager.instance.setToken(token: account.token)
        if let _ = account.pin {
            let vc = PasscodeViewController(viewModel: PasscodeViewModel(account: account, passcodeService: self.passcodeService))
            vc.coordinator = self
            self.window.rootViewController = vc
            self.window.makeKeyAndVisible()
        } else {
            let vc = SetPinViewController(viewModel: .init(account: account, startFor: .setup, checkComplition: { result in
                self.showMain(account: account)
            }))
            self.window.rootViewController = vc
            self.window.makeKeyAndVisible()
        }
    }
    
    func authSuccess(accountInfo: AppStructs.AccountInfo) {
        let main = RootTabCoordinator(accountInfo: accountInfo)
        main.parent = self
        main.start()
        self.children.append(main)
        self.window.rootViewController = main.tabBar
        UIView.transition(with: self.window, duration: 0.5, options: .transitionCrossDissolve) {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.window.rootViewController = main.tabBar
            UIView.setAnimationsEnabled(oldState)
        }
        self.window.makeKeyAndVisible()
    }
}
