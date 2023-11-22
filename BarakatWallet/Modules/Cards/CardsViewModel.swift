//
//  CardsViewModel.swift
//  BarakatWallet
//
//  Created by km1tj on 01/11/23.
//

import Foundation

class CardsViewModel {
    
    var availableCardTypes: [AppStructs.CreditDebitCardTypes] = [.init(name: "КАРТА ДЛЯ НАКОПЛЕНИЙ"), .init(name: "КАРТА ДЛЯ РЕБЕНКА"), .init(name: "КРЕДИТНАЯ КАРТА")]
    var availableCardItems: [AppStructs.CreditDebitCardItem] = [.init(name: "Корти Милли"), .init(name: "Корти Милли"), .init(name: "Корти Милли")]
    var userCards: [AppStructs.CreditDebitCard] = [.init(number: "1124 4444 1233 4555"), .init(number: "1124 4444 1233 4555")]
    
    let cardService: CardService
    var showCardInfo: Bool = false
    
    init(cardService: CardService) {
        self.cardService = cardService
    }
}
