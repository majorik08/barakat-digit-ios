//
//  PaymentService.swift
//  BarakatWallet
//
//  Created by km1tj on 01/11/23.
//

import Foundation
import RxSwift

protocol PaymentsService: Service {
    var accountInfo: AppStructs.AccountInfo { get }
    
    func loadPayments() -> Single<AppMethods.Payments.GetServices.ServicesResult>
    func loadFavorites() -> Single<[AppStructs.Favourite]>
    func addFavorite(account: String, amount: Double, comment: String, params: [String], name: String, serviceID: Int) -> Single<Bool>
    func removeFavorite(id: Int) -> RxSwift.Single<Bool>
    
    func qrCheck(qr: String) -> Single<AppMethods.Payments.QrCheck.CheckResult>
    func loadServiceInfo(service: String, account: String) -> Single<AppMethods.Payments.GetAccountInfo.GetAccountResult>
    func loadNumberInfo(number: String) -> Single<[AppMethods.Payments.GetNumberInfo.GetNumberInfoResult]>
    func verifyPayment(account: String, accountType: AppStructs.AccountType, amount: Double, comment: String, params: [String], serviceID: Int) -> Single<AppMethods.Payments.TransactionVerify.VerifyResult>
    func commitPayment(tranID: String, code: String, key: String) -> Single<AppMethods.Payments.TransactionCommit.Result>
    func verifySendCode(tranID: String) -> Single<AppMethods.Payments.TransactionSendCode.Result>
}

final class PaymentsServiceImpl: PaymentsService {

    var accountInfo: AppStructs.AccountInfo
    
    init(accountInfo: AppStructs.AccountInfo) {
        self.accountInfo = accountInfo
    }
    
