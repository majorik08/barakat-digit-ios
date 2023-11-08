//
//  ShowcaseService.swift
//  BarakatWallet
//
//  Created by km1tj on 08/11/23.
//

import Foundation
import RxSwift

protocol ShowcaseService: Service {
    func loadShowcaseList() -> Single<[AppStructs.Showcase]>
}

final class ShowcaseServiceImpl: ShowcaseService {
    func loadShowcaseList() -> Single<[AppStructs.Showcase]> {
        fatalError()
    }
}
