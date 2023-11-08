//
//  HomeViewModel.swift
//  BarakatWallet
//
//  Created by km1tj on 08/11/23.
//
import Foundation
import RxSwift

class HomeViewModel {
    
    let disposeBag = DisposeBag()
    let accountInfo: AppStructs.AccountInfo
    
    let paymentsService: PaymentsService
    let showcaseService: ShowcaseService
    
    let didLoadServices = PublishSubject<Void>()
    let didLoadServicesError = PublishSubject<String>()
    
    var serviceGroups: [AppStructs.PaymentGroup] = []
    var transfers: [AppStructs.TransferTypes] = []
    
    var showcaseList: [AppStructs.Showcase] = []
    var creditDebitCards: [AppStructs.CreditDebitCard] = [.init(number: "1111"), .init(number: "2222")]
    
    init(paymentsService: PaymentsService, showcaseService: ShowcaseService, accountInfo: AppStructs.AccountInfo) {
        self.paymentsService = paymentsService
        self.showcaseService = showcaseService
        self.accountInfo = accountInfo
    }
    
    func loadServices() {
        self.paymentsService.loadPayments()
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.serviceGroups = result.groups
                self.transfers = result.transfers
                self.didLoadServices.onNext(())
        } onFailure: { error in
            if let error = error as? NetworkError {
                self.didLoadServicesError.onNext((error.message ?? error.error) ?? error.localizedDescription)
            } else {
                self.didLoadServicesError.onNext(error.localizedDescription)
            }
        }.disposed(by: self.disposeBag)
    }
    
    func loadShowcaseList() {
        
    }
}
