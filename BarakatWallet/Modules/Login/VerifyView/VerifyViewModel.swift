//
//  VerifyViewModel.swift
//  BarakatWallet
//
//  Created by km1tj on 26/10/23.
//

import Foundation
import RxSwift
import UIKit

final class VerifyViewModel {
    
    private let service: LoginService
    let key: String
    let phoneNumber: String
    var waitTime: Int = 30
    let disposeBag = DisposeBag()
    let code = BehaviorSubject(value: "")
    
    let didSignIn = PublishSubject<CoreAccount>()
    let didVerifyError = PublishSubject<String>()
    let isSendActive = PublishSubject<Bool>()
    
    init(service: LoginService, phoneNumber: String, key: String) {
        self.service = service
        self.key = key
        self.phoneNumber = phoneNumber
        self.code.map({ $0.count >= 4 }).share(replay: 1).bind(to: self.isSendActive).disposed(by: self.disposeBag)
    }
    
    func verifyTapped(device: AppStructs.Device, code: String) {
        self.service.validateCode(device: device, code: code, key: self.key)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] acc in
                self?.didSignIn.onNext(acc)
            } onFailure: { [weak self] error in
                if let error = error as? NetworkError {
                    self?.didVerifyError.onNext((error.message ?? error.error) ?? error.localizedDescription)
                } else {
                    self?.didVerifyError.onNext(error.localizedDescription)
                }
            }.disposed(by: self.disposeBag)
    }
}
