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
    var showcaseService: ShowcaseService {
        return ENVIRONMENT.isMock ? ShowcaseServiceImpl() : ShowcaseServiceImpl()
    }
    var favouriteService: FavouriteService {
        return ENVIRONMENT.isMock ? FavouriteServiceImpl() : FavouriteServiceImpl()
    }
    
    init(nav: BaseNavigationController, accountInfo: AppStructs.AccountInfo) {
        self.accountInfo = accountInfo
        self.nav = nav
        self.nav.navigationBar.isHidden = true
    }
    
    func start() {
        let home = HomeViewController(viewModel: .init(paymentsService: self.paymentsService, showcaseService: self.showcaseService, accountInfo: self.accountInfo))
        home.coordinator = self
        self.nav.viewControllers = [home]
    }
    
    func navigateToProfile() {
        let profile = ProfileCoordinator(nav: self.nav, clientInfo: self.accountInfo.client)
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
    
    func navigateToPayments(fromTransfers: Bool) {
        let payments = PaymentsCoordinator(nav: self.nav, accountInfo: self.accountInfo)
        payments.parent = self.parent
        payments.navigateToServiceGroups(paymentsOrder: fromTransfers ? .firstTransfers : .firstPayments)
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
        let vc = ShowcaseListViewController(viewModel: .init(showcaseService: self.showcaseService))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToShowcaseView(showcase: AppStructs.Showcase) {
        let vc = ShowcaseViewController(viewModel: .init(showcaseService: self.showcaseService), showcase: showcase)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToFavouriteList() {
        let vc = FavouriteListViewController(viewModel: .init(favouriteService: self.favouriteService))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToServiceByFavourite(favourite: AppStructs.Favourite) {
        
    }
    
    func navigateToCardView(card: AppStructs.CreditDebitCard?) {
        
    }
}
