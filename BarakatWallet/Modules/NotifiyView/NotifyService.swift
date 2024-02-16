//
//  NotifyService.swift
//  BarakatWallet
//
//  Created by km1tj on 06/11/23.
//

import Foundation
import RxSwift

protocol NotifyService: Service {
    
    var clientInfo: AppStructs.ClientInfo { get }
    
    func loadNews(limit: Int, offset: Int) -> Single<[AppStructs.NotificationNews]>
}

final class NotifyServiceImpl: NotifyService {

    let clientInfo: AppStructs.ClientInfo
    
    init(clientInfo: AppStructs.ClientInfo) {
        self.clientInfo = clientInfo
    }
    
    func loadNews(limit: Int, offset: Int) -> RxSwift.Single<[AppStructs.NotificationNews]> {
        return Single.create { single in
            APIManager.instance.request(.init(AppMethods.App.NotificationsGet(.init(limit: limit, offset: offset))), auth: .auth, timeOut: 20) { response in
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

final class NotifyServiceMockImpl: NotifyService {
   
    let clientInfo: AppStructs.ClientInfo
    
    init(clientInfo: AppStructs.ClientInfo) {
        self.clientInfo = clientInfo
    }
    
    func loadNews(limit: Int, offset: Int) -> RxSwift.Single<[AppStructs.NotificationNews]> {
        return Single.create { single in
            var notifyList: [AppStructs.NotificationNews] = []
            for i in offset..<offset + limit {
                if i / 2 == 0 {
                    notifyList.append(.init(id: i, category: 1, dateTime: Date().description, title: "50 % Кешбек в сети ресторанов KFC Душанбе", text: "Получайте кешбек с каждой оплаты, в кажом ресторане KFC.\nАкция продлится до конца 2023 года.\n\nhttps://www.kfc.tj\nТел.: +992 933160209", image: i / 3 == 0 ? "" : "https://picsum.photos/300/300"))
                } else {
                    notifyList.append(.init(id: i, category: 2, dateTime: Date().description, title: "Пополнение кошелька", text: "Ваш счет был пополнен на 100.00 с.", image: i / 3 == 0 ? "" : "https://picsum.photos/300/300"))
                }
            }
            single(.success(notifyList))
            return Disposables.create()
        }.delay(.seconds(1), scheduler: MainScheduler.instance)
    }
}
