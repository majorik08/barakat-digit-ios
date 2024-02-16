//
//  PaymentsViewModel.swift
//  BarakatWallet
//
//  Created by km1tj on 01/11/23.
//

import Foundation
import RxSwift
import UIKit

class PaymentsViewModel {
    
    let disposeBag = DisposeBag()
    let accountInfo: AppStructs.AccountInfo
    let service: PaymentsService
    let historyService: HistoryService
    
    let didLoadPayments = PublishSubject<Void>()
    let didAddFavorite = PublishSubject<Void>()
    
    let didLoadServiceInfo = PublishSubject<String>()
    let didPaymentVerified = PublishSubject<AppMethods.Payments.TransactionVerify.VerifyResult>()
    let didPaymentCommit = PublishSubject<Void>()
    
    let didLoadPaymentsError = PublishSubject<String>()
    let didAddFavoriteError = PublishSubject<String>()
    
    var paymentGroups: [AppStructs.PaymentGroup] {
        return self.accountInfo.paymentGroups
    }
    var transferTypes: [AppStructs.PaymentGroup.ServiceItem] {
        return self.accountInfo.transferTypes
    }
    
    var sumParam: AppStructs.PaymentGroup.ServiceItem.Params {
        return .init(id: -999, name: "SUMMA".localized, coment: "SUMMA_HINT".localized, keyboard: 0, mask: "", maxLen: 10, minLen: 1, param: 0, prefix: "")
    }
    var messageParam: AppStructs.PaymentGroup.ServiceItem.Params {
        return .init(id: -998, name: "MESSAGE_FOR_RECEIVER".localized, coment: "MESSAGE".localized, keyboard: 0, mask: "", maxLen: 255, minLen: 0, param: 0, prefix: "")
    }
    
    init(service: PaymentsService, historyService: HistoryService, accountInfo: AppStructs.AccountInfo) {
        self.service = service
        self.historyService = historyService
        self.accountInfo = accountInfo
    }
    
    func loadPayments() {
        self.service.loadPayments()
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.didLoadPayments.onNext(())
        } onFailure: { error in
            if let error = error as? NetworkError {
                self.didLoadPaymentsError.onNext((error.message ?? error.error) ?? error.localizedDescription)
            } else {
                self.didLoadPaymentsError.onNext(error.localizedDescription)
            }
        }.disposed(by: self.disposeBag)
    }
    
    func addFavorite(account: String, amount: Double, comment: String, params: [String], name: String, serviceID: Int) {
        self.service.addFavorite(account: account, amount: amount, comment: comment, params: params, name: name, serviceID: serviceID).observe(on: MainScheduler.instance)
            .subscribe { result in
                self.didAddFavorite.onNext(())
        } onFailure: { error in
            if let error = error as? NetworkError {
                self.didAddFavoriteError.onNext((error.message ?? error.error) ?? error.localizedDescription)
            } else {
                self.didAddFavoriteError.onNext(error.localizedDescription)
            }
        }.disposed(by: self.disposeBag)
    }
    
    func checkServiceInfo(service: String, account: String) {
        self.service.loadServiceInfo(service: service, account: account)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.didLoadServiceInfo.onNext(result)
        } onFailure: { error in
            if let error = error as? NetworkError {
                self.didLoadPaymentsError.onNext((error.message ?? error.error) ?? error.localizedDescription)
            } else {
                self.didLoadPaymentsError.onNext(error.localizedDescription)
            }
        }.disposed(by: self.disposeBag)
    }
    
    func verifyPayment(account: String, accountType: AppStructs.AccountType, amount: Double, comment: String, params: [String], serviceID: Int) {
        self.service.verifyPayment(account: account, accountType: accountType, amount: amount, comment: comment, params: params, serviceID: serviceID)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.didPaymentVerified.onNext(result)
        } onFailure: { error in
            if let error = error as? NetworkError {
                self.didLoadPaymentsError.onNext((error.message ?? error.error) ?? error.localizedDescription)
            } else {
                self.didLoadPaymentsError.onNext(error.localizedDescription)
            }
        }.disposed(by: self.disposeBag)
    }
    
    func commitPayment(tranID: String, code: String, key: String) {
        self.service.commitPayment(tranID: tranID, code: code, key: key)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.didPaymentCommit.onNext(())
        } onFailure: { error in
            if let error = error as? NetworkError {
                self.didLoadPaymentsError.onNext((error.message ?? error.error) ?? error.localizedDescription)
            } else {
                self.didLoadPaymentsError.onNext(error.localizedDescription)
            }
        }.disposed(by: self.disposeBag)
    }
    
    func loadNumberServices(number: String) -> Single<[NumberServiceInfo]> {
        return self.service.loadNumberInfo(number: number)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .flatMap { items -> Single<[NumberServiceInfo]> in
                let colorObservables = items.map { item in
                    return self.loadColor(imagePath: item.service.image).map { color -> NumberServiceInfo in
                        return NumberServiceInfo(accountInfo: item.accountInfo, service: item.service, color: color)
                    }
                }
                return Single.zip(colorObservables)
            }.observe(on: MainScheduler.instance)
    }
    
    struct NumberServiceInfo {
        let accountInfo: String
        let service: AppStructs.PaymentGroup.ServiceItem
        let color: UIColor
    }
    
    private func loadColor(imagePath: String) -> Single<UIColor> {
        return Single<UIColor>.create { obs in
            APIManager.instance.loadImage(into: nil, filePath: imagePath) { result in
                if let r = result {
                    let colors = r.getColors(quality: .high)
                    obs(.success(colors?.primary ?? Theme.current.tintColor))
                } else {
                    obs(.success(Theme.current.tintColor))
                }
            }
            return Disposables.create()
        }
    }
}
