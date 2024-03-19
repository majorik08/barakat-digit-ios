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
    var authService: AccountService {
        return ENVIRONMENT.isMock ? AccountServiceImpl() : AccountServiceImpl()
    }
    
    func startWithCheck() {
        if UIDevice.current.isJailBroken {
            let vc = WarningViewController()
            vc.coordinator = self
            self.window.rootViewController = vc
            self.window.makeKeyAndVisible()
        } else {
            self.start()
        }
    }
    
    func start() {
        let accounts = CoreAccount.accounts()
        if accounts.isEmpty {
            self.showLogin()
        } else {
            let account = accounts.first!
            self.showPasscode(account: account)
        }
    }
    
    func showLogin() {
        let login = LoginCoordinator(nav: FirstLaunchNavigation(overrideInterfaceStyle: false), authService: self.authService)
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
    
    func showPasscode(account: CoreAccount) {
        APIManager.instance.setToken(token: account.token)
        self.sendPushToken()
        let coordinator = PasscodeCoordinator(nav: FirstLaunchNavigation(overrideInterfaceStyle: false), account: account, authService: self.authService)
        coordinator.parent = self
        coordinator.start()
        self.children.append(coordinator)
        self.window.rootViewController = coordinator.nav
        self.window.makeKeyAndVisible()
    }
    
    func showMain(accountInfo: AppStructs.AccountInfo) {
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
        let _ = NotificationManager.instance
    }
    
    private func sendPushToken() {
        if !Constants.PushTokenSent {
            APIManager.instance.request(.init(AppMethods.Auth.DeviceUpdate(Constants.Device)), auth: .auth) { response in
                switch response.result {
                case .success(_):
                    Constants.PushTokenSent = true
                case .failure(_):
                    break
                }
            }
        }
    }
}
