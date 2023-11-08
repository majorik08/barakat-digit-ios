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
    
    func start() {
        if !self.started {
            self.started = true
            let vc = HistoryViewController(viewModel: .init(historyService: self.historyService))
            vc.coordinator = self
            self.nav.viewControllers = [vc]
        }
    }
    
    func navigateToHistoryDetails(item: AppStructs.HistoryItem) {
        let viewModel = HistoryViewModel(historyService: self.historyService)
        viewModel.selectedHistory = item
        let vc = HistoryDetailsViewController(viewModel: viewModel)
        self.nav.pushViewController(vc, animated: true)
    }
}
