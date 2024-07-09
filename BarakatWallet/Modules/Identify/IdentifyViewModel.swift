//
//  IdentifyViewModel.swift
//  BarakatWallet
//
//  Created by km1tj on 30/10/23.
//

import Foundation
import RxSwift

class IdentifyViewModel {
    
    enum PickerType {
    case front
    case back
    case selfie
    }
    
    let disposeBag = DisposeBag()
    let service: IdentifyService
    
    var frontUrl: URL? = nil
    var backUrl: URL? = nil
    var selfieUrl: URL? = nil
    
    let didSetSuccess = PublishSubject<Void>()
    let didSetFailed = PublishSubject<Error?>()
    
    var pickerType: PickerType = .front
    let accountInfo: AppStructs.AccountInfo
    
    init(service: IdentifyService, accountInfo: AppStructs.AccountInfo) {
        self.service = service
        self.accountInfo = accountInfo
    }
    
    func setPhoto(result: URL?) {
        switch self.pickerType {
        case .front:
            self.frontUrl = result
        case .back:
            self.backUrl = result
        case .selfie:
            self.selfieUrl = result
        }
    }
    
    func setIdentify() {
        guard let frontUrl, let backUrl, let selfieUrl else {
            self.didSetFailed.onNext(nil)
            return
        }
        let req: Single<AppMethods.Client.IdentifySet.Result> = self.service.uploadPhoto(url: frontUrl).flatMap { frontResult in
            return self.service.uploadPhoto(url: backUrl).flatMap { backResult in
                return self.service.uploadPhoto(url: selfieUrl).flatMap { selfieResult in
                    return .just((frontResult, backResult, selfieResult))
                }
            }
        }.flatMap { results in
            guard let f = results.0, let b = results.1, let s = results.2 else {
                return .error(APIManager.uploadError)
            }
            return self.service.sendIdentify(front: f, back: b, selfie: s)
        }
        req.subscribe { _ in
            self.didSetSuccess.onNext(())
        } onFailure: { error in
            self.didSetFailed.onNext(error)
        }.disposed(by: self.disposeBag)
    }
}
