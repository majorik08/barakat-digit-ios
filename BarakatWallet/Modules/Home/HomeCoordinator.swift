//
//  MainCoordinator.swift
//  BarakatWallet
//
//  Created by km1tj on 26/10/23.
//

import Foundation
import UIKit

class HomeCoordinator: Coordinator {
    
    weak var parent: RootTabCoordinator? = nil
    var children: [Coordinator] = []
    let nav: BaseNavigationController
    let accountInfo: AppStructs.AccountInfo
    
    var paymentsService: PaymentsService {
        return ENVIRONMENT.isMock ? PaymentsServiceMockImpl() : PaymentsServiceImpl()
    }
    var bannerService: BannerService {
        return ENVIRONMENT.isMock ? BannerServiceImpl() : BannerServiceMockImpl()
    }
    var favouriteService: FavouriteService {
        return ENVIRONMENT.isMock ? FavouriteServiceImpl() : FavouriteServiceImpl()
    }
    var ratesService: RatesService {
        return ENVIRONMENT.isMock ? RatesServiceMockImpl() : RatesServiceImpl()
    }
    var accountService: AccountService {
        return ENVIRONMENT.isMock ? AccountServiceMockImpl() : AccountServiceImpl()
    }
    
    init(nav: BaseNavigationController, accountInfo: AppStructs.AccountInfo) {
        self.accountInfo = accountInfo
        self.nav = nav
        self.nav.navigationBar.isHidden = true
    }
    
    func start() {
        let home = HomeViewController(viewModel: .init(accountService: self.accountService, paymentsService: self.paymentsService, bannerService: self.bannerService, ratesService: self.ratesService, accountInfo: self.accountInfo))
        home.coordinator = self
        self.nav.viewControllers = [home]
    }
    
    func navigateToProfile() {
        let profile = ProfileCoordinator(nav: self.nav, accountInfo: self.accountInfo)
        profile.parent = self
        profile.start()
        self.children.append(profile)
    }
    
    func navigateToNotify() {
        let notify = NotifyCoordinator(nav: self.nav, clientInfo: self.accountInfo.client)
        notify.parent = self
        notify.start()
        self.children.append(notify)
    }
    
    func navigateToPayments(fromTransfers: Bool, paymentGroups: [AppStructs.PaymentGroup], transferTypes: [AppStructs.TransferTypes]) {
        let payments = PaymentsCoordinator(nav: self.nav, accountInfo: self.accountInfo)
        payments.parent = self.parent
        payments.navigateToServiceGroups(paymentsOrder: fromTransfers ? .firstTransfers : .firstPayments, paymentGroups: paymentGroups, transferTypes: transferTypes)
        self.children.append(payments)
    }
    
    func navigateToServicesList(selectedGroup: AppStructs.PaymentGroup) {
        let payments = PaymentsCoordinator(nav: self.nav, accountInfo: self.accountInfo)
        payments.parent = self.parent
        payments.navigateToServicesList(selectedGroup: selectedGroup)
        self.children.append(payments)
    }
    
    func navigateToTransferView(transfer: AppStructs.TransferTypes) {
        let payments = PaymentsCoordinator(nav: self.nav, accountInfo: self.accountInfo)
        payments.parent = self.parent
        payments.navigateToTransferView(transfer: transfer)
        self.children.append(payments)
    }
    
    func navigateToTransferByNumberView() {
        let payments = PaymentsCoordinator(nav: self.nav, accountInfo: self.accountInfo)
        payments.parent = self.parent
        payments.navigateToTransferByNumberView()
        self.children.append(payments)
    }
    
    func navigateToRates(openConvertor: Bool) {
        let vc = RatesViewController(viewModel: .init(rateService: RatesServiceImpl()))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToShowcaseList() {
        let vc = ShowcaseListViewController(viewModel: .init(service: self.bannerService))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToShowcaseView(showcase: AppStructs.Showcase) {
        let vc = ShowcaseViewController(viewModel: .init(service: self.bannerService), showcase: showcase)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToFavouriteList() {
        let vc = FavouriteListViewController(viewModel: .init(favouriteService: self.favouriteService))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func presentStoriesPreView(stories: [AppStructs.Stories], handPickedStoryIndex: Int) {
        let vc = StoriesViewController(viewModel: .init(service: self.bannerService, stories: stories, handPickedStoryIndex: handPickedStoryIndex))
        vc.coordinator = self
        self.nav.present(vc, animated: true)
    }
    
    func navigateToServiceByFavourite(favourite: AppStructs.Favourite) {
        
    }
    
    func navigateToCardView(userCards: [AppStructs.CreditDebitCard], selectedCard: AppStructs.CreditDebitCard?) {
        if let card = selectedCard {
            let cards = CardsCoordinator(nav: self.nav, accountInfo: self.accountInfo)
            cards.parent = self.parent
            cards.navigateToCardView(userCards: userCards, selectedCard: card)
            self.children.append(cards)
        }
    }
}
