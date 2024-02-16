//
//  HistoryService.swift
//  BarakatWallet
//
//  Created by km1tj on 01/11/23.
//

import Foundation
import RxSwift

protocol HistoryService: Service {
    var clientInfo: AppStructs.ClientInfo { get }
    func loadEntries() -> Single<[AppStructs.EntryItem]>
    func getHistoryById(tranId: String) -> Single<AppStructs.HistoryItem>
    func getHistoryItems(account: String?, amountFrom: Double?, amountTo: Double?, dateFrom: String?, dateTo: String?, expenses: Bool?, incoming: Bool?, type: Int?, limit: Int, offset: Int) -> Single<[AppStructs.HistoryItem]>
}

final class HistoryServiceImpl: HistoryService {
   
    var clientInfo: AppStructs.ClientInfo
    
    init(clientInfo: AppStructs.ClientInfo) {
        self.clientInfo = clientInfo
    }
    
    func loadEntries() -> RxSwift.Single<[AppStructs.EntryItem]> {
        return Single<[AppStructs.EntryItem]>.create { single in
            APIManager.instance.request(.init(AppMethods.Acccount.GetEntries(.init())), auth: .auth, timeOut: 20) { response in
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
    
    func getHistoryItems(account: String?, amountFrom: Double?, amountTo: Double?, dateFrom: String?, dateTo: String?, expenses: Bool?, incoming: Bool?, type: Int?, limit: Int, offset: Int) -> RxSwift.Single<[AppStructs.HistoryItem]> {
        let req = AppMethods.Acccount.GetHistory(.init(account: account, amountFrom: amountFrom, amountTo: amountTo, dateFrom: dateFrom, dateTo: dateTo, expenses: expenses, incoming: incoming, type: type, limit: limit, offset: offset))
        return Single<[AppStructs.HistoryItem]>.create { single in
            APIManager.instance.request(.init(req), auth: .auth, timeOut: 20) { response in
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
    
    func getHistoryById(tranId: String) -> Single<AppStructs.HistoryItem> {
        let req = AppMethods.Acccount.GetHistoryById(.init(tranId: tranId))
        return Single<AppStructs.HistoryItem>.create { single in
            APIManager.instance.request(.init(req), auth: .auth, timeOut: 20) { response in
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

final class HistoryServiceMockImpl: HistoryService {
    
    var clientInfo: AppStructs.ClientInfo
    
    var date = Date()
    
    init(clientInfo: AppStructs.ClientInfo) {
        self.clientInfo = clientInfo
    }
    
    func loadEntries() -> RxSwift.Single<[AppStructs.EntryItem]> {
        return Single<[AppStructs.EntryItem]>.create { single in
            var items = [AppStructs.EntryItem]()
            items.append(.init(id: 0, name: "PAYMENT_OPERATION".localized))
            items.append(.init(id: 1, name: "QR_OPERATION".localized))
            items.append(.init(id: 2, name: "TRANSFER_TO_NUMBER_OPERATION".localized))
            items.append(.init(id: 3, name: "TRANSFER_TO_CARD_OPERATION".localized))
            items.append(.init(id: 4, name: "TRANSFER_TO_ABROAD".localized))
            single(.success(items))
            return Disposables.create()
        }
    }
    
    func getHistoryById(tranId: String) -> Single<AppStructs.HistoryItem> {
        fatalError("dd")
    }
    
    func getHistoryItems(account: String?, amountFrom: Double?, amountTo: Double?, dateFrom: String?, dateTo: String?, expenses: Bool?, incoming: Bool?, type: Int?, limit: Int, offset: Int) -> RxSwift.Single<[AppStructs.HistoryItem]> {
        return Single<[AppStructs.HistoryItem]>.create { single in
            var items = [AppStructs.HistoryItem]()
            /// generate random demo AppStructs.HistoryItem by limit and offset parameters
            for i in offset..<offset + limit {
                items.append(.init(accountFrom: "AccountFrom", accountTo: "AccountTo", admission: 0, amount: Double.random(in: 1...9999), commission: 1, datetime: DateUtils.stringFullDateTime(date: self.date), service: "\(Int.random(in: 55...111))", status: Int.random(in: 0...1), tran_id: "\(i)"))
            }
            self.date = Date(timeIntervalSince1970: self.date.timeIntervalSince1970 - (3600 * 24))
            single(.success(items))
            return Disposables.create()
        }
    }
}
