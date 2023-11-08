//
//  IdentifyCoordinator.swift
//  BarakatWallet
//
//  Created by km1tj on 30/10/23.
//

import Foundation

class IdentifyCoordinator: Coordinator {
    
    var children: [Coordinator] = []
    let nav: BaseNavigationController
    let identifyService: IdentifyService
    weak var parent: ProfileCoordinator? = nil
    
    init(nav: BaseNavigationController, identifyService: IdentifyService) {
        self.identifyService = identifyService
        self.nav = nav
    }
    
    func start() {
        let vc = IndentifyMainViewController(viewModel: .init(service: self.identifyService))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToVerify() {
        let vc = IdentifyViewController(viewModel: .init(service: self.identifyService))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
}
