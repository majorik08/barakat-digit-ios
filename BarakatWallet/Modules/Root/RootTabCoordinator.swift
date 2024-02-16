//
//  RootCoordinator.swift
//  BarakatWallet
//
//  Created by km1tj on 26/10/23.
//

import Foundation
import UIKit
import RxSwift

final class RootTabCoordinator: Coordinator {
    
    enum MainItems: Int {
        case main = 1, history = 2, qr = 3, payments = 4, cards = 5
    }
    weak var parent: AppCoordinator? = nil
    var children: [Coordinator] = []
    var accountInfo: AppStructs.AccountInfo
    var tabBar: RooTabBarViewController
    let disposeBag = DisposeBag()
    
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
    var paymentsService: PaymentsService {
        return ENVIRONMENT.isMock ? PaymentsServiceMockImpl(accountInfo: self.accountInfo) : PaymentsServiceImpl(accountInfo: self.accountInfo)
    }
    
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
    
    func checkQr(qr: String) {
        self.tabBar.showProgressView()
        self.paymentsService.qrCheck(qr: qr)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self = self else { return }
                self.tabBar.hideProgressView()
                self.navigateToQrPayment(merchant: result.merchant, serviceId: result.service, transferParam: result.transferParam)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            self.tabBar.hideProgressView()
            self.tabBar.showErrorAlert(title: "QR", message: error.localizedDescription)
        }.disposed(by: self.disposeBag)
    }
    
    private func navigateToQrPayment(merchant: AppStructs.Merchant?, serviceId: Int, transferParam: String?) {
        let service: AppStructs.PaymentGroup.ServiceItem
        if let _ = merchant {
            service = AppStructs.PaymentGroup.ServiceItem(id: serviceId, name: "QR_OPERATION".localized, image: "", listImage: "", darkImage: "", darkListImage: "", isCheck: 0, params: [])
        } else if let _ = transferParam {
            guard let findService = self.accountInfo.getService(serviceID: serviceId) else {
                self.tabBar.showErrorAlert(title: "QR", message: "Service not found")
                return
            }
            service = findService
        } else {
            self.tabBar.showErrorAlert(title: "QR", message: "Service not found")
            return
        }
        guard let nav = self.tabBar.selectedViewController as? BaseNavigationController else { return }
        guard let item = MainItems(rawValue: nav.tabBarItem.tag) else { return }
        switch item {
        case .main:
            self.mainCoordinator.navigateToPaymentView(service: service, merchant: merchant, transferParam: transferParam)
        case .history:
            self.mainCoordinator.navigateToPaymentView(service: service, merchant: merchant, transferParam: transferParam)
        case .qr:break
        case .payments:
            self.mainCoordinator.navigateToPaymentView(service: service, merchant: merchant, transferParam: transferParam)
        case .cards:
            self.mainCoordinator.navigateToPaymentView(service: service, merchant: merchant, transferParam: transferParam)
        }
    }
}
