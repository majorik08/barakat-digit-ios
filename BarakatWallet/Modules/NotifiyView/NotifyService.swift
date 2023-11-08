//
//  NotifyService.swift
//  BarakatWallet
//
//  Created by km1tj on 06/11/23.
//

import Foundation
import RxSwift

protocol NotifyService: Service {
    
    var clientInfo: AppStructs.ClientInfo { get }
}

final class NotifyServiceImpl: NotifyService {
    
    let clientInfo: AppStructs.ClientInfo
    
    init(clientInfo: AppStructs.ClientInfo) {
        self.clientInfo = clientInfo
    }
}

final class NotifyServiceMockImpl: NotifyService {
    
    let clientInfo: AppStructs.ClientInfo
    
    init(clientInfo: AppStructs.ClientInfo) {
        self.clientInfo = clientInfo
    }
}
