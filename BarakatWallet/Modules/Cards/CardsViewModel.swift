//
//  CardsViewModel.swift
//  BarakatWallet
//
//  Created by km1tj on 01/11/23.
//

import Foundation

class CardsViewModel {
    
    var availableCardTypes = ["КАРТА ДЛЯ НАКОПЛЕНИЙ", "КАРТА ДЛЯ РЕБЕНКА", "КРЕДИТНАЯ КАРТА"]
    var userCards = ["1124  444 1233 4555"]
    
    let cardService: CardService
    
    init(cardService: CardService) {
        self.cardService = cardService
    }
}
