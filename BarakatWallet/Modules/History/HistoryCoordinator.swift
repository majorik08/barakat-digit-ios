//
//  HistoryCoordinator.swift
//  BarakatWallet
//
//  Created by km1tj on 28/10/23.
//

import Foundation
import UIKit

class HistoryCoordinator: Coordinator {
    
    weak var parent: RootTabCoordinator? = nil
    var children: [Coordinator] = []
    let nav: BaseNavigationController
    
    private var started: Bool = false
    
    let accountInfo: AppStructs.AccountInfo
    
    init(nav: BaseNavigationController, accountInfo: AppStructs.AccountInfo) {
        self.accountInfo = accountInfo
        self.nav = nav
    }
    
    var historyService: HistoryService {
        return ENVIRONMENT.isMock ? HistoryServiceMockImpl(clientInfo: self.accountInfo.client) : HistoryServiceImpl(clientInfo: self.accountInfo.client)
    }
    
    var paymentsService: PaymentsService {
        return ENVIRONMENT.isMock ? PaymentsServiceMockImpl(accountInfo: self.accountInfo) : PaymentsServiceImpl(accountInfo: self.accountInfo)
    }
    
    func start() {
        if !self.started {
            self.started = true
            let vc = HistoryViewController(viewModel: .init(accountInfo: self.accountInfo, historyService: self.historyService, paymentsService: self.paymentsService))
            vc.coordinator = self
            self.nav.viewControllers = [vc]
        }
    }
    
    func navigateBack() {
        self.nav.popViewController(animated: true)
    }
    
    func navigateToHistory(forCreditCard: AppStructs.CreditDebitCard?) {
        let vm = HistoryViewModel(accountInfo: self.accountInfo, historyService: self.historyService, paymentsService: self.paymentsService)
        vm.forCreditCard = forCreditCard
        let vc = HistoryViewController(viewModel: vm)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToHistoryDetails(item: AppStructs.HistoryItem) {
        let viewModel = HistoryViewModel(accountInfo: self.accountInfo, historyService: self.historyService, paymentsService: self.paymentsService)
        let vc = HistoryDetailsViewController(viewModel: viewModel, item: item)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToRepetPayment(service: AppStructs.PaymentGroup.ServiceItem) {
        let payments = PaymentsCoordinator(nav: self.nav, accountInfo: self.accountInfo)
        payments.parent = self.parent
        payments.navigateToPaymentView(service: service, merchant: nil, favorite: nil, addFavoriteMode: false, transferParam: nil)
        self.children.append(payments)
    }
    
    func navigateToRecipeView(item: AppStructs.HistoryItem) {
        let viewModel = HistoryViewModel(accountInfo: self.accountInfo, historyService: self.historyService, paymentsService: self.paymentsService)
        let vc = HistoryRecipeViewController(viewModel: viewModel, item: item)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func presentSumPicker(currency: CurrencyEnum, delegate: HistorySumPickViewControllerDelegate?) {
        let vc = HistorySumPickViewController(currency: currency)
        vc.delegate = delegate
        vc.coordinator = self
        self.nav.present(vc, animated: true)
    }
    
    func presentFilterPicker(filter: HistoryFilter, delegate: HistoryFilterPickViewControllerDelegate?) {
        let vc = HistoryFilterPickViewController(filter: filter, viewModel: .init(accountInfo: self.accountInfo, historyService: self.historyService, paymentsService: self.paymentsService))
        vc.delegate = delegate
        vc.coordinator = self
        self.nav.present(vc, animated: true)
    }
}
