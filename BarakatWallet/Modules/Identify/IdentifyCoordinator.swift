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
    let accountInfo: AppStructs.AccountInfo
    weak var parent: ProfileCoordinator? = nil
    
    init(nav: BaseNavigationController, identifyService: IdentifyService, accountInfo: AppStructs.AccountInfo) {
        self.identifyService = identifyService
        self.nav = nav
        self.accountInfo = accountInfo
    }
    
    func start() {
        let vc = IndentifyMainViewController(viewModel: .init(service: self.identifyService, accountInfo: self.accountInfo), limit: self.accountInfo.client.limit, identify: nil)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToStatusView(identify: AppMethods.Client.IdentifyGet.IdentifyResult?, limit: AppStructs.ClientInfo.Limit) {
        let vc = IndentifyMainViewController(viewModel: .init(service: self.identifyService, accountInfo: self.accountInfo), limit: limit, identify: identify)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
    
    func navigateToVerify() {
        let vc = IdentifyViewController(viewModel: .init(service: self.identifyService, accountInfo: self.accountInfo))
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
    }
}
