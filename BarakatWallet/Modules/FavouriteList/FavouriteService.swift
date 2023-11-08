//
//  FavouriteService.swift
//  BarakatWallet
//
//  Created by km1tj on 08/11/23.
//

import Foundation
import RxSwift

protocol FavouriteService: Service {
    func loadFavouritesList() -> Single<[AppStructs.Favourite]>
}

final class FavouriteServiceImpl: FavouriteService {
    func loadFavouritesList() -> Single<[AppStructs.Favourite]> {
        fatalError()
    }
}
