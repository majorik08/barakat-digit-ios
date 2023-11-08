//
//  PasscodeViewModel.swift
//  BarakatWallet
//
//  Created by km1tj on 31/10/23.
//

import Foundation
import RxSwift

class PasscodeViewModel {
    
    let disposeBag = DisposeBag()
    let account: CoreAccount
    let passcodeService: PasscodeService
    
    let didLogin = PublishSubject<AppStructs.AccountInfo>()
    let didLoginFailed = PublishSubject<String>()
    
    init(account: CoreAccount, passcodeService: PasscodeService) {
        self.passcodeService = passcodeService
        self.account = account
    }
    
    func pinChechSuccess() {
        self.passcodeService.getClientInfo().flatMap { info -> Single<AppStructs.AccountInfo> in
            return self.passcodeService.getAccount().flatMap { account in
                let accountInfo = AppStructs.AccountInfo(accounts: account, client: info)
                return .just(accountInfo)
            }
        }.observe(on: MainScheduler.instance).subscribe { accountInfo in
            self.didLogin.onNext(accountInfo)
        } onFailure: { error in
            if let error = error as? NetworkError {
                self.didLoginFailed.onNext((error.message ?? error.error) ?? error.localizedDescription)
            } else {
                self.didLoginFailed.onNext(error.localizedDescription)
            }
        }.disposed(by: self.disposeBag)
    }
}
