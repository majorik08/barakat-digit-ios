//
//  RootCoordinator.swift
//  BarakatWallet
//
//  Created by km1tj on 26/10/23.
//

import Foundation
import UIKit

final class RootTabCoordinator: Coordinator {
    
    enum MainItems: Int {
        case main = 1, history = 2, qr = 3, payments = 4, cards = 5
    }
    weak var parent: AppCoordinator? = nil
    var children: [Coordinator] = []
    var accountInfo: AppStructs.AccountInfo
    var tabBar: RooTabBarViewController
    
    lazy var mainCoordinator: HomeCoordinator = {
        return HomeCoordinator(nav: BaseNavigationController(title: "MAIN".localized, image: UIImage(name: .tab_home), tag: MainItems.main.rawValue), accountInfo: self.accountInfo)
    }()
    lazy var historyCoordinator: HistoryCoordinator = {
        return HistoryCoordinator(nav: BaseNavigationController(title: "HISTORY".localized, image: UIImage(name: .tab_history), tag: MainItems.history.rawValue), accountInfo: self.accountInfo)
    }()
    lazy var qrCoordinator: QrCoordinator = {
        return QrCoordinator(nav: BaseNavigationController(title: nil, image: UIImage(name: .tab_qr), tag: MainItems.qr.rawValue), accountInfo: self.accountInfo)
    }()
    lazy var paymentsCoordinator: PaymentsCoordinator = {
        return PaymentsCoordinator(nav: BaseNavigationController(title: "PAYMENTS".localized, image: UIImage(name: .tab_payments), tag: MainItems.payments.rawValue), accountInfo: self.accountInfo)
    }()
    lazy var cardsCoordinator: CardsCoordinator = {
        return CardsCoordinator(nav: BaseNavigationController(title: "CARDS".localized, image: UIImage(name: .tab_cards), tag: MainItems.cards.rawValue), accountInfo: self.accountInfo)
    }()
    
    init(accountInfo: AppStructs.AccountInfo) {
        self.accountInfo = accountInfo
        self.tabBar = RooTabBarViewController(overrideInterfaceStyle: false)
        self.tabBar.coordinator = self
    }
    
    func start() {
        let items: [MainItems] = [.main, .history, .qr, .payments, .cards]
        var vcs: [UIViewController] = []
        for item in items {
            switch item {
            case .main:
                self.mainCoordinator.parent = self
                self.mainCoordinator.start()
                vcs.append(self.mainCoordinator.nav)
            case .history:
                self.historyCoordinator.parent = self
                vcs.append(self.historyCoordinator.nav)
            case .qr:
                self.qrCoordinator.parent = self
                vcs.append(self.qrCoordinator.nav)
            case .payments:
                self.paymentsCoordinator.parent = self
                vcs.append(self.paymentsCoordinator.nav)
            case .cards:
                self.cardsCoordinator.parent = self
                vcs.append(self.cardsCoordinator.nav)
            }
        }
        self.tabBar.setViewControllers(vcs, animated: false)
    }
    
    func canShowTabItemController(tag: Int) -> Bool {
        if tag == MainItems.qr.rawValue {
            self.qrCoordinator.start()
            return false
        }
        return true
    }
    
    func didSelectTabItem(tag: Int) {
        guard let item = MainItems(rawValue: tag) else { return }
        switch item {
        case .main:break
        case .history:
            self.historyCoordinator.start()
        case .qr:
            self.qrCoordinator.start()
        case .payments:
            self.paymentsCoordinator.start()
        case .cards:
            self.cardsCoordinator.start()
        }
    }
}
