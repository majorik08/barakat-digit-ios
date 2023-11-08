//
//  RatesService.swift
//  BarakatWallet
//
//  Created by km1tj on 08/11/23.
//

import Foundation
import RxSwift

protocol RatesService: Service {
    func loadRates() -> Single<Void>
}

final class RatesServiceImpl: RatesService {
    func loadRates() -> RxSwift.Single<Void> {
        fatalError()
    }
}
