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
    
    private let service: AccountService
    var key: String
    let phoneNumber: String
    var waitTime: Int = 30
    
    let disposeBag = DisposeBag()
    let code = BehaviorSubject(value: "")
    let isSendActive = PublishSubject<Bool>()
    
    init(service: AccountService, phoneNumber: String, key: String) {
        self.service = service
        self.key = key
        self.phoneNumber = phoneNumber
        self.code.map({ $0.count >= 4 }).share(replay: 1).bind(to: self.isSendActive).disposed(by: self.disposeBag)
    }
}
