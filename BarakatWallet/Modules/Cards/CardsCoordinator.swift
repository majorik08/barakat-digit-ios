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
    
    init(nav: BaseNavigationController, accountInfo: AppStructs.AccountInfo) {
        self.accountInfo = accountInfo
        self.nav = nav
    }
    
    func start() {
        if !self.started {
            self.started = true
            let vc = CardsViewController(viewModel: .init(cardService: CardServiceImpl(clientInfo: self.accountInfo.client)))
            vc.coordinator = self
            self.nav.viewControllers = [vc]
        }
    }
}
