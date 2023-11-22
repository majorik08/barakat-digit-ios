//
//  RatesService.swift
//  BarakatWallet
//
//  Created by km1tj on 08/11/23.
//

import Foundation
import RxSwift

protocol RatesService: Service {
    func loadRates() -> Single<[AppStructs.CurrencyRate]>
}

final class RatesServiceImpl: RatesService {
    
    func loadRates() -> Single<[AppStructs.CurrencyRate]> {
        var rates: [AppStructs.CurrencyRate] = []
        rates.append(.init(currencyOne: .TJS, currencyTwo: .RUB, rate: 1.3))
        rates.append(.init(currencyOne: .TJS, currencyTwo: .USD, rate: 1.1))
        rates.append(.init(currencyOne: .TJS, currencyTwo: .EUR, rate: 1.3))
        return .just(rates)
    }
}

final class RatesServiceMockImpl: RatesService {
    func loadRates() -> Single<[AppStructs.CurrencyRate]> {
        var rates: [AppStructs.CurrencyRate] = []
        rates.append(.init(currencyOne: .TJS, currencyTwo: .RUB, rate: 1.3))
        rates.append(.init(currencyOne: .TJS, currencyTwo: .USD, rate: 1.1))
        rates.append(.init(currencyOne: .TJS, currencyTwo: .EUR, rate: 1.3))
        return .just(rates)
    }
}
