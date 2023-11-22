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
    
    func navigateToRootViewController() {
        self.nav.popToRootViewController(animated: true)
    }
    
    func navigateToServiceGroups(paymentsOrder: PaymentsViewController.Order, paymentGroups: [AppStructs.PaymentGroup], transferTypes: [AppStructs.TransferTypes]) {
        let vm = PaymentsViewModel(service: self.paymentsService, accountInfo: self.accountInfo)
        vm.paymentGroups = paymentGroups
        vm.transferTypes = transferTypes
        let vc = PaymentsViewController(viewModel: vm, order: paymentsOrder)
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
    
    func navigateToHistoryView() {
        let history = HistoryCoordinator(nav: self.nav, accountInfo: self.accountInfo)
        history.parent = self.parent
        history.navigateToHistoryDetails(item: .init(date: Date()))
        self.children.append(history)
    }
    
    func presentPaymentConfirmResult(service: AppStructs.PaymentGroup.ServiceItem, amount: Double, currency: Currency) {
        let vc = PaymentConfirmViewController(viewModel: .init(service: self.paymentsService, accountInfo: self.accountInfo), service: service, amount: amount, currency: currency)
        vc.coordinator = self
        self.nav.present(vc, animated: true)
    }
    
    func presentSaveToFavorites() {
        let vc = AddFavoriteViewController(nibName: nil, bundle: nil)
        if let presented = self.nav.presentedViewController {
            presented.present(vc, animated: true)
        } else {
            self.nav.present(vc, animated: true)
        }
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
    
    func navigateToTransferAccounts(topupCreditCard: AppStructs.CreditDebitCard?) {
        let vc = TransferAccountsViewController(viewModel: .init(service: self.paymentsService, accountInfo: self.accountInfo), topupCreditCard: topupCreditCard)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func presentTransferPaymentChoose(paymentCard: AppStructs.CreditDebitCard?, transfers: Bool) {
        let vc = ChooseTransferViewController(type: transfers ? .transfers : .payments, viewModel: .init(service: self.paymentsService, accountInfo: self.accountInfo), paymentCreditCard: paymentCard)
        vc.coordinator = self
        self.nav.present(vc, animated: true)
    }
}
