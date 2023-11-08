//
//  NotifyCoordinator.swift
//  BarakatWallet
//
//  Created by km1tj on 06/11/23.
//

import Foundation

class NotifyCoordinator: Coordinator {
    
    var children: [Coordinator] = []
    let nav: BaseNavigationController
    weak var parent: HomeCoordinator? = nil
    
    let clientInfo: AppStructs.ClientInfo
    
    var notifyService: NotifyService {
        return ENVIRONMENT.isMock ? NotifyServiceMockImpl(clientInfo: self.clientInfo) : NotifyServiceImpl(clientInfo: self.clientInfo)
    }
    
    init(nav: BaseNavigationController, clientInfo: AppStructs.ClientInfo) {
        self.nav = nav
        self.clientInfo = clientInfo
    }
    
    func start() {
        let vc = NotifyListViewController(viewModel: .init(clientInfo: self.clientInfo, notifyService: self.notifyService))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
}