    func verifySendCode(tranID: String) -> RxSwift.Single<AppMethods.Payments.TransactionSendCode.Result> {
        return Single<AppMethods.Payments.TransactionSendCode.Result>.create { single in
            APIManager.instance.request(.init(AppMethods.Payments.TransactionSendCode(.init(tranID: tranID))), auth: .auth, timeOut: 20) { response in
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
    
    func commitPayment(tranID: String, code: String, key: String) -> Single<AppMethods.Payments.TransactionCommit.Result> {
        return Single<AppMethods.Payments.TransactionCommit.Result>.create { single in
            APIManager.instance.request(.init(AppMethods.Payments.TransactionCommit(.init(tranID: tranID, code: code, key: key))), auth: .auth, timeOut: 20) { response in
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
    
    func verifyPayment(account: String, accountType: AppStructs.AccountType, amount: Double, comment: String, params: [String], serviceID: Int) -> Single<AppMethods.Payments.TransactionVerify.VerifyResult> {
        return Single<AppMethods.Payments.TransactionVerify.VerifyResult>.create { single in
            APIManager.instance.request(.init(AppMethods.Payments.TransactionVerify(.init(account: account, accountType: accountType, amount: amount, comment: comment, params: params, serviceID: serviceID))), auth: .auth, timeOut: 20) { response in
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
    
    func loadServiceInfo(service: String, account: String) -> RxSwift.Single<AppMethods.Payments.GetAccountInfo.GetAccountResult> {
        return Single<AppMethods.Payments.GetAccountInfo.GetAccountResult>.create { single in
            APIManager.instance.request(.init(AppMethods.Payments.GetAccountInfo(.init(service: service, account: account))), auth: .auth, timeOut: 20) { response in
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
    
    func loadNumberInfo(number: String) -> RxSwift.Single<[AppMethods.Payments.GetNumberInfo.GetNumberInfoResult]> {
        return Single<[AppMethods.Payments.GetNumberInfo.GetNumberInfoResult]>.create { single in
            APIManager.instance.request(.init(AppMethods.Payments.GetNumberInfo(.init(account: number))), auth: .auth, timeOut: 20) { response in
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
    
    func qrCheck(qr: String) -> RxSwift.Single<AppMethods.Payments.QrCheck.CheckResult> {
        return Single<AppMethods.Payments.QrCheck.CheckResult>.create { single in
            APIManager.instance.request(.init(AppMethods.Payments.QrCheck(.init(data: qr))), auth: .auth, timeOut: 20) { response in
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
    
    func loadFavorites() -> RxSwift.Single<[AppStructs.Favourite]> {
        return Single<[AppStructs.Favourite]>.create { single in
            APIManager.instance.request(.init(AppMethods.Client.FavoritesGet(.init())), auth: .auth, timeOut: 20) { response in
                switch response.result {
                case .success(let result):
                    self.accountInfo.favorites = result
                    single(.success(result))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func loadPayments() -> Single<AppMethods.Payments.GetServices.ServicesResult> {
        return Single<AppMethods.Payments.GetServices.ServicesResult>.create { single in
            APIManager.instance.request(.init(AppMethods.Payments.GetServices(.init())), auth: .auth, timeOut: 20) { response in
                switch response.result {
                case .success(let result):
                    self.accountInfo.paymentGroups = result.groups
                    self.accountInfo.transferTypes = result.transfers
                    single(.success(result))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func addFavorite(account: String, amount: Double, comment: String, params: [String], name: String, serviceID: Int) -> RxSwift.Single<Bool> {
        return Single<Bool>.create { single in
            APIManager.instance.request(.init(AppMethods.Client.FavoriteSet(.init(account: account, amount: amount, comment: comment, params: params, name: name, serviceID: serviceID))), auth: .auth, timeOut: 20) { response in
                switch response.result {
                case .success(_):
                    self.accountInfo.favorites.append(.init(id: Int.random(in: 88...999), account: account, amount: amount, comment: comment, params: params, name: name, serviceID: serviceID))
                    self.accountInfo.didUpdateFavorites.onNext(())
                    single(.success(true))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func removeFavorite(id: Int) -> RxSwift.Single<Bool> {
        return Single<Bool>.create { single in
            APIManager.instance.request(.init(AppMethods.Client.FavoriteDelete(.init(id: id))), auth: .auth, timeOut: 20) { response in
                switch response.result {
                case .success(_):
                    if let index = self.accountInfo.favorites.firstIndex(where: { $0.id == id }) {
                        self.accountInfo.favorites.remove(at: index)
                    }
                    self.accountInfo.didUpdateFavorites.onNext(())
                    single(.success(true))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}

final class PaymentsServiceMockImpl: PaymentsService {
   
    var accountInfo: AppStructs.AccountInfo
    
    init(accountInfo: AppStructs.AccountInfo) {
        self.accountInfo = accountInfo
    }
    
    func verifySendCode(tranID: String) -> RxSwift.Single<AppMethods.Payments.TransactionSendCode.Result> {
        fatalError("")
    }
    
    func commitPayment(tranID: String, code: String, key: String) -> RxSwift.Single<AppMethods.Payments.TransactionCommit.Result> {
        fatalError("")
    }
    
    func verifyPayment(account: String, accountType: AppStructs.AccountType, amount: Double, comment: String, params: [String], serviceID: Int) -> RxSwift.Single<AppMethods.Payments.TransactionVerify.VerifyResult> {
        fatalError("")
    }
    
    func loadServiceInfo(service: String, account: String) -> RxSwift.Single<AppMethods.Payments.GetAccountInfo.GetAccountResult> {
        fatalError("")
    }
    
    func removeFavorite(id: Int) -> RxSwift.Single<Bool> {
        return .just((true))
    }
    
    func addFavorite(account: String, amount: Double, comment: String, params: [String], name: String, serviceID: Int) -> RxSwift.Single<Bool> {
        return .just((true))
    }
    
    func loadFavorites() -> RxSwift.Single<[AppStructs.Favourite]> {
        return .just([])
    }
    
    func qrCheck(qr: String) -> RxSwift.Single<AppMethods.Payments.QrCheck.CheckResult> {
        fatalError("")
    }
    
    func loadNumberInfo(number: String) -> RxSwift.Single<[AppMethods.Payments.GetNumberInfo.GetNumberInfoResult]> {
        fatalError()
    }
    
    func loadPayments() -> Single<AppMethods.Payments.GetServices.ServicesResult> {
        let json = """
                    adasdasd
        """
        let decoder = JSONDecoder()
        if let result = try? decoder.decode(AppMethods.Payments.GetServices.ServicesResult.self, from: json.data(using: .utf8)!) {
            return .just(result)
        } else {
            return .error(APIManager.decodeError)
        }
    }
}
