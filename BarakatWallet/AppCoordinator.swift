//
//  Coordinator.swift
//  BarakatWallet
//
//  Created by km1tj on 26/10/23.
//

import Foundation
import UIKit
import RxSwift

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

let transactionUpdate = PublishSubject<(String, Int)>()
let authExpaired = PublishSubject<Void>()
let accountBlocked = PublishSubject<Void>()

final class AppCoordinator: Coordinator {
    
    var children: [Coordinator] = []
   
    var window: UIWindow
    let bag = DisposeBag()
    var lockTimeout: Double? = nil
    
    var authService: AccountService {
        return ENVIRONMENT.isMock ? AccountServiceImpl() : AccountServiceImpl()
    }
    
    init(window : UIWindow) {
        self.window = window
        authExpaired.observe(on: MainScheduler.instance).subscribe { _ in
            guard let account = CoreAccount.accounts().first else { return }
            let _ = CoreAccount.logout(account: account)
            self.showLogin(errorText: "AUTH_EXP_HELP".localized)
        }.disposed(by: self.bag)
        accountBlocked.observe(on: MainScheduler.instance).subscribe { _ in
            guard let account = CoreAccount.accounts().first else { return }
            let _ = CoreAccount.logout(account: account)
            self.showLogin(errorText: "ACCOUNT_BAN_ERROR".localized)
        }.disposed(by: self.bag)
    }
    
    func applicationDidEnterBackground() {
        if !CoreAccount.accounts().isEmpty {
            self.lockTimeout = Date().timeIntervalSince1970
        } else {
            self.lockTimeout = nil
        }
    }

    func applicationWillEnterForeground() {
        if let lockTimeout, Date().timeIntervalSince1970 - lockTimeout > 30, let a = CoreAccount.accounts().first {
            self.showPasscode(account: a)
        } else {
            self.lockTimeout = nil
        }
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
            self.showLogin(errorText: nil)
        } else {
            let account = accounts.first!
            self.showPasscode(account: account)
        }
    }
    
    func showLogin(errorText: String?) {
        APIManager.instance.setToken(token: nil)
        let nav = FirstLaunchNavigation(overrideInterfaceStyle: false)
        let login = LoginCoordinator(nav: nav, authService: self.authService)
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
        if let errorText {
            nav.showErrorAlert(title: "ERROR".localized, message: errorText)
        }
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
