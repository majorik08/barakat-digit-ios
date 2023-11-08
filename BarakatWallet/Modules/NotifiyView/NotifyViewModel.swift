//
//  NotifyViewModel.swift
//  BarakatWallet
//
//  Created by km1tj on 06/11/23.
//

import Foundation

class NotifyViewModel {
    
    let clientInfo: AppStructs.ClientInfo
    let notifyService: NotifyService
    
    init(clientInfo: AppStructs.ClientInfo, notifyService: NotifyService) {
        self.clientInfo = clientInfo
        self.notifyService = notifyService
    }
}
