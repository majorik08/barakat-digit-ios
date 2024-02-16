//
//  CardService.swift
//  BarakatWallet
//
//  Created by km1tj on 01/11/23.
//

import Foundation
import RxSwift

protocol CardService: Service {
    var accountInfo: AppStructs.AccountInfo { get }
    
    func getUserCards() -> Single<[AppStructs.CreditDebitCard]>
    func updateUserCard(PINOnPay: Bool?, block: Bool?, colorID: Int?, id: Int, internetPay: Bool?, newPin: String?) -> Single<AppMethods.Card.UpdateUserCard.Result>
    func addUserCard(cardHolder: String, colorID: Int, cvv: String, pan: String, validMonth: String, validYear: String) -> Single<AppMethods.Card.AddUserCard.Result>
    func removeUserCard(id: Int) -> Single<AppMethods.Card.DeleteUserCard.Result>
    
    func getCardCategories() -> Single<[AppStructs.CreditDebitCardCategory]>
    func getRegions() -> Single<[AppStructs.Region]>
    func getCardTypes(categoryId: Int) -> Single<[AppStructs.CreditDebitCardTypes]>
    func orderBankCard(account: String, accountType: AppStructs.AccountType, bankCardID: Int, holderMidname: String, holderName: String, holderSurname: String, phoneNumber: String, receivingType: AppMethods.Card.OrderBankCard.Params.ReceivingType, regionID: Int, pointID: Int) -> Single<AppMethods.Card.OrderBankCard.OrderResult>
    func getOrderCards() -> Single<[AppMethods.Card.GetOrderBankCard.OrderResult]>
}

final class CardServiceImpl: CardService {
   
    var accountInfo: AppStructs.AccountInfo
    
    init(accountInfo: AppStructs.AccountInfo) {
        self.accountInfo = accountInfo
    }
    
    func getUserCards() -> Single<[AppStructs.CreditDebitCard]> {
        return Single<[AppStructs.CreditDebitCard]>.create { single in
            APIManager.instance.request(.init(AppMethods.Card.GetUserCards(.init())), auth: .auth, timeOut: 20) { response in
                switch response.result {
                case .success(let result):
                    self.accountInfo.cards = result
                    single(.success(result))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func updateUserCard(PINOnPay: Bool?, block: Bool?, colorID: Int?, id: Int, internetPay: Bool?, newPin: String?) -> Single<AppMethods.Card.UpdateUserCard.Result> {
        return Single<AppMethods.Card.UpdateUserCard.Result>.create { single in
            APIManager.instance.request(.init(AppMethods.Card.UpdateUserCard(.init(PINOnPay: PINOnPay, block: block, colorID: colorID, id: id, internetPay: internetPay))), auth: .auth, timeOut: 20) { response in
                switch response.result {
                case .success(let result):
                    if let index = self.accountInfo.cards.firstIndex(where: { $0.id == id }) {
                        self.accountInfo.cards[index].update(PINOnPay: PINOnPay, block: block, colorID: colorID, internetPay: internetPay)
                        self.accountInfo.didUpdateCards.onNext(())
                    }
                    single(.success(result))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func addUserCard(cardHolder: String, colorID: Int, cvv: String, pan: String, validMonth: String, validYear: String) -> Single<AppMethods.Card.AddUserCard.Result> {
        return Single<AppMethods.Card.AddUserCard.Result>.create { single in
            APIManager.instance.request(.init(AppMethods.Card.AddUserCard(.init(cardHolder: cardHolder, colorID: colorID, cvv: cvv, pan: pan, validMonth: validMonth, validYear: validYear))), auth: .auth, timeOut: 20) { response in
                switch response.result {
                case .success(let result):
                    single(.success(result))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }.flatMap { _ in
            return self.getUserCards().flatMap { _ in
                return Single.just(EmptyParams())
            }
        }
    }
    
    func removeUserCard(id: Int) -> RxSwift.Single<AppMethods.Card.DeleteUserCard.Result> {
        return Single<AppMethods.Card.DeleteUserCard.Result>.create { single in
            APIManager.instance.request(.init(AppMethods.Card.DeleteUserCard(.init(id: id))), auth: .auth, timeOut: 20) { response in
                switch response.result {
                case .success(let result):
                    single(.success(result))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }.flatMap { _ in
            return self.getUserCards().flatMap { _ in
                return Single.just(EmptyParams())
            }
        }
    }
    
    func getCardCategories() -> Single<[AppStructs.CreditDebitCardCategory]> {
        return Single<[AppStructs.CreditDebitCardCategory]>.create { single in
            APIManager.instance.request(.init(AppMethods.Card.GetCategories(.init())), auth: .auth, timeOut: 20) { response in
                switch response.result {
                case .success(let result):
                    single(.success(result))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func getRegions() -> Single<[AppStructs.Region]> {
        return Single<[AppStructs.Region]>.create { single in
            APIManager.instance.request(.init(AppMethods.Card.GetRegions(.init())), auth: .auth, timeOut: 20) { response in
                switch response.result {
                case .success(let result):
                    single(.success(result))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func getCardTypes(categoryId: Int) -> Single<[AppStructs.CreditDebitCardTypes]> {
        return Single<[AppStructs.CreditDebitCardTypes]>.create { single in
            APIManager.instance.request(.init(AppMethods.Card.GetBankCards(.init(category: categoryId))), auth: .auth, timeOut: 20) { response in
                switch response.result {
                case .success(let result):
                    single(.success(result))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func orderBankCard(account: String, accountType: AppStructs.AccountType, bankCardID: Int, holderMidname: String, holderName: String, holderSurname: String, phoneNumber: String, receivingType: AppMethods.Card.OrderBankCard.Params.ReceivingType, regionID: Int, pointID: Int) -> Single<AppMethods.Card.OrderBankCard.OrderResult> {
        return Single<AppMethods.Card.OrderBankCard.Result>.create { single in
            let req = AppMethods.Card.OrderBankCard(.init(account: account, accountType: accountType, bankCardID: bankCardID, holderMidname: holderMidname, holderName: holderName, holderSurname: holderSurname, phoneNumber: phoneNumber, receivingType: receivingType, regionID: regionID, pointID: pointID))
            APIManager.instance.request(.init(req), auth: .auth, timeOut: 20) { response in
                switch response.result {
                case .success(let result):
                    single(.success(result))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func getOrderCards() -> Single<[AppMethods.Card.GetOrderBankCard.OrderResult]> {
        return Single<[AppMethods.Card.GetOrderBankCard.OrderResult]>.create { single in
            APIManager.instance.request(.init(AppMethods.Card.GetOrderBankCard(.init())), auth: .auth, timeOut: 20) { response in
                switch response.result {
                case .success(let result):
                    single(.success(result))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
