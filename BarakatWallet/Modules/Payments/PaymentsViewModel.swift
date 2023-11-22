//
//  PaymentsViewModel.swift
//  BarakatWallet
//
//  Created by km1tj on 01/11/23.
//

import Foundation
import RxSwift

class PaymentsViewModel {
    
    let disposeBag = DisposeBag()
    let accountInfo: AppStructs.AccountInfo
    let service: PaymentsService
    
    let didLoadPayments = PublishSubject<Void>()
    let didLoadPaymentsError = PublishSubject<String>()
    
    var paymentGroups: [AppStructs.PaymentGroup] = []
    var transferTypes: [AppStructs.TransferTypes] = []
    
    init(service: PaymentsService, accountInfo: AppStructs.AccountInfo) {
        self.service = service
        self.accountInfo = accountInfo
    }
    
    func loadPayments() {
        self.service.loadPayments()
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.paymentGroups = result.groups
                self.transferTypes = result.transfers
                self.didLoadPayments.onNext(())
        } onFailure: { error in
            if let error = error as? NetworkError {
                self.didLoadPaymentsError.onNext((error.message ?? error.error) ?? error.localizedDescription)
            } else {
                self.didLoadPaymentsError.onNext(error.localizedDescription)
            }
        }.disposed(by: self.disposeBag)
    }
    
    var sumParam: AppStructs.PaymentGroup.ServiceItem.Params {
        return .init(id: -999, name: "SUMMA".localized, coment: "SUMMA_HINT".localized, keyboard: 0, mask: "", maxLen: 10, minLen: 1, param: 0, prefix: "")
    }
}
