//
//  SetPinViewModel.swift
//  BarakatWallet
//
//  Created by km1tj on 26/10/23.
//

import Foundation
import RxSwift

final class SetPinViewModel {
    
    enum StartFor {
        case setup
        case check(current: String)
        case change(old: String)
        
        var passcode: String {
            switch self {
            case .setup: return ""
            case .check(current: let current): return current
            case .change(old: let old): return old
            }
        }
    }
    enum SetupSteps {
        case first
        case second
    }
    let disposeBag = DisposeBag()
    
    var startFor: StartFor
    var setupStep: SetupSteps = .first
    var enteredPasscode: String? = nil
    
    let passcodeMinLength: Int = 4
    let passcodeMaxLength: Int = 10
    let validDigitsSet: CharacterSet = {
        return CharacterSet(charactersIn: "0".unicodeScalars.first! ... "9".unicodeScalars.first!)
    }()
    
    let account: CoreAccount
    
    var delegate: ((_ result: Bool) -> Void)?
    
    init(account: CoreAccount, startFor: StartFor, checkComplition: ((_ result: Bool) -> Void)? = nil) {
        self.account = account
        self.startFor = startFor
        self.delegate = checkComplition
    }
    
    func changePin(pin: String) {
        self.account.pin = pin
        CoreAccount.update(account: self.account)
    }
}
