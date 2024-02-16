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
        return ENVIRONMENT.isMock ? PaymentsServiceMockImpl(accountInfo: self.accountInfo) : PaymentsServiceImpl(accountInfo: self.accountInfo)
    }
    var bannerService: BannerService {
        return ENVIRONMENT.isMock ? BannerServiceMockImpl() : BannerServiceImpl()
    }
    var ratesService: RatesService {
        return ENVIRONMENT.isMock ? RatesServiceMockImpl() : RatesServiceImpl()
    }
    var accountService: AccountService {
        return ENVIRONMENT.isMock ? AccountServiceMockImpl() : AccountServiceImpl()
    }
    var cardService: CardService {
        return CardServiceImpl(accountInfo: self.accountInfo)
    }
    
    init(nav: BaseNavigationController, accountInfo: AppStructs.AccountInfo) {
        self.accountInfo = accountInfo
        self.nav = nav
        self.nav.navigationBar.isHidden = true
    }
    
    func start() {
        let home = HomeViewController(viewModel: .init(accountService: self.accountService, paymentsService: self.paymentsService, bannerService: self.bannerService, ratesService: self.ratesService, accountInfo: self.accountInfo, cardService: self.cardService))
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
    
    func navigateToPayments(fromTransfers: Bool, paymentGroups: [AppStructs.PaymentGroup], transferTypes: [AppStructs.PaymentGroup.ServiceItem], addFavoriteMode: Bool) {
        let payments = PaymentsCoordinator(nav: self.nav, accountInfo: self.accountInfo)
        payments.parent = self.parent
        payments.navigateToServiceGroups(paymentsOrder: fromTransfers ? .firstTransfers : .firstPayments, paymentGroups: paymentGroups, transferTypes: transferTypes, addFavoriteMode: addFavoriteMode, searchMode: false)
        self.children.append(payments)
    }
    
    func navigateToPaymentView(service: AppStructs.PaymentGroup.ServiceItem, merchant: AppStructs.Merchant?, transferParam: String?) {
        let payments = PaymentsCoordinator(nav: self.nav, accountInfo: self.accountInfo)
        payments.parent = self.parent
        payments.navigateToPaymentView(service: service, merchant: merchant, favorite: nil, addFavoriteMode: false, transferParam: transferParam)
        self.children.append(payments)
    }
    
    func navigateToServicesList(selectedGroup: AppStructs.PaymentGroup) {
        let payments = PaymentsCoordinator(nav: self.nav, accountInfo: self.accountInfo)
        payments.parent = self.parent
        payments.navigateToServicesList(selectedGroup: selectedGroup, addFavoriteMode: false)
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
        let vc = FavouriteListViewController(viewModel: .init(service: self.paymentsService))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func presentStoriesPreView(stories: [AppStructs.Stories], handPickedStoryIndex: Int) {
        let vc = StoriesViewController(viewModel: .init(service: self.bannerService, stories: stories, handPickedStoryIndex: handPickedStoryIndex))
        vc.coordinator = self
        self.nav.present(vc, animated: true)
    }
    
    func navigateToServiceByFavourite(favourite: AppStructs.Favourite, service: AppStructs.PaymentGroup.ServiceItem) {
        let payments = PaymentsCoordinator(nav: self.nav, accountInfo: self.accountInfo)
        payments.parent = self.parent
        payments.navigateToPaymentView(service: service, merchant: nil, favorite: favourite, addFavoriteMode: false, transferParam: nil)
        self.children.append(payments)
    }
    
    func navigateToCardView(userCards: [AppStructs.CreditDebitCard], selectedCard: AppStructs.CreditDebitCard?) {
        if let card = selectedCard {
            let cards = CardsCoordinator(nav: self.nav, accountInfo: self.accountInfo)
            cards.parent = self.parent
            cards.navigateToCardView(userCards: userCards, selectedCard: card)
            self.children.append(cards)
        } else {
            self.parent?.tabBar.selectedIndex = 4
            self.parent?.didSelectTabItem(tag: 5)
        }
    }
    
    func navigateToSearchView(paymentGroups: [AppStructs.PaymentGroup], transferTypes: [AppStructs.PaymentGroup.ServiceItem]) {
        let payments = PaymentsCoordinator(nav: self.nav, accountInfo: self.accountInfo)
        payments.parent = self.parent
        payments.navigateToServiceGroups(paymentsOrder: .firstPayments, paymentGroups: paymentGroups, transferTypes: transferTypes, addFavoriteMode: false, searchMode: true)
        self.children.append(payments)
    }
}
