//
//  TransferCoordinator.swift
//  BarakatWallet
//
//  Created by km1tj on 26/10/23.
//

import Foundation
import UIKit

enum TransferType {
    case byNumber
    case byCard
}

enum TransferIdentifier {
    case card(number: String)
    case number(number: String)
}

protocol TransferSumViewControllerDelegate: AnyObject {
    func senderPicked(sender: TransferIdentifier)
    func receiverPicked(receiver: TransferIdentifier)
}

protocol TransferCoordinatorDelegate: AnyObject {
    func backToLogin()
}

class TransferCoordinator: Coordinator {
    
    var children: [Coordinator] = []
    let nav: BaseNavigationController
    
    weak var delegate: TransferCoordinatorDelegate?
    
    var loginService: LoginService {
        return ENVIRONMENT.isMock ? LoginServiceMockImpl() : LoginServiceImpl()
    }
    
    var bannerService: BannerService {
        return ENVIRONMENT.isMock ? BannerServiceImpl() : BannerServiceMockImpl()
    }
    
    init(nav: BaseNavigationController) {
        self.nav = nav
        self.nav.navigationBar.isHidden = true
    }
    
    func start() {
        let vc = TransferMainViewController(bannerService: self.bannerService)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateBack() {
        self.nav.popViewController(animated: true)
    }
    
    func navigateToMain() {
        self.nav.popToRootViewController(animated: true)
    }
    
    func navigateToLogin() {
        self.delegate?.backToLogin()
    }
    
    func navigateToTransfer() {
        let vc = BeforeAuthRootViewController(overrideInterfaceStyle: true)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToPickSender(type: TransferType, delegate: TransferSumViewControllerDelegate?) {
        let vc = TransferSenderViewController(type: type, delegate: delegate)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToPickReceiver(type: TransferType, sender: TransferIdentifier, delegate: TransferSumViewControllerDelegate?) {
        let vc = TransferReceiverViewController(type: type, sender: sender, delegate: delegate)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToEnterSum(type: TransferType, sender: TransferIdentifier, receiver: TransferIdentifier) {
        let vc = TransferSumViewController(type: type, sender: sender, receiver: receiver)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func presentConfirm(type: TransferType, sender: TransferIdentifier, receiver: TransferIdentifier, amount: Double, currency: Currency) {
        let vc = TransferConfirmViewController(type: type, sender: sender, receiver: receiver, amount: amount, currency: currency)
        vc.coordinator = self
        self.nav.present(vc, animated: true)
    }
    
    func presentResult(type: TransferType, sender: TransferIdentifier, receiver: TransferIdentifier, amount: Double, currency: Currency, result: Bool) {
        let vc = TransferResultViewController(type: type, sender: sender, receiver: receiver, amount: amount, currency: currency, result: result)
        vc.coordinator = self
        self.nav.present(vc, animated: true)
    }
}
