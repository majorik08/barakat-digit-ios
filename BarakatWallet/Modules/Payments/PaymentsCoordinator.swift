//
//  PaymentsCoordinator.swift
//  BarakatWallet
//
//  Created by km1tj on 28/10/23.
//

import Foundation
import UIKit

class PaymentsCoordinator: Coordinator {
    
    weak var parent: RootTabCoordinator? = nil
    var children: [Coordinator] = []
    let nav: BaseNavigationController
    
    private var started: Bool = false
    
    let accountInfo: AppStructs.AccountInfo
    
    var paymentsService: PaymentsService {
        return ENVIRONMENT.isMock ? PaymentsServiceMockImpl() : PaymentsServiceImpl()
    }
    
    init(nav: BaseNavigationController, accountInfo: AppStructs.AccountInfo) {
        self.accountInfo = accountInfo
        self.nav = nav
    }
    
    func start() {
        if !self.started {
            self.started = true
            let vc = PaymentsViewController(viewModel: .init(service: self.paymentsService, accountInfo: self.accountInfo))
            vc.coordinator = self
            self.nav.viewControllers = [vc]
        }
    }
    
    func navigateToServiceGroups(paymentsOrder: PaymentsViewController.Order) {
        let vc = PaymentsViewController(viewModel: .init(service: self.paymentsService, accountInfo: self.accountInfo), order: paymentsOrder)
        vc.hidesBottomBarWhenPushed = true
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToServicesList(selectedGroup: AppStructs.PaymentGroup) {
        let vc = ServiceListViewController(viewModel: .init(service: self.paymentsService, accountInfo: self.accountInfo), selectedGroup: selectedGroup)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToPaymentView(service: AppStructs.PaymentGroup.ServiceItem) {
        let vc = PaymentViewController(viewModel: .init(service: self.paymentsService, accountInfo: self.accountInfo), service: service)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToTransferView(transfer: AppStructs.TransferTypes) {
        let vc = TransferViewController(viewModel: .init(service: self.paymentsService, accountInfo: self.accountInfo), transfer: transfer)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToTransferByNumberView() {
        let vc = TransferByNumberViewController(viewModel: .init(service: self.paymentsService, accountInfo: self.accountInfo))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    
}
