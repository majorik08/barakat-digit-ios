//
//  LoginCoordinator.swift
//  BarakatWallet
//
//  Created by km1tj on 26/10/23.
//

import Foundation
import UIKit

class LoginCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    
    var children: [Coordinator] = []
    let nav: BaseNavigationController
    let authService: AccountService
    var bannerService: BannerService {
        return ENVIRONMENT.isMock ? BannerServiceMockImpl() : BannerServiceImpl()
    }
    weak var parent: AppCoordinator? = nil
    
    init(nav: BaseNavigationController, authService: AccountService) {
        self.authService = authService
        self.nav = nav
        self.nav.navigationBar.isHidden = true
    }
    
    func start() {
        let vc = FirstLaunchViewController(bannerService: self.bannerService)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateBack() {
        self.nav.popViewController(animated: true)
    }
    
    func navigateToLogin() {
        let vc = LoginViewController(viewModel: LoginViewModel(service: self.authService))
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
        let beforeAuth = BeforeAuthCoordinator(nav: self.nav)
        beforeAuth.parent = self
        beforeAuth.start()
        self.nav.delegate = self
        self.children.append(beforeAuth)
    }
    
    func navigateToValidate(phoneNumber: String, key: String, delegate: VerifyCodeViewControllerDelegate?) {
        let vc = VerifyCodeViewController(viewModel: .init(service: self.authService, phoneNumber: phoneNumber, key: key))
        vc.delegate = delegate
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToSetPin(key: String, exist: Bool, wallet: String) {
        let coor = PasscodeCoordinator(nav: self.nav, account: nil, authService: self.authService)
        coor.parent = self.parent
        coor.navigateToSetPasscode(key: key, exist: exist, wallet: wallet)
        self.children.append(coor)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        if let vvc = fromViewController as? BeforeAuthRootViewController {
            self.childDidFinish(vvc.coordinator)
        }
    }
    
    func presentStoriesPreView(stories: [AppStructs.Stories], handPickedStoryIndex: Int) {
        let vc = StoriesViewController(viewModel: .init(service: self.bannerService, stories: stories, handPickedStoryIndex: handPickedStoryIndex))
        self.nav.present(vc, animated: true)
    }
}
