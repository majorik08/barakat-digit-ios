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
    
    let didLoadAccountInfo = PublishSubject<Void>()
    let didLoadServices = PublishSubject<Void>()
    let didLoadShowcase = PublishSubject<Void>()
    let didLoadStories = PublishSubject<Void>()
    let didLoadFavorites = PublishSubject<Void>()
    let didLoadCards = PublishSubject<Void>()
    let didLoadRates = PublishSubject<Void>()
    
    let didLoadError = PublishSubject<String>()
    
    var serviceGroups: [AppStructs.PaymentGroup] = []
    var transfers: [AppStructs.TransferTypes] = []
    var showcaseList: [AppStructs.Showcase] = []
    var storiesList: [AppStructs.Stories] = []
    var favoritesList: [AppStructs.Favourite] = []
    var cardList: [AppStructs.CreditDebitCard] = []
    var ratesList: [AppStructs.CurrencyRate] = []
    
    init(accountService: AccountService, paymentsService: PaymentsService, bannerService: BannerService, ratesService: RatesService, accountInfo: AppStructs.AccountInfo) {
        self.paymentsService = paymentsService
        self.bannerService = bannerService
        self.ratesService = ratesService
        self.accountInfo = accountInfo
        self.accountService = accountService
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
            if let error = error as? NetworkError {
                self.didLoadError.onNext((error.message ?? error.error) ?? error.localizedDescription)
            } else {
                self.didLoadError.onNext(error.localizedDescription)
            }
        }.disposed(by: self.disposeBag)
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
                self.didLoadError.onNext((error.message ?? error.error) ?? error.localizedDescription)
            } else {
                self.didLoadError.onNext(error.localizedDescription)
            }
        }.disposed(by: self.disposeBag)
    }
    
    func loadFavorites() {
        self.paymentsService.loadFavorites()
            .observe(on: MainScheduler.instance)
            .subscribe { items in
                self.favoritesList = items
                self.didLoadFavorites.onNext(())
        } onFailure: { error in
            if let error = error as? NetworkError {
                self.didLoadError.onNext((error.message ?? error.error) ?? error.localizedDescription)
            } else {
                self.didLoadError.onNext(error.localizedDescription)
            }
        }.disposed(by: self.disposeBag)
    }
    
    func loadShowcaseList() {
        self.bannerService.loadShowcaseList()
            .observe(on: MainScheduler.instance)
            .subscribe { cashbeks in
            self.showcaseList = cashbeks
            self.didLoadShowcase.onNext(())
        } onFailure: { error in
            if let error = error as? NetworkError {
                self.didLoadError.onNext((error.message ?? error.error) ?? error.localizedDescription)
            } else {
                self.didLoadError.onNext(error.localizedDescription)
            }
        }.disposed(by: self.disposeBag)
    }
    
    func loadStoriesList() {
        self.bannerService.loadStories()
            .observe(on: MainScheduler.instance)
            .subscribe { stories in
            self.storiesList = stories
            self.didLoadStories.onNext(())
        } onFailure: { error in
            if let error = error as? NetworkError {
                self.didLoadError.onNext((error.message ?? error.error) ?? error.localizedDescription)
            } else {
                self.didLoadError.onNext(error.localizedDescription)
            }
        }.disposed(by: self.disposeBag)
    }
    
    func loadCardList() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.cardList = [.init(number: "1111"), .init(number: "2222")]
            self.didLoadCards.onNext(())
        }
    }
    
    func loadRates() {
        self.ratesService.loadRates()
            .observe(on: MainScheduler.instance)
            .subscribe { rates in
            self.ratesList = rates
            self.didLoadRates.onNext(())
        } onFailure: { error in
            if let error = error as? NetworkError {
                self.didLoadError.onNext((error.message ?? error.error) ?? error.localizedDescription)
            } else {
                self.didLoadError.onNext(error.localizedDescription)
            }
        }.disposed(by: self.disposeBag)
    }
}
