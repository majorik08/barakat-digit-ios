//
//  CardService.swift
//  BarakatWallet
//
//  Created by km1tj on 01/11/23.
//

import Foundation
import RxSwift

protocol CardService: Service {
    var clientInfo: AppStructs.ClientInfo { get }
}

final class CardServiceImpl: CardService {
    
    var clientInfo: AppStructs.ClientInfo
    
    init(clientInfo: AppStructs.ClientInfo) {
        self.clientInfo = clientInfo
    }
}
