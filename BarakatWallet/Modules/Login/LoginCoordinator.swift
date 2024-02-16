//
//  LoginCoordinator.swift
//  BarakatWallet
//
//  Created by km1tj on 26/10/23.
//

import Foundation
import UIKit

class LoginCoordinator: NSObject, Coordinator, TransferCoordinatorDelegate, UINavigationControllerDelegate {
    
    var children: [Coordinator] = []
    let nav: BaseNavigationController
    let loginService: LoginService
    
    var bannerService: BannerService {
        return ENVIRONMENT.isMock ? BannerServiceMockImpl() : BannerServiceImpl()
    }
    
    weak var parent: AppCoordinator? = nil
    
    init(nav: BaseNavigationController, loginService: LoginService) {
        self.loginService = loginService
        self.nav = nav
        self.nav.navigationBar.isHidden = true
    }
    
    func start() {
        let vc = FirstLaunchViewController(bannerService: self.bannerService)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func backToLogin() {
        self.navigateToLogin()
    }
    
    func navigateBack() {
        self.nav.popViewController(animated: true)
    }
    
    func navigateToLogin() {
        let vc = LoginViewController(viewModel: LoginViewModel(service: self.loginService))
        vc.hidesBottomBarWhenPushed = true
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToSelectCountry(delegate: CountryPickerDelegate) {
        let vc = CountryPickerViewController(transparentChange: false)
        vc.delegate = delegate
        vc.hidesBottomBarWhenPushed = true
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToTransfer() {
        let transfer = TransferCoordinator(nav: self.nav)
        transfer.delegate = self
        transfer.navigateToTransfer()
        self.nav.delegate = self
        self.children.append(transfer)
    }
    
    func navigateToValidate(phoneNumber: String, key: String) {
        let vc = VerifyCodeViewController(viewModel: .init(service: self.loginService, phoneNumber: phoneNumber, key: key))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToSetPin(account: CoreAccount) {
        self.parent?.showPasscode(account: account)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        if let vvc = fromViewController as? TransferMainViewController {
            self.childDidFinish(vvc.coordinator)
        }
    }
    
    func presentStoriesPreView(stories: [AppStructs.Stories], handPickedStoryIndex: Int) {
        let vc = StoriesViewController(viewModel: .init(service: self.bannerService, stories: stories, handPickedStoryIndex: handPickedStoryIndex))
        self.nav.present(vc, animated: true)
    }
}
