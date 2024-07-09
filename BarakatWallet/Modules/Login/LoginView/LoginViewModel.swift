//
//  LoginViewModel.swift
//  BarakatWallet
//
//  Created by km1tj on 05/10/23.
//

import Foundation
import RxSwift

final class LoginViewModel {
    
    let service: AccountService
    
    let disposeBag = DisposeBag()
    let phoneNumber = BehaviorSubject(value: "")
    let privacyCheck = BehaviorSubject(value: true)
    
    let didSendCode = PublishSubject<String>()
    let didSendError = PublishSubject<Error>()
    let isSendActive = PublishSubject<Bool>()
    
    init(service: AccountService) {
        self.service = service
        let validNumber = self.phoneNumber.map({ $0.count > 7 }).share(replay: 1)
        let validCheck = self.privacyCheck.share(replay: 1)
        let enableButton = Observable.combineLatest(validNumber, validCheck) { $0 && $1 }.share(replay: 1)
        enableButton.bind(to: self.isSendActive).disposed(by: self.disposeBag)
    }
    
    func signInTapped(device: AppStructs.Device, number: String) {
        self.service.register(device: device, number: number)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] key in
                self?.didSendCode.onNext(key)
            } onFailure: { [weak self] error in
                self?.didSendError.onNext(error)
            }.disposed(by: self.disposeBag)
    }
}
