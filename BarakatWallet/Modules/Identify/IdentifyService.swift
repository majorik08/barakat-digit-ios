//
//  IdentifyService.swift
//  BarakatWallet
//
//  Created by km1tj on 30/10/23.
//

import Foundation
import RxSwift

protocol IdentifyService: Service {
    func uploadPhoto(url: URL) -> Single<String?>
    func sendIdentify(front: String, back: String, selfie: String) -> Single<AppMethods.Client.IdentifySet.Result>
    func getIdentify() -> Single<AppMethods.Client.IdentifyGet.IdentifyResult>
    func getLimits() -> Single<[AppStructs.ClientInfo.Limit]>
}

final class IdentifyServiceImpl: IdentifyService {
    
    func uploadPhoto(url: URL) -> RxSwift.Single<String?> {
        return Single.create { single in
            APIManager.instance.startUpload(file: url) { response in
                single(.success(response))
            }
            return Disposables.create()
        }
    }
    
    func sendIdentify(front: String, back: String, selfie: String) -> Single<AppMethods.Client.IdentifySet.Result> {
        return Single.create { single in
            APIManager.instance.request(.init(AppMethods.Client.IdentifySet(.init(front: front, rear: back, selfie: selfie, status: 0))), auth: .auth) { response in
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
    
    func getIdentify() -> RxSwift.Single<AppMethods.Client.IdentifyGet.IdentifyResult> {
        return Single.create { single in
            APIManager.instance.request(.init(AppMethods.Client.IdentifyGet(.init())), auth: .auth) { response in
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
    
    func getLimits() -> RxSwift.Single<[AppStructs.ClientInfo.Limit]> {
        return Single.create { single in
            APIManager.instance.request(.init(AppMethods.Client.IdentifyLimitsGet(.init())), auth: .auth) { response in
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
