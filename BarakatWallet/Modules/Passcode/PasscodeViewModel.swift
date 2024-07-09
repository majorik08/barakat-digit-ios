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
        case setup(key: String, exist: Bool, wallet: String)
        case change(account: CoreAccount)
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
    let passcodeMaxLength: Int = 4
    let validDigitsSet: CharacterSet = {
        return CharacterSet(charactersIn: "0".unicodeScalars.first! ... "9".unicodeScalars.first!)
    }()
    
    let disposeBag = DisposeBag()
    let authService: AccountService
    
    let didLogin = PublishSubject<AppStructs.AccountInfo>()
    let didCodeNeeed = PublishSubject<Bool>()
    let didLoginFailed = PublishSubject<Error>()
    
    init(authService: AccountService, startFor: StartFor) {
        self.authService = authService
        self.startFor = startFor
        switch startFor {
        case .setup(_, let exist, _):
            self.setupStep = exist ? .check : .first
        case .change(_):
            self.setupStep = .check
        }
    }
    
    func checkPin(pin: String, key: String, wallet: String) {
        self.authService.registerPin(key: key, pin: pin, wallet: wallet).flatMap { account -> Single<AppStructs.AccountInfo> in
            APIManager.instance.setToken(token: account.token)
            return self.authService.getClientInfo().flatMap { info in
                return self.authService.getAccount().flatMap { account in
                    let accountInfo = AppStructs.AccountInfo(accounts: account, client: info)
                    return .just(accountInfo)
                }
            }
        }.observe(on: MainScheduler.instance).subscribe { accountInfo in
            self.didLogin.onNext(accountInfo)
        } onFailure: { error in
            self.didLoginFailed.onNext(error)
        }.disposed(by: self.disposeBag)
    }
    
    func signIn(pin: String) {
        self.authService.signIn(pin: pin).subscribe { result in
            if result.smsSign {
                self.didCodeNeeed.onNext(true)
            } else {
                self.login()
            }
        } onFailure: { error in
            self.didLoginFailed.onNext(error)
        }.disposed(by: self.disposeBag)
    }
    
    func signInConfirm(code: String)  {
        self.authService.signInConfirm(code: code).subscribe { _ in
            self.login()
        } onFailure: { error in
            self.didLoginFailed.onNext(error)
        }.disposed(by: self.disposeBag)
    }
    
    private func login() {
        self.authService.getClientInfo().flatMap { info in
            return self.authService.getAccount().flatMap { account in
                let accountInfo = AppStructs.AccountInfo(accounts: account, client: info)
                return .just(accountInfo)
            }
        }.observe(on: MainScheduler.instance).subscribe { accountInfo in
            self.didLogin.onNext(accountInfo)
        } onFailure: { error in
            self.didLoginFailed.onNext(error)
        }.disposed(by: self.disposeBag)
    }
}
