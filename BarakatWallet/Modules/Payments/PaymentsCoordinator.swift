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
        return ENVIRONMENT.isMock ? PaymentsServiceMockImpl(accountInfo: self.accountInfo) : PaymentsServiceImpl(accountInfo: self.accountInfo)
    }
    
    var historyService: HistoryService {
        return ENVIRONMENT.isMock ? HistoryServiceMockImpl(clientInfo: self.accountInfo.client) : HistoryServiceImpl(clientInfo: self.accountInfo.client)
    }
    
    init(nav: BaseNavigationController, accountInfo: AppStructs.AccountInfo) {
        self.accountInfo = accountInfo
        self.nav = nav
    }
    
    func start() {
        if !self.started {
            self.started = true
            let vc = PaymentsViewController(viewModel: .init(service: self.paymentsService, historyService: self.historyService, accountInfo: self.accountInfo), addFavoriteMode: false, searchMode: false)
            vc.coordinator = self
            self.nav.viewControllers = [vc]
        }
    }
    
    func navigateToRootViewController() {
        self.nav.popToRootViewController(animated: true)
    }
    
    func navigateToServiceGroups(paymentsOrder: PaymentsViewController.Order, paymentGroups: [AppStructs.PaymentGroup], transferTypes: [AppStructs.PaymentGroup.ServiceItem], addFavoriteMode: Bool, searchMode: Bool) {
        let vm = PaymentsViewModel(service: self.paymentsService, historyService: self.historyService, accountInfo: self.accountInfo)
        let vc = PaymentsViewController(viewModel: vm, order: paymentsOrder, addFavoriteMode: addFavoriteMode, searchMode: searchMode)
        vc.hidesBottomBarWhenPushed = true
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToServicesList(selectedGroup: AppStructs.PaymentGroup, addFavoriteMode: Bool) {
        if selectedGroup.childGroups.isEmpty {
            let vc = ServiceListViewController(viewModel: .init(service: self.paymentsService, historyService: self.historyService, accountInfo: self.accountInfo), selectedGroup: selectedGroup, addFavoriteMode: addFavoriteMode)
            vc.coordinator = self
            self.nav.pushViewController(vc, animated: true)
        } else {
            let vc = GroupListViewController(viewModel: .init(service: self.paymentsService, historyService: self.historyService, accountInfo: self.accountInfo), selectedGroup: selectedGroup, addFavoriteMode: addFavoriteMode)
            vc.coordinator = self
            self.nav.pushViewController(vc, animated: true)
        }
    }
    
    func navigateToPaymentView(service: AppStructs.PaymentGroup.ServiceItem, merchant: AppStructs.Merchant?, favorite: AppStructs.Favourite?, addFavoriteMode: Bool, transferParam: String?) {
        guard let transferType = AppStructs.TransferType(rawValue: service.id) else {
            let vc = PaymentViewController(viewModel: .init(service: self.paymentsService, historyService: self.historyService, accountInfo: self.accountInfo), service: service, merchant: merchant, favorite: favorite, addFavoriteMode: addFavoriteMode)
            vc.coordinator = self
            self.nav.pushViewController(vc, animated: true)
            return
        }
        switch transferType {
        case .transferToPhone:
            self.navigateToTransferByNumberView(transferParam: transferParam)
        case .transferToCard:
            self.navigateToTransferByCardView()
        case .transferBetweenAccounts:
            self.navigateToTransferAccounts(topupCreditCard: nil)
        }
    }
    
    func navigateToHistoryRecipe(item: AppStructs.HistoryItem) {
        let history = HistoryCoordinator(nav: self.nav, accountInfo: self.accountInfo)
        history.parent = self.parent
        history.navigateToRecipeView(item: item)
        self.children.append(history)
    }
    
    func navigateToTransferByNumberView(transferParam: String?) {
        let vc = TransferByNumberViewController(viewModel: .init(service: self.paymentsService, historyService: self.historyService, accountInfo: self.accountInfo), transferParam: transferParam)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToTransferByCardView() {
        let vc = TransferByCardViewController(viewModel: .init(service: self.paymentsService, historyService: self.historyService, accountInfo: self.accountInfo))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToTransferAccounts(topupCreditCard: AppStructs.CreditDebitCard?) {
        let vc = TransferByAccountsViewController(viewModel: .init(service: self.paymentsService, historyService: self.historyService, accountInfo: self.accountInfo), topupCreditCard: topupCreditCard)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func presentTransferPaymentChoose(paymentCard: AppStructs.CreditDebitCard?, transfers: Bool) {
        let vc = ChooseTransferViewController(type: transfers ? .transfers : .payments, viewModel: .init(service: self.paymentsService, historyService: self.historyService, accountInfo: self.accountInfo), paymentCreditCard: paymentCard)
        vc.coordinator = self
        self.nav.present(vc, animated: true)
    }
}
