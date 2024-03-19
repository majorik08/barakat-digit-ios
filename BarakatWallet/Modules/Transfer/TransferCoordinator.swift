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
    case card(number: String, phoneNumber: String)
    case number(number: String, service: AppStructs.PaymentGroup.ServiceItem, info: String)
    
    var account: String {
        switch self {
        case .card(let number,_):
            return number
        case .number(let number, _, _):
            return number
        }
    }
    var accountType: AppStructs.AccountType {
        switch self {
        case .card(_,_):
            return .card
        case .number(_, _, _):
            return .wallet
        }
    }
    var phoneNumber: String {
        switch self {
        case .card(_, phoneNumber: let phoneNumber):
            return phoneNumber
        case .number(number: let number, _, _):
            return number
        }
    }
    var serviceId: Int {
        switch self {
        case .card(_,_):
            return AppStructs.TransferType.transferToCard.rawValue
        case .number(_, service: let service, _):
            return service.id
        }
    }
}

protocol TransferSumViewControllerDelegate: AnyObject {
    func receiverPicked(receiver: TransferIdentifier)
}

class TransferCoordinator: Coordinator {
  
    var children: [Coordinator] = []
    let nav: BaseNavigationController
    weak var parent: Coordinator? = nil
    
    var bannerService: BannerService {
        return ENVIRONMENT.isMock ? BannerServiceMockImpl() : BannerServiceImpl()
    }
    var transferService: TransferService {
        return TransferServiceImpl()
    }
    
    init(nav: BaseNavigationController) {
        self.nav = nav
        self.nav.navigationBar.isHidden = true
    }
    
    func start() {
        self.navigateToTypePick()
    }
    
    func navigateBack() {
        if let p = self.parent as? BeforeAuthCoordinator, self.nav.viewControllers.count == 1 {
            p.nav.popViewController(animated: true)
        } else {
            self.nav.popViewController(animated: true)
        }
    }
    
    func navigateToMain() {
        self.nav.popToRootViewController(animated: true)
    }
    
    func navigateToLogin() {
        if let p = self.parent as? BeforeAuthCoordinator {
            p.goToLogin()
        }
    }
    
    func navigateToTypePick() {
        let vc = TransferMainViewController(viewModel: .init(service: self.transferService, bannerService: self.bannerService))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToPickReceiver(type: TransferType, delegate: TransferSumViewControllerDelegate?) {
        let vc = TransferReceiverViewController(viewModel: .init(service: self.transferService, bannerService: self.bannerService), type: type, delegate: delegate)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToEnterSum(type: TransferType, receiver: TransferIdentifier, transferData: AppMethods.Transfers.GetTransgerData.GetTransgerDataResult) {
        let vc = TransferSumViewController(viewModel: .init(service: self.transferService, bannerService: self.bannerService), type: type, receiver: receiver, transferData: transferData)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToResult(result: Bool) {
        let vc = TransferResultViewController(result: result)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
}
