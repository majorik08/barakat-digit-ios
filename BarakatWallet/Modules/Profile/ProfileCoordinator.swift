//
//  ProfileCoordinator.swift
//  BarakatWallet
//
//  Created by km1tj on 28/10/23.
//

import Foundation

class ProfileCoordinator: Coordinator {
    
    var children: [Coordinator] = []
    let nav: BaseNavigationController
    weak var parent: HomeCoordinator? = nil
    
    let clientInfo: AppStructs.ClientInfo
    
    init(nav: BaseNavigationController, clientInfo: AppStructs.ClientInfo) {
        self.nav = nav
        self.clientInfo = clientInfo
    }
    
    func start() {
        let vc = ProfileMainViewController(viewModel: ProfileViewModel(clientInfo: self.clientInfo, profileService: ProfileServiceImpl(clientInfo: self.clientInfo)))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateBack() {
        self.nav.popViewController(animated: true)
    }
    
    func navigateToEditProfile() {
        let vc = ProfileEditViewController(viewModel: ProfileViewModel(clientInfo: self.clientInfo, profileService: ProfileServiceImpl(clientInfo: self.clientInfo)))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToIdentify() {
        let identify = IdentifyCoordinator(nav: self.nav, identifyService: IdentifyServiceImpl())
        identify.parent = self
        identify.start()
        self.children.append(identify)
    }
    
    func navigateToSettings() {
        let vc = ProfileSettingsViewController(viewModel: .init(clientInfo: self.clientInfo, profileService: ProfileServiceImpl(clientInfo: self.clientInfo)))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func presentLogout() {
        let vc = ProfileLogoutViewController(viewModel: .init(clientInfo: self.clientInfo, profileService: ProfileServiceImpl(clientInfo: self.clientInfo)))
        vc.coordinator = self
        self.nav.present(vc, animated: true)
    }
    
    func presentLanguage() {
        let vc = LanguageViewController(viewModel: .init(clientInfo: self.clientInfo, profileService: ProfileServiceImpl(clientInfo: self.clientInfo)))
        vc.coordinator = self
        self.nav.present(vc, animated: true)
    }
    
    func presentTheme() {
        let vc = ThemeViewController(viewModel: .init(clientInfo: self.clientInfo, profileService: ProfileServiceImpl(clientInfo: self.clientInfo)))
        vc.coordinator = self
        self.nav.present(vc, animated: true)
    }
    
    func logoutFromAccount() {
        self.parent?.parent?.parent?.showLogin()
    }
    
    func navigateToAboutApp() {
        let vc = AboutViewController(nibName: nil, bundle: nil)
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToDocs() {
        let vc = ProfilePrivacyViewController(nibName: nil, bundle: nil)
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToChangePasscode(account: CoreAccount) {
        let vc = SetPinViewController(viewModel: SetPinViewModel(account: account, startFor: .change(old: account.pin ?? ""), checkComplition: { result in
            if result {
                self.nav.popViewController(animated: true)
            }
        }))
        self.nav.pushViewController(vc, animated: true)
    }
}
