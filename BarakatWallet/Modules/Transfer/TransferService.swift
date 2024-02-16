//
//  TransferService.swift
//  BarakatWallet
//
//  Created by km1tj on 26/10/23.
//

import Foundation
import RxSwift

protocol TransferService: Service {
    
    func loadNumberInfo(number: String) -> Single<[AppMethods.Transfers.GetNumberInfo.GetNumberInfoResult]>
    func loadTransferData() -> Single<AppMethods.Transfers.GetTransgerData.GetTransgerDataResult>
    func sendTransfer(accountFrom: String, accountTo: String, accountType: AppStructs.AccountType, amountCurrency: Int, phoneNumber: String, serviceID: Int) -> Single<AppMethods.Transfers.TransferSend.TransferSendResult>

}

final class TransferServiceImpl: TransferService {
    
    func loadTransferData() -> Single<AppMethods.Transfers.GetTransgerData.GetTransgerDataResult> {
        return Single<AppMethods.Transfers.GetTransgerData.GetTransgerDataResult>.create { single in
            APIManager.instance.request(.init(AppMethods.Transfers.GetTransgerData(.init())), auth: .noAuth, timeOut: 20) { response in
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
    
    func sendTransfer(accountFrom: String, accountTo: String, accountType: AppStructs.AccountType, amountCurrency: Int, phoneNumber: String, serviceID: Int) -> Single<AppMethods.Transfers.TransferSend.TransferSendResult> {
        return Single<AppMethods.Transfers.TransferSend.TransferSendResult>.create { single in
            APIManager.instance.request(.init(AppMethods.Transfers.TransferSend(.init(accountFrom: accountFrom, accountTo: accountTo, accountType: accountType, amountCurrency: amountCurrency, phoneNumber: phoneNumber, serviceID: serviceID))), auth: .noAuth, timeOut: 20) { response in
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
    
    func loadNumberInfo(number: String) -> Single<[AppMethods.Transfers.GetNumberInfo.GetNumberInfoResult]> {
        return Single<[AppMethods.Transfers.GetNumberInfo.GetNumberInfoResult]>.create { single in
            APIManager.instance.request(.init(AppMethods.Transfers.GetNumberInfo(.init(account: number))), auth: .noAuth, timeOut: 20) { response in
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
