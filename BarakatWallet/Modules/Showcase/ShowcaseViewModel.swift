//
//  ShowcaseViewModel.swift
//  BarakatWallet
//
//  Created by km1tj on 08/11/23.
//

import Foundation
import RxSwift

enum ShowcaseFilter {
    case city(name: String?)
    case category(name: String?)
    case sort(type: ShowcaseSort?)
    
    var text: String {
        switch self {
        case .city(let name):
            return name ?? "CITY".localized
        case .category(let name):
            return name ?? "CATEGORY".localized
        case .sort(let type):
            return type?.text ?? "SORTING_NEWEST".localized
        }
    }
    var isInstaled: Bool {
        switch self {
        case .city(let name):
            return name != nil
        case .category(let name):
            return name != nil
        case .sort(let type):
            return type != nil
        }
    }
    var hasOptions: Bool {
        return true
    }
}

enum ShowcaseSort {
    case newest
    case oldest
    case bigest
    
    var text: String {
        switch self {
        case .newest:return "SORTING_NEWEST".localized
        case .oldest:return "SORTING_OLDEST".localized
        case .bigest:return "SORTING_BIGGEST".localized
        }
    }
}

class ShowcaseViewModel {
    
    let service: BannerService
    let disposeBag = DisposeBag()
    let didShowcaseUpdate = PublishSubject<Void>()
    let didLoadError = PublishSubject<String>()
    
    var showcaseList: [AppStructs.Showcase] = []
    
    init(service: BannerService) {
        self.service = service
    }
    
    func loadShowcaseList() {
        self.service.loadShowcaseList(limit: 20, offset: 0)
            .observe(on: MainScheduler.instance)
            .subscribe { cashbeks in
            self.showcaseList = cashbeks
            self.didShowcaseUpdate.onNext(())
        } onFailure: { error in
            if let error = error as? NetworkError {
                self.didLoadError.onNext((error.message ?? error.error) ?? error.localizedDescription)
            } else {
                self.didLoadError.onNext(error.localizedDescription)
            }
        }.disposed(by: self.disposeBag)
    }
}
