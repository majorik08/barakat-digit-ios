//
//  PasscodeViewModel.swift
//  BarakatWallet
//
//  Created by km1tj on 31/10/23.
//

import Foundation
import RxSwift

class PasscodeViewModel {
    
    enum StartFor {
        case setup
        case change(old: String)
        case check(pin: String)
        
        var passcode: String {
            switch self {
            case .setup: return ""
            case .change(old: let old): return old
            case .check(pin: let pin): return pin
            }
        }
    }
    enum SetupSteps {
        case check
        case first
        case second(new: String)
        var isFirst: Bool {
            switch self {
            case .first:return true
            default: return false
            }
        }
        var isCheck: Bool {
            switch self {
            case .check:return true
            default: return false
            }
        }
    }
    var startFor: StartFor
    var setupStep: SetupSteps
    let passcodeMinLength: Int = 4
    let passcodeMaxLength: Int = 8
    let validDigitsSet: CharacterSet = {
        return CharacterSet(charactersIn: "0".unicodeScalars.first! ... "9".unicodeScalars.first!)
    }()
    
    let disposeBag = DisposeBag()
    let account: CoreAccount
    let authService: AccountService
    
    let didLogin = PublishSubject<AppStructs.AccountInfo>()
    let didLoginFailed = PublishSubject<String>()
    
    init(authService: AccountService, account: CoreAccount, startFor: StartFor) {
        self.account = account
        self.authService = authService
        self.startFor = startFor
        switch startFor {
        case .setup:
            self.setupStep = .first
        case .change(_):
            self.setupStep = .check
        case .check(_):
            self.setupStep = .check
        }
    }
    
    func changePin(pin: String) {
        self.account.pin = pin
        CoreAccount.update(account: self.account)
    }
    
    func pinChechSuccess() {
        self.authService.getClientInfo().flatMap { info -> Single<AppStructs.AccountInfo> in
            return self.authService.getAccount().flatMap { account in
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
    
    func updateLockState(state: LockState) {
        CoreAccount.updateLockState(accountId: self.account.accountId, state: state)
    }
}
