//
//  PasscodeService.swift
//  BarakatWallet
//
//  Created by km1tj on 31/10/23.
//

import Foundation
import RxSwift

protocol AccountService: Service {
    func getClientInfo() -> Single<AppStructs.ClientInfo>
    func getAccount() -> Single<[AppStructs.Account]>
    func getHelp() -> Single<AppMethods.App.GetHelp.GetHelpResult>
    func logout() -> Single<AppMethods.Client.Logout.Result>
}

final class AccountServiceImpl: AccountService {
  
    
    func getClientInfo() -> Single<AppStructs.ClientInfo> {
        return Single<AppStructs.ClientInfo>.create { single in
            APIManager.instance.request(.init(AppMethods.Client.Info(.init())), auth: .auth, timeOut: 20) { response in
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
    
    func getAccount() -> Single<[AppStructs.Account]> {
        return Single<[AppStructs.Account]>.create { single in
            APIManager.instance.request(.init(AppMethods.Acccount.Accounts(.init())), auth: .auth, timeOut: 20) { response in
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
    
    func getHelp() -> RxSwift.Single<AppMethods.App.GetHelp.GetHelpResult> {
        return Single<AppMethods.App.GetHelp.GetHelpResult>.create { single in
            APIManager.instance.request(.init(AppMethods.App.GetHelp(.init())), auth: .noAuth) { response in
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
    
    func logout() -> RxSwift.Single<AppMethods.Client.Logout.Result> {
        return Single<AppMethods.Client.Logout.Result>.create { single in
            APIManager.instance.request(.init(AppMethods.Client.Logout(.init())), auth: .auth) { response in
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

final class AccountServiceMockImpl: AccountService {
    
    func logout() -> RxSwift.Single<AppMethods.Client.Logout.Result> {
        fatalError()
    }
    
    func getHelp() -> RxSwift.Single<AppMethods.App.GetHelp.GetHelpResult> {
        fatalError()
    }
    
    func getClientInfo() -> Single<AppStructs.ClientInfo> {
        return .just(.init(avatar: "", birthDate: "", email: "", firstName: "", gender: "", id: 1, inn: "", lastName: "", midName: "", pushNotify: true, smsPush: false, statusID: 1, wallet: "+992987010395", limit: .init(QRPayment: true, SummaOnMonth: 0, cardOrder: true, cashing: true, convert: true, creditControl: true, id: 0, maxInWallet: 0, name: "Name", payment: true, transfer: true)))
    }
    
    func getAccount() -> Single<[AppStructs.Account]> {
        return .just([.init(account: "", bal_account: "", closingBalance: 0, name: "", overDraft: 1, reserve: 1)])
    }
}
