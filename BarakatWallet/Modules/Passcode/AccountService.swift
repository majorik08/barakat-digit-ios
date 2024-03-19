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
    func register(device: AppStructs.Device, number: String) -> Single<String>
    func registerConfirm(device: AppStructs.Device, code: String, key: String) -> Single<AppMethods.Auth.Confirm.Result>
    func registerPin(key: String, pin: String, wallet: String) -> Single<CoreAccount>
    func registerResend(key: String) -> Single<AppMethods.Auth.Resend.Result>
    func signIn(pin: String) -> Single<AppMethods.Auth.SignIn.Result>
    func signInConfirm(code: String) -> Single<AppMethods.Auth.SignConfirm.Result>
    func resetPin(key: String) -> Single<AppMethods.Auth.ResetPin.Result>
    func resetPinConfirm(key: String, code: String) -> Single<AppMethods.Auth.ResetConfirm.Result>
}

final class AccountServiceImpl: AccountService {
    
    func register(device: AppStructs.Device, number: String) -> Single<String> {
        return Single<String>.create { single in
            APIManager.instance.request(.init(AppMethods.Auth.Register(.init(device: device, wallet: number))), timeOut: 20) { response in
                switch response.result {
                case .success(let result):
                    single(.success(result.key))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func registerConfirm(device: AppStructs.Device, code: String, key: String) -> Single<AppMethods.Auth.Confirm.Result> {
        return Single<AppMethods.Auth.Confirm.Result>.create { single in
            APIManager.instance.request(.init(AppMethods.Auth.Confirm(.init(device: device, code: code, key: key))), timeOut: 20) { response in
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
    
    func registerResend(key: String) -> Single<AppMethods.Auth.Resend.Result> {
        return Single<AppMethods.Auth.Resend.Result>.create { single in
            APIManager.instance.request(.init(AppMethods.Auth.Resend(.init(key: key))), timeOut: 20) { response in
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
  
    func registerPin(key: String, pin: String, wallet: String) -> Single<CoreAccount> {
        return Single<CoreAccount>.create { single in
            APIManager.instance.request(.init(AppMethods.Auth.SetPin(.init(pin: pin, key: key))), timeOut: 20) { response in
                switch response.result {
                case .success(let result):
                    let account = CoreAccount.login(accountId: "temp", token: result.token, pin: pin, wallet: wallet, lastSelected: Date().timeIntervalSince1970)
                    single(.success(account))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }

    func signIn(pin: String) -> Single<AppMethods.Auth.SignIn.Result> {
        return Single<AppMethods.Auth.SignIn.Result>.create { single in
            APIManager.instance.request(.init(AppMethods.Auth.SignIn(.init(pin: pin))), auth: .auth, timeOut: 20) { response in
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
    
    func signInConfirm(code: String) -> Single<AppMethods.Auth.SignConfirm.Result> {
        return Single<AppMethods.Auth.SignConfirm.Result>.create { single in
            APIManager.instance.request(.init(AppMethods.Auth.SignConfirm(.init(token: code))), auth: .auth, timeOut: 20) { response in
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
    
    func resetPin(key: String) -> Single<AppMethods.Auth.ResetPin.Result> {
        return Single<AppMethods.Auth.ResetPin.Result>.create { single in
            APIManager.instance.request(.init(AppMethods.Auth.ResetPin(.init(key: key))), auth: .noAuth, timeOut: 20) { response in
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
    
    func resetPinConfirm(key: String, code: String) -> Single<AppMethods.Auth.ResetConfirm.Result> {
        return Single<AppMethods.Auth.ResetConfirm.Result>.create { single in
            APIManager.instance.request(.init(AppMethods.Auth.ResetConfirm(.init(token: code, key: key))), auth: .noAuth, timeOut: 20) { response in
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
//
//final class AccountServiceMockImpl: AccountService {
//
//    func validateCode(device: AppStructs.Device, code: String, key: String) -> RxSwift.Single<AppMethods.Auth.Confirm.Result> {
//        return Single.just(AppMethods.Auth.Confirm.Result(walletExist: true))
//        //return Single.error(NetworkError(message: nil, error: "1x003"))
//    }
//
//    func setPin(key: String, pin: Int) -> RxSwift.Single<CoreAccount> {
//        return Single.just(CoreAccount.login(accountId: "temp", token: "result.token", pin: pin, lastSelected: Date().timeIntervalSince1970))
//        //return Single.error(NetworkError(message: nil, error: "1x003"))
//    }
//
//    func sendCode(device: AppStructs.Device, number: String) -> RxSwift.Single<String> {
//        return .just("11111")
//    }
//
//    func logout() -> RxSwift.Single<AppMethods.Client.Logout.Result> {
//        fatalError()
//    }
//
//    func getHelp() -> RxSwift.Single<AppMethods.App.GetHelp.GetHelpResult> {
//        fatalError()
//    }
//
//    func getClientInfo() -> Single<AppStructs.ClientInfo> {
//        return .just(.init(avatar: "", birthDate: "", email: "", firstName: "", gender: "", id: 1, inn: "", lastName: "", midName: "", pushNotify: true, smsPush: false, statusID: 1, wallet: "+992987010395", limit: .init(QRPayment: true, SummaOnMonth: 0, cardOrder: true, cashing: true, convert: true, creditControl: true, id: 0, maxInWallet: 0, name: "Name", payment: true, transfer: true)))
//    }
//
//    func getAccount() -> Single<[AppStructs.Account]> {
//        return .just([.init(account: "", bal_account: "", closingBalance: 0, name: "", overDraft: 1, reserve: 1)])
//    }
//}
