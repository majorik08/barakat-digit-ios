//
//  NotifyViewModel.swift
//  BarakatWallet
//
//  Created by km1tj on 06/11/23.
//

import Foundation
import RxSwift

class NotifyViewModel {
    
    let clientInfo: AppStructs.ClientInfo
    let notifyService: NotifyService
    let disposeBag = DisposeBag()
    let didListUpdate = PublishSubject<Void>()
    let didLoadError = PublishSubject<String>()
    var items: [AppStructs.NotificationNews] = []
    var isLoading: Bool = false
    
    var newsList: [AppStructs.NotificationNews] {
        return self.items.filter({ $0.category == 1 })
    }
    var notifyList: [AppStructs.NotificationNews] {
        return self.items.filter({ $0.category == 2 })
    }
    
    init(clientInfo: AppStructs.ClientInfo, notifyService: NotifyService) {
        self.clientInfo = clientInfo
        self.notifyService = notifyService
    }
    
    func loadNews(reload: Bool) {
        var offset = 0
        if !reload && self.items.count > 0 {
            offset = self.items.count
        }
        if self.isLoading {
            return
        }
        self.isLoading = true
        self.notifyService.loadNews(limit: 20, offset: offset)
            .observe(on: MainScheduler.instance)
            .subscribe { news in
                if reload {
                    self.items = news
                } else {
                    self.items.append(contentsOf: news)
                }
                self.didListUpdate.onNext(())
                self.isLoading = false
        } onFailure: { error in
            self.didLoadError.onNext(error.localizedDescription)
            self.isLoading = false
        }.disposed(by: self.disposeBag)
    }
}
