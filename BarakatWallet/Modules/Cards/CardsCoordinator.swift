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
        return CardServiceImpl(accountInfo: self.accountInfo)
    }
    var paymentsService: PaymentsService {
        return ENVIRONMENT.isMock ? PaymentsServiceMockImpl(accountInfo: self.accountInfo) : PaymentsServiceImpl(accountInfo: self.accountInfo)
    }
    var authService: AccountService {
        return ENVIRONMENT.isMock ? AccountServiceImpl() : AccountServiceImpl()
    }
    
    init(nav: BaseNavigationController, accountInfo: AppStructs.AccountInfo) {
        self.accountInfo = accountInfo
        self.nav = nav
    }
    
    func start() {
        if !self.started {
            self.started = true
            let vc = CardsViewController(viewModel: .init(cardService: self.cardService, paymentsService: self.paymentsService, accountInfo: self.accountInfo))
            vc.coordinator = self
            self.nav.pushViewController(vc, animated: true)
        }
    }
    
    func navigateBack() {
        self.nav.popViewController(animated: true)
    }
    
    func navigateToRoot() {
        self.nav.popToRootViewController(animated: true)
    }
    
    func navigateToCardView(userCards: [AppStructs.CreditDebitCard], selectedCard: AppStructs.CreditDebitCard) {
        let viewModel = CardsViewModel(cardService: self.cardService, paymentsService: self.paymentsService, accountInfo: self.accountInfo)
        let vc = CardViewController(viewModel: viewModel, selectedCard: selectedCard)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToPinChange(card: AppStructs.CreditDebitCard) {
        let viewModel = CardsViewModel(cardService: self.cardService, paymentsService: self.paymentsService, accountInfo: self.accountInfo)
        let vc = CardPinViewController(viewModel: viewModel, card: card)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToAddCardView() {
        let vc = CardAddViewController(viewModel: .init(cardService: self.cardService, paymentsService: self.paymentsService, accountInfo: self.accountInfo))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToReleaseCardView(categoryId: Int?) {
        let vc = CardReleaseViewController(viewModel: .init(cardService: self.cardService, paymentsService: self.paymentsService, accountInfo: self.accountInfo), categoryId: categoryId)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToReleaseCardItem(cardItem: AppStructs.CreditDebitCardTypes) {
        let vc = CardReleaseViewInfoController(viewModel: .init(cardService: self.cardService, paymentsService: self.paymentsService, accountInfo: self.accountInfo), cardItem: cardItem)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToConfirm(phoneNumber: String, key: String, delegate: VerifyCodeViewControllerDelegate) {
        let vc = VerifyCodeViewController(viewModel: .init(service: self.authService, phoneNumber: phoneNumber, key: key))
        vc.delegate = delegate
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToOrderCard(cardItem: AppStructs.CreditDebitCardTypes, regions: [AppStructs.Region]) {
        let vc = CardOrderViewController(viewModel: .init(cardService: self.cardService, paymentsService: self.paymentsService, accountInfo: self.accountInfo), cardItem: cardItem, regions: regions)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToPaymentCard(cardItem: AppStructs.CreditDebitCardTypes, holderMidname: String, holderName: String, holderSurname: String,
                               phoneNumber: String, receivingType: AppMethods.Card.OrderBankCard.Params.ReceivingType, region: AppStructs.Region, pointId: Int?) {
        let vc = CardPaymentViewController(viewModel: .init(cardService: self.cardService, paymentsService: self.paymentsService, accountInfo: self.accountInfo), cardItem: cardItem, holderMidname: holderMidname, holderName: holderName, holderSurname: holderSurname, phoneNumber: phoneNumber, receivingType: receivingType, region: region, pointId: pointId)
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
