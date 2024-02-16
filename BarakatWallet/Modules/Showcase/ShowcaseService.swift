//
//  ShowcaseService.swift
//  BarakatWallet
//
//  Created by km1tj on 08/11/23.
//

import Foundation
import RxSwift

protocol BannerService: Service {
    func loadShowcaseList(limit: Int, offset: Int) -> Single<[AppStructs.Showcase]>
    func loadBannerList() -> Single<[AppStructs.Banner]>
    func loadStories() -> Single<[AppStructs.Stories]>
}

final class BannerServiceImpl: BannerService {
    
    func loadShowcaseList(limit: Int, offset: Int) -> Single<[AppStructs.Showcase]> {
        return Single.create { single in
            APIManager.instance.request(.init(AppMethods.App.GetCashbeks(.init(limit: limit, offset: offset))), auth: .auth, timeOut: 20) { response in
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
    
    func loadBannerList() -> RxSwift.Single<[AppStructs.Banner]> {
        return Single.create { single in
            APIManager.instance.request(.init(AppMethods.App.GetBanners(.init())), auth: .noAuth, timeOut: 20) { response in
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
    
    func loadStories() -> RxSwift.Single<[AppStructs.Stories]> {
        return Single.create { single in
            APIManager.instance.request(.init(AppMethods.App.GetStories(.init())), auth: .noAuth, timeOut: 20) { response in
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

final class BannerServiceMockImpl: BannerService {
    
    func loadShowcaseList(limit: Int, offset: Int) -> RxSwift.Single<[AppStructs.Showcase]> {
        var showCaseItems: [AppStructs.Showcase] = []
        for i in 0...10 {
            showCaseItems.append(.init(address: "г. Душанбе, ул. Дустии Халкхо 47", cashBack: 10, contacts: [.init(cashID: 0, id: 0, logo: "https://picsum.photos/33/33", text: "fff.com", type: "aaa"), .init(cashID: 1, id: 1, logo: "https://picsum.photos/33/3", text: "kfc.tj", type: "aaa")], description: "На все поLorem Ipsum is simply dummy text of the printing and typesetting industry.", id: i, image: "https://picsum.photos/600/300", lat: 40.2919922, long: 69.6194203, name: "Cashbek na vse", payText: "На все покупки", validityDate: "Unlimit"))
        }
        return .just(showCaseItems).delay(.seconds(1), scheduler: MainScheduler.instance)
    }
    
    func loadBannerList() -> RxSwift.Single<[AppStructs.Banner]> {
        var bannerItems: [AppStructs.Banner] = []
        for i in 0...10 {
            bannerItems.append(.init(id: i, image: "https://picsum.photos/300/300", text: "Banner name", title: "Banner title"))
        }
        return .just(bannerItems).delay(.seconds(1), scheduler: MainScheduler.instance)
    }
    
    func loadStories() -> RxSwift.Single<[AppStructs.Stories]> {
        var storyItems: [AppStructs.Stories] = []
        for i in 0...5 {
            let images: [AppStructs.Stories.Image] = [.init(id: 1, source: "https://picsum.photos/300/900", storyID: i, button: "button", action: "action")]
            storyItems.append(.init(type: 1, id: i, images: images, mainImage: "https://picsum.photos/300/900"))
        }
        return .just(storyItems).delay(.seconds(1), scheduler: MainScheduler.instance)
    }
}
