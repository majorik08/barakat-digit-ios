//
//  CardsViewModel.swift
//  BarakatWallet
//
//  Created by km1tj on 01/11/23.
//

import Foundation
import UIKit
import RxSwift

class CardsViewModel {
    
    let cardService: CardService
    let paymentsService: PaymentsService
    var showCardInfo: Bool = false
    var accountInfo: AppStructs.AccountInfo
    
    var availableCardCategories: [AppStructs.CreditDebitCardCategory] = []
    var availableCardItems: [AppStructs.CreditDebitCardTypes] = []
    
    var userCards: [AppStructs.CreditDebitCard] {
        return self.accountInfo.cards
    }
    
    let didLoadCards = PublishSubject<Void>()
    let didLoadCategories = PublishSubject<Void>()
    let didLoadCardTypes = PublishSubject<Void>()
    
    let didLoadError = PublishSubject<String>()
    let disposeBag = DisposeBag()
    
    init(cardService: CardService, paymentsService: PaymentsService, accountInfo: AppStructs.AccountInfo) {
        self.cardService = cardService
        self.paymentsService = paymentsService
        self.accountInfo = accountInfo
        self.accountInfo.didUpdateCards.subscribe { _ in
            self.didLoadCards.onNext(())
        }.disposed(by: self.disposeBag)
    }
    
    func loadCardList() {
        self.cardService.getUserCards()
            .observe(on: MainScheduler.instance)
            .subscribe { cards in
            self.didLoadCards.onNext(())
        } onFailure: { error in
            if let error = error as? NetworkError {
                self.didLoadError.onNext((error.message ?? error.error) ?? error.localizedDescription)
            } else {
                self.didLoadError.onNext(error.localizedDescription)
            }
        }.disposed(by: self.disposeBag)
    }
    
    func loadCardCategories() {
        self.cardService.getCardCategories()
            .observe(on: MainScheduler.instance)
            .subscribe { cats in
            self.availableCardCategories = cats
            self.didLoadCategories.onNext(())
        } onFailure: { error in
            if let error = error as? NetworkError {
                self.didLoadError.onNext((error.message ?? error.error) ?? error.localizedDescription)
            } else {
                self.didLoadError.onNext(error.localizedDescription)
            }
        }.disposed(by: self.disposeBag)
    }
    
    func loadCardTypes(categoryId: Int) {
        self.cardService.getCardTypes(categoryId: categoryId)
            .observe(on: MainScheduler.instance)
            .subscribe { cats in
            self.availableCardItems = cats
            self.didLoadCardTypes.onNext(())
        } onFailure: { error in
            if let error = error as? NetworkError {
                self.didLoadError.onNext((error.message ?? error.error) ?? error.localizedDescription)
            } else {
                self.didLoadError.onNext(error.localizedDescription)
            }
        }.disposed(by: self.disposeBag)
    }
}
