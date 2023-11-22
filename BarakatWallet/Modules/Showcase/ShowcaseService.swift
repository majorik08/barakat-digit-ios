//
//  ShowcaseService.swift
//  BarakatWallet
//
//  Created by km1tj on 08/11/23.
//

import Foundation
import RxSwift

protocol BannerService: Service {
    func loadShowcaseList() -> Single<[AppStructs.Showcase]>
    func loadBannerList() -> Single<[AppStructs.Banner]>
    func loadStories() -> Single<[AppStructs.Stories]>
}

final class BannerServiceImpl: BannerService {
    
    func loadShowcaseList() -> Single<[AppStructs.Showcase]> {
        return Single.create { single in
            APIManager.instance.request(.init(AppMethods.App.GetCashbeks(.init())), auth: .auth, timeOut: 20) { response in
                switch response.result {
                case .success(let result):
                    if let first = result.first {
                        single(.success(first))
                    } else {
                        single(.failure(APIManager.decodeError))
                    }
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func loadBannerList() -> RxSwift.Single<[AppStructs.Banner]> {
        return Single.create { single in
            APIManager.instance.request(.init(AppMethods.App.GetBanners(.init())), auth: .noAuth, timeOut: 20) { response in
                switch response.result {
                case .success(let result):
                    if let first = result.first {
                        single(.success(first))
                    } else {
                        single(.failure(APIManager.decodeError))
                    }
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func loadStories() -> RxSwift.Single<[AppStructs.Stories]> {
        return Single.create { single in
            APIManager.instance.request(.init(AppMethods.App.GetStories(.init())), auth: .noAuth, timeOut: 20) { response in
                switch response.result {
                case .success(let result):
                    if let first = result.first {
                        single(.success(first))
                    } else {
                        single(.failure(APIManager.decodeError))
                    }
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}

final class BannerServiceMockImpl: BannerService {
    
    func loadShowcaseList() -> RxSwift.Single<[AppStructs.Showcase]> {
        var showCaseItems: [AppStructs.Showcase] = []
        for i in 0...10 {
            showCaseItems.append(.init(address: "Address", cashBack: 10, contacts: [], description: "Cashbek description", id: i, image: "", lat: 0, long: 0, name: "Cashbek name", payText: "Pay text", validityDate: "Unlimit"))
        }
        return .just(showCaseItems)
    }
    
    func loadBannerList() -> RxSwift.Single<[AppStructs.Banner]> {
        var bannerItems: [AppStructs.Banner] = []
        for i in 0...10 {
            bannerItems.append(.init(id: i, image: "https://picsum.photos/300/300", text: "Banner name", title: "Banner title"))
        }
        return .just(bannerItems)
    }
    
    func loadStories() -> RxSwift.Single<[AppStructs.Stories]> {
        var storyItems: [AppStructs.Stories] = []
        for i in 0...5 {
            let images: [AppStructs.Stories.Image] = [.init(id: 1, source: "https://picsum.photos/300/900", storyID: i), .init(id: 2, source: "https://picsum.photos/300/800", storyID: i), .init(id: 3, source: "https://picsum.photos/300/700", storyID: i)]
            storyItems.append(.init(action: "action", button: "button", type: 1, id: i, images: images))
        }
        return .just(storyItems)
    }
}
