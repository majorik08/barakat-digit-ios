//
//  LoginService.swift
//  BarakatWallet
//
//  Created by km1tj on 26/10/23.
//

import Foundation
import RxSwift

protocol LoginService: Service {
    func sendCode(device: AppStructs.Device, number: String) -> Single<String>
    func validateCode(device: AppStructs.Device, code: String, key: String) -> Single<CoreAccount>
}

final class LoginServiceImpl: LoginService {

    func validateCode(device: AppStructs.Device, code: String, key: String) -> Single<CoreAccount> {
        return Single<CoreAccount>.create { single in
            APIManager.instance.request(.init(AppMethods.Auth.Confirm(.init(device: device, code: code, key: key))), timeOut: 20) { response in
                switch response.result {
                case .success(let result):
                    let account = CoreAccount.login(accountId: "temp", token: result.token, lastSelected: Date().timeIntervalSince1970)
                    single(.success(account))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func sendCode(device: AppStructs.Device, number: String) -> Single<String> {
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
}

final class LoginServiceMockImpl: LoginService {
    
    func sendCode(device: AppStructs.Device, number: String) -> RxSwift.Single<String> {
        return .just("11111")
    }
    
    func validateCode(device: AppStructs.Device, code: String, key: String) -> RxSwift.Single<CoreAccount> {
        if code == "11111" && key == "11111" {
            return .just(.login(accountId: "temp", token: "mock_token", lastSelected: Date().timeIntervalSince1970))
        }
        return Single.error(NetworkError(message: nil, error: "1x003"))
    }
}
