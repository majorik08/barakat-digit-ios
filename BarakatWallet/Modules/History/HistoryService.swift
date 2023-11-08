//
//  HistoryService.swift
//  BarakatWallet
//
//  Created by km1tj on 01/11/23.
//

import Foundation
import RxSwift

protocol HistoryService: Service {
    var clientInfo: AppStructs.ClientInfo { get }
    
    func getHistoryItems() -> [AppStructs.HistoryItem]
}

final class HistoryServiceImpl: HistoryService {
    
    var clientInfo: AppStructs.ClientInfo
    
    init(clientInfo: AppStructs.ClientInfo) {
        self.clientInfo = clientInfo
    }
    
    func getHistoryItems() -> [AppStructs.HistoryItem] {
        var items = [AppStructs.HistoryItem]()
        for _ in 0...50 {
            items.append(.init(date: Date()))
        }
        return items
    }
}

final class HistoryServiceMockImpl: HistoryService {
    
    var clientInfo: AppStructs.ClientInfo
    
    init(clientInfo: AppStructs.ClientInfo) {
        self.clientInfo = clientInfo
    }
    
    func getHistoryItems() -> [AppStructs.HistoryItem] {
        var items = [AppStructs.HistoryItem]()
        for _ in 0...50 {
            items.append(.init(date: Date()))
        }
        return items
    }
}
