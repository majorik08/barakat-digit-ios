//
//  AppStructs.swift
//  BarakatWallet
//
//  Created by km1tj on 26/10/23.
//

import Foundation
import RxSwift

struct AppStructs {
    
    struct Device: Codable {
        let APIKey: String
        let appVersion: String
        let deviceID: String
        let deviceName: String
        let language: String
        let latitude: Double
        let longitude: Double
        let platform: String
    }
    
    class AccountInfo {
        
        let didUpdateClient = PublishSubject<Void>()
        let didUpdateAccounts = PublishSubject<Void>()
        
        var accounts: [Account] {
            didSet {
                self.didUpdateAccounts.onNext(())
            }
        }
        var client: ClientInfo {
            didSet {
                self.didUpdateClient.onNext(())
            }
        }
        
        init(accounts: [Account], client: ClientInfo) {
            self.accounts = accounts
            self.client = client
        }
    }
    
    class Account: Codable {
        var account: String
        var bal_account: String
        var closingBalance: Double
        var name: String
        var overDraft: Double
        var reserve: Double
        
        init(account: String, bal_account: String, closingBalance: Double, name: String, overDraft: Double, reserve: Double) {
            self.account = account
            self.bal_account = bal_account
            self.closingBalance = closingBalance
            self.name = name
            self.overDraft = overDraft
            self.reserve = reserve
        }
    }
    
    class ClientInfo: Codable {
        var avatar: String
        var birthDate: String
        var email: String
        var firstName: String
        var gender: String
        var id: Int
        var inn: String
        var lastName: String
        var midName: String
        var pushNotify: Bool
        var smsPush: Bool
        var statusID: Int
        var wallet: String
        var limit: Limit
        
        struct Limit: Codable {
            var QRPayment: Bool
            var SummaOnMonth: Int
            var cardOrder: Bool
            var cashing: Bool
            var convert: Bool
            var creditControl: Bool
            var id: Int
            var maxInWallet: Int
            var name: String
            var payment: Bool
            var transfer: Bool
            
            enum Identify: Int, Codable {
            case noIdentified = 1
            case onlineIdentified = 2
            case identified = 3
            }
            var identifyed: Identify {
                return .init(rawValue: self.id) ?? .noIdentified
            }
        }
        
        init(avatar: String, birthDate: String, email: String, firstName: String, gender: String, id: Int, inn: String, lastName: String, midName: String, pushNotify: Bool, smsPush: Bool, statusID: Int, wallet: String, limit: Limit) {
            self.avatar = avatar
            self.birthDate = birthDate
            self.email = email
            self.firstName = firstName
            self.gender = gender
            self.id = id
            self.inn = inn
            self.lastName = lastName
            self.midName = midName
            self.pushNotify = pushNotify
            self.smsPush = smsPush
            self.statusID = statusID
            self.wallet = wallet
            self.limit = limit
        }
    }
    
    struct CreditDebitCard: Codable {
        let number: String
    }
    
    struct CreditDebitCardTypes: Codable {
        let name: String
    }
    
    struct CreditDebitCardItem: Codable {
        let name: String
    }
    
    struct PaymentGroup: Codable {
        let id: Int
        let name: String
        let image: String
        let services: [ServiceItem]
        
        struct ServiceItem: Codable {
            let id: Int
            let name: String
            let image: String
            let isCheck: Int
            let params: [Params]
            
            struct Params: Codable {
                let id: Int
                let name: String
                let coment: String
                let keyboard: Int
                let mask: String
                let maxLen: Int
                let minLen: Int
                let param: Int
                let prefix: String
            }
        }
    }
    
    struct TransferTypes: Codable {
        let id: Int
        let name: String
        let image: String
        let isCheck: Int
        let params: [Params]
        struct Params: Codable {
            let id: Int
            let name: String
            let coment: String
            let keyboard: Int
            let mask: String
            let maxLen: Int
            let minLen: Int
            let param: Int
            let prefix: String
        }
    }
    
    struct Favourite: Codable {
        
    }
    
    struct HistoryItem: Codable {
        var date: Date
    }
    
    struct Showcase: Codable {
        let address: String
        let cashBack: Int
        var contacts: [Contact]
        let description: String
        let id: Int
        let image: String
        let lat: Double
        let long: Double
        let name: String
        let payText: String
        let validityDate: String
        
        struct Contact: Codable {
            let cashID: Int
            let id: Int
            let logo: String
            let text: String
            let type: String
        }
    }
    
    struct Stories: Codable {
        let action: String
        let button: String
        let type: Int
        let id: Int
        let images: [Image]
        
        struct Image: Codable {
            let id: Int
            let source: String
            let storyID: Int
        }
    }
    
    struct Banner: Codable {
        let id: Int
        let image: String
        let text: String
        let title: String
    }
    
    struct CurrencyRate: Codable {
        let currencyOne: Currency
        let currencyTwo: Currency
        let rate: Double
    }
}
