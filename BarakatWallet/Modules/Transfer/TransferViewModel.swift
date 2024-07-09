//
//  TransferViewMode.swift
//  BarakatWallet
//
//  Created by km1tj on 26/10/23.
//

import Foundation
import RxSwift
import UIKit

class TransferViewModel {
    let disposeBag = DisposeBag()
    let service: TransferService
    let bannerService: BannerService
    
    init(service: TransferService, bannerService: BannerService) {
        self.service = service
        self.bannerService = bannerService
    }
    
    func loadNumberServices(number: String) -> Single<[PaymentsViewModel.NumberServiceInfo]> {
        return self.service.loadNumberInfo(number: number)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .flatMap { items -> Single<[PaymentsViewModel.NumberServiceInfo]> in
                if items.isEmpty {
                    return Single.just([])
                } else {
                    let colorObservables = items.map { item in
                        return self.loadColor(imagePath: item.service.image).map { color -> PaymentsViewModel.NumberServiceInfo in
                            return PaymentsViewModel.NumberServiceInfo(accountInfo: item.accountInfo, service: item.service, color: color)
                        }
                    }
                    return Single.zip(colorObservables)
                }
            }.observe(on: MainScheduler.instance)
    }
     
    private func loadColor(imagePath: String) -> Single<UIColor> {
        guard !imagePath.isEmpty else { return Single.just(Theme.current.tintColor) }
        return Single<UIColor>.create { obs in
            APIManager.instance.loadImage(into: nil, filePath: imagePath) { result in
                if let r = result {
                    let colors = r.getColors(quality: .high)
                    obs(.success(colors?.primary ?? Theme.current.secondTintColor))
                } else {
                    obs(.success(Theme.current.secondTintColor))
                }
            }
            return Disposables.create()
        }
    }
}
