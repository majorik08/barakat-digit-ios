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
    let accountService: AccountService
    let paymentsService: PaymentsService
    let bannerService: BannerService
    let ratesService: RatesService
    let cardService: CardService
    
    let didLoadAccountInfo = PublishSubject<Void>()
    let didLoadServices = PublishSubject<Void>()
    let didLoadShowcase = PublishSubject<Void>()
    let didLoadStories = PublishSubject<Void>()
    let didLoadFavorites = PublishSubject<Void>()
    let didLoadCards = PublishSubject<Void>()
    let didLoadRates = PublishSubject<Void>()
    
    let didLoadError = PublishSubject<Error>()
    
    var serviceGroups: [AppStructs.PaymentGroup] {
        return self.accountInfo.paymentGroups
    }
    var transfers: [AppStructs.PaymentGroup.ServiceItem] {
        return self.accountInfo.transferTypes
    }
    var cardList: [AppStructs.CreditDebitCard] {
        return self.accountInfo.cards
    }
    var favoritesList: [AppStructs.Favourite] {
        return self.accountInfo.favorites
    }
    
    var showcaseList: [AppStructs.Showcase] = []
    var storiesList: [AppStructs.Stories] = []
    var ratesList: [AppStructs.CurrencyRate] = []
   
    init(accountService: AccountService, paymentsService: PaymentsService, bannerService: BannerService, ratesService: RatesService, accountInfo: AppStructs.AccountInfo, cardService: CardService) {
        self.paymentsService = paymentsService
        self.bannerService = bannerService
        self.ratesService = ratesService
        self.accountInfo = accountInfo
        self.accountService = accountService
        self.cardService = cardService
        self.accountInfo.didUpdateFavorites.subscribe { _ in
            self.didLoadFavorites.onNext(())
        }.disposed(by: self.disposeBag)
    }
    
    func getService(serviceID: Int) -> AppStructs.PaymentGroup.ServiceItem? {
        return self.serviceGroups.first(where: { $0.services.contains(where: { $0.id == serviceID }) })?.services.first(where: { $0.id == serviceID })
    }
    
    func loadAccountInfo() {
        self.accountService.getClientInfo().flatMap { info -> Single<AppStructs.AccountInfo> in
            return self.accountService.getAccount().flatMap { account in
                let accountInfo = AppStructs.AccountInfo(accounts: account, client: info)
                return .just(accountInfo)
            }
        }.observe(on: MainScheduler.instance).subscribe { accountInfo in
            self.accountInfo.client = accountInfo.client
            self.accountInfo.accounts = accountInfo.accounts
            self.didLoadAccountInfo.onNext(())
        } onFailure: { error in
            self.didLoadError.onNext(error)
        }.disposed(by: self.disposeBag)
    }
    
    func loadServices() {
        self.paymentsService.loadPayments()
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.didLoadServices.onNext(())
        } onFailure: { error in
            self.didLoadError.onNext(error)
        }.disposed(by: self.disposeBag)
    }
    
    func loadFavorites() {
        self.paymentsService.loadFavorites()
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
        } onFailure: { error in
            self.didLoadError.onNext(error)
        }.disposed(by: self.disposeBag)
    }
    
    func deleteFavorite(id: Int) {
        self.paymentsService.removeFavorite(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
        } onFailure: { error in
            self.didLoadError.onNext(error)
        }.disposed(by: self.disposeBag)
    }
    
    func loadShowcaseList() {
        self.bannerService.loadShowcaseList(limit: 10, offset: 0)
            .observe(on: MainScheduler.instance)
            .subscribe { cashbeks in
            self.showcaseList = cashbeks
            self.didLoadShowcase.onNext(())
        } onFailure: { error in
            self.didLoadError.onNext(error)
        }.disposed(by: self.disposeBag)
    }
    
    func loadStoriesList() {
        self.bannerService.loadStories()
            .observe(on: MainScheduler.instance)
            .subscribe { stories in
            self.storiesList = stories
            self.didLoadStories.onNext(())
        } onFailure: { error in
            self.didLoadError.onNext(error)
        }.disposed(by: self.disposeBag)
    }
    
    func loadCardList() {
        self.cardService.getUserCards()
            .observe(on: MainScheduler.instance)
            .subscribe { cards in
            self.didLoadCards.onNext(())
        } onFailure: { error in
            self.didLoadError.onNext(error)
        }.disposed(by: self.disposeBag)
    }
    
    func loadRates() {
        self.ratesService.loadRates()
            .observe(on: MainScheduler.instance)
            .subscribe { rates in
            self.ratesList = rates
            self.didLoadRates.onNext(())
        } onFailure: { error in
            self.didLoadError.onNext(error)
        }.disposed(by: self.disposeBag)
    }
}
