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
        return Single.create { single in
            APIManager.instance.request(.init(AppMethods.App.GetRates(.init())), auth: .auth, timeOut: 20) { response in
                switch response.result {
                case .success(let result):
                    single(.success(result))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}

final class RatesServiceMockImpl: RatesService {
    func loadRates() -> Single<[AppStructs.CurrencyRate]> {
        let rates: [AppStructs.CurrencyRate] = []
//        rates.append(.init(currency: .USD, buy: 10.91, sell: 10.98))
//        rates.append(.init(currency: .EUR, buy: 11.5, sell: 12))
//        rates.append(.init(currency: .RUB, buy: 0.1225, sell: 0.124))
        return .just(rates)
    }
}
