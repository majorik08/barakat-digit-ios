//
//  CardsCoordinator.swift
//  BarakatWallet
//
//  Created by km1tj on 28/10/23.
//

import Foundation
import UIKit

class CardsCoordinator: Coordinator {
    
    weak var parent: RootTabCoordinator? = nil
    var children: [Coordinator] = []
    let nav: BaseNavigationController
    
    private var started: Bool = false
    
    let accountInfo: AppStructs.AccountInfo
    
    var cardService: CardService {
        return ENVIRONMENT.isMock ? CardServiceImpl(clientInfo: self.accountInfo.client) : CardServiceImpl(clientInfo: self.accountInfo.client)
    }
    
    init(nav: BaseNavigationController, accountInfo: AppStructs.AccountInfo) {
        self.accountInfo = accountInfo
        self.nav = nav
    }
    
    func start() {
        if !self.started {
            self.started = true
            let vc = CardsViewController(viewModel: .init(cardService: CardServiceImpl(clientInfo: self.accountInfo.client)))
            vc.coordinator = self
            self.nav.pushViewController(vc, animated: true)
        }
    }
    
    func navigateBack() {
        self.nav.popViewController(animated: true)
    }
    
    func navigateToCardView(userCards: [AppStructs.CreditDebitCard], selectedCard: AppStructs.CreditDebitCard) {
        let viewModel = CardsViewModel(cardService: self.cardService)
        viewModel.userCards = userCards
        let vc = CardViewController(viewModel: viewModel, selectedCard: selectedCard)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToAddCardView() {
        let vc = CardAddViewController(viewModel: .init(cardService: self.cardService))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToReleaseCardView() {
        let vc = CardReleaseViewController(viewModel: .init(cardService: self.cardService))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToReleaseCardItem(cardItem: AppStructs.CreditDebitCardItem) {
        let vc = CardReleaseViewInfoController(viewModel: .init(cardService: self.cardService), cardItem: cardItem)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToTransferAccounts(topupCreditCard: AppStructs.CreditDebitCard) {
        let payments = PaymentsCoordinator(nav: self.nav, accountInfo: self.accountInfo)
        payments.parent = self.parent
        payments.navigateToTransferAccounts(topupCreditCard: topupCreditCard)
        self.children.append(payments)
    }
    
    func navigateToHistoryView(forCreditCard: AppStructs.CreditDebitCard) {
        let history = HistoryCoordinator(nav: self.nav, accountInfo: self.accountInfo)
        history.parent = self.parent
        history.navigateToHistory(forCreditCard: forCreditCard)
        self.children.append(history)
    }
    
    func presentTransferPaymentChoose(paymentCard: AppStructs.CreditDebitCard, showTransfers: Bool) {
        let payments = PaymentsCoordinator(nav: self.nav, accountInfo: self.accountInfo)
        payments.parent = self.parent
        payments.presentTransferPaymentChoose(paymentCard: paymentCard, transfers: showTransfers)
        self.children.append(payments)
    }
}
