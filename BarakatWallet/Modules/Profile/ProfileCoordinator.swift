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
    
    let accountInfo: AppStructs.AccountInfo
    
    var identifyService: IdentifyService {
        return ENVIRONMENT.isMock ? IdentifyServiceImpl() : IdentifyServiceImpl()
    }
    var authService: AccountService {
        return ENVIRONMENT.isMock ? AccountServiceMockImpl() : AccountServiceImpl()
    }
    
    init(nav: BaseNavigationController, accountInfo: AppStructs.AccountInfo) {
        self.nav = nav
        self.accountInfo = accountInfo
    }
    
    func start() {
        let vc = ProfileMainViewController(viewModel: ProfileViewModel(accountInfo: self.accountInfo, profileService: ProfileServiceImpl(accountInfo: self.accountInfo), identifyService: self.identifyService))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToRoot() {
        self.nav.popToRootViewController(animated: true)
    }
    
    func navigateBack() {
        self.nav.popViewController(animated: true)
    }
    
    func navigateToEditProfile() {
        let vc = ProfileEditViewController(viewModel: ProfileViewModel(accountInfo: self.accountInfo, profileService: ProfileServiceImpl(accountInfo: self.accountInfo), identifyService: self.identifyService))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToIdentify(identify: AppMethods.Client.IdentifyGet.IdentifyResult?) {
        let identifyCoor = IdentifyCoordinator(nav: self.nav, identifyService: self.identifyService, accountInfo: self.accountInfo)
        identifyCoor.parent = self
        identifyCoor.navigateToStatusView(identify: identify, limit: self.accountInfo.client.limit)
        self.children.append(identifyCoor)
    }
    
    func navigateToSettings() {
        let vc = ProfileSettingsViewController(viewModel: .init(accountInfo: self.accountInfo, profileService: ProfileServiceImpl(accountInfo: self.accountInfo), identifyService: self.identifyService))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func presentLogout() {
        let vc = ProfileLogoutViewController(viewModel: .init(accountInfo: self.accountInfo, profileService: ProfileServiceImpl(accountInfo: self.accountInfo), identifyService: self.identifyService))
        vc.coordinator = self
        self.nav.present(vc, animated: true)
    }
    
    func presentLanguage(delegate: AlertViewControllerDelegate?) {
        let vc = LanguageViewController(viewModel: .init(accountInfo: self.accountInfo, profileService: ProfileServiceImpl(accountInfo: self.accountInfo), identifyService: self.identifyService))
        vc.coordinator = self
        vc.delegate = delegate
        self.nav.present(vc, animated: true)
    }
    
    func presentTheme(delegate: AlertViewControllerDelegate?) {
        let vc = ThemeViewController(viewModel: .init(accountInfo: self.accountInfo, profileService: ProfileServiceImpl(accountInfo: self.accountInfo), identifyService: self.identifyService))
        vc.coordinator = self
        vc.delegate = delegate
        self.nav.present(vc, animated: true)
    }
    
    func presentBioAuth(auth: LocalAuthBiometricAuthentication, delegate: AlertViewControllerDelegate?) {
        let vc = BioAuthViewController(authType: auth)
        vc.coordinator = self
        vc.delegate = delegate
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
        let passcode = PasscodeCoordinator(nav: self.nav, account: account, authService: self.authService)
        passcode.parent = self
        passcode.navigateToSetPasscode()
        self.children.append(passcode)
    }
}
