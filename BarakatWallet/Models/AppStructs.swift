//
//  AppStructs.swift
//  BarakatWallet
//
//  Created by km1tj on 26/10/23.
//

import Foundation
import RxSwift
import UIKit

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
        var notifyKey: String
    }
    
    class AccountInfo {
        
        enum BalanceType {
            case wallet(account: Account)
            case card(card: CreditDebitCard)
            
            var name: String {
                switch self {
                case .wallet(account: let account):
                    return account.name
                case .card(card: let card):
                    return card.pan
                }
            }
            var account: String {
                switch self {
                case .wallet(account: let account):
                    return account.account
                case .card(card: let card):
                    return card.pan
                }
            }
            var balance: Double? {
                switch self {
                case .wallet(account: let account):
                    return account.balance
                case .card(_):
                    return nil
                }
            }
            var accountType: AccountType {
                switch self {
                case .wallet(_):return .wallet
                case .card(_):return .card
                }
            }
        }
        
        let didUpdateClient = PublishSubject<Void>()
        let didUpdateAccounts = PublishSubject<Void>()
        let didUpdateCards = PublishSubject<Void>()
        let didUpdateFavorites = PublishSubject<Void>()
        
        var paymentGroups: [AppStructs.PaymentGroup] = []
        var transferTypes: [AppStructs.PaymentGroup.ServiceItem] = []
        var favorites: [AppStructs.Favourite] = []
        
        
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
        var cards: [AppStructs.CreditDebitCard] {
            didSet {
                self.didUpdateCards.onNext(())
            }
        }
        var clientBalances: [BalanceType] {
            var items = [BalanceType]()
            for account in accounts {
                items.append(.wallet(account: account))
            }
            for card in cards {
                items.append(.card(card: card))
            }
            return items
        }
        var walletBalance: Double {
            let acc = self.accounts.first(where: { $0.bal_account == "63" })?.balance ?? 0
            return acc
        }
        var bonusBalance: Double {
            let acc = self.accounts.first(where: { $0.bal_account == "64" })?.balance ?? 0
            return acc
        }
        
        init(accounts: [Account], client: ClientInfo, cards: [AppStructs.CreditDebitCard] = []) {
            self.accounts = accounts
            self.cards = cards
            self.client = client
        }
        
        func getService(serviceID: Int) -> AppStructs.PaymentGroup.ServiceItem? {
            return self.paymentGroups.first(where: { $0.services.contains(where: { $0.id == serviceID }) })?.services.first(where: { $0.id == serviceID }) ?? self.transferTypes.first(where: { $0.id == serviceID })
        }
    }
    
    struct Account: Codable, Hashable {
        
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
        
        static func == (lhs: AppStructs.Account, rhs: AppStructs.Account) -> Bool {
            return lhs.account == rhs.account
        }
        
        var balance: Double {
            return self.closingBalance + self.overDraft - self.reserve
        }
        
        var isBonus: Bool {
            return self.bal_account == "64"
        }
    }
    
    struct ClientInfo: Codable, Hashable {
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
        
        struct Limit: Codable, Hashable {
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
    
    enum AccountType: Int, Codable {
        case wallet = 1
        case card = 2
    }
    
    enum TransferType: Int {
        case transferToPhone = 101
        case transferToCard = 102
        case transferBetweenAccounts = 106
        case transferFromForeign = 107
    }
    
    enum KeyboardViewType: Int {
        case nums = 1
        case alphabet = 2
        case numsAndAlphabet = 3
        case phoneNumber = 4
    }
    
    struct CreditDebitCard: Codable, Hashable {
        var PINOnPay: Bool
        var balance: Double
        var bankName: String
        var block: Bool
        var cardHolder: String
        var clientID: Int
        var color: CreditDebitCardCategory.Color
        var colorID:Int
        var cvv: String
        let id: Int
        var internetPay: Bool
        var logo: String
        var pan: String
        var showBalance: Bool
        var validMonth: String
        var validYear: String
        
        mutating func update(PINOnPay: Bool?, block: Bool?, colorID: Int?, internetPay: Bool?) {
            if let PINOnPay {
                self.PINOnPay = PINOnPay
            }
            if let block {
                self.block = block
            }
            if let colorID {
                self.colorID = colorID
            }
            if let internetPay {
                self.internetPay = internetPay
            }
        }
    }
    
    struct CreditDebitCardCategory: Codable {
        let color: Color
        let colorID: Int
        let id: Int
        let name: String
        
        struct Color: Codable, Hashable {
            let id: Int
            let name: String
        }
    }
    
    struct Region: Codable {
        let deliveryPrice: Double
        let id: Int
        let name: String
        let points: [Points]
        
        struct Points: Codable {
            let address: String
            let id: Int
            let name: String
            let regionID: Int
        }
    }
    
    struct CreditDebitCardTypes: Codable {
        let cardCategory: CreditDebitCardCategory
        let categoryID: Int
        let details: [Detail]
        let electron: Bool
        let id: Int
        let limitation: Int
        let name: String
        let logo: String
        let image: String
        let price: Double
        let remainder: Double
        let securityDeposit: Double
        
        struct Detail: Codable {
            let bankCardID: Int
            let id: Int
            let text: String
        }
    }
    
    struct HistoryItem: Codable {
        let accountFrom: String
        let accountTo: String
        let admission: Double
        let amount: Double
        let commission: Double
        let datetime: String
        let service: String
        let status: Int
        let tran_id: String
        
        var statusType: HistoryStatus {
            return .init(rawValue: self.status) ?? .notVerfied
        }
        
        enum HistoryStatus: Int {
            case notVerfied = 0
            case new = 1
            case inProgress = 2
            case error = 3
            case success = 4
            
            var name: String {
                switch self {
                case .notVerfied:
                    return "PAYMENT_NOT_VERIFIED".localized
                case .new:
                    return "PAYMENT_PENDING".localized
                case .inProgress:
                    return "PAYMENT_IN_PROGRESS".localized
                case .error:
                    return "PAYMENT_FAILED".localized
                case .success:
                    return "PAYMENT_SUCCESS".localized
                }
            }
            var color: UIColor {
                switch self {
                case .notVerfied, .new, .inProgress:return UIColor.systemOrange
                case .error:return UIColor.systemRed
                case .success:return UIColor.systemGreen
                }
            }
        }
    }
    
    struct EntryItem: Codable, Hashable {
        var id: Int
        var name: String
    }
    
    struct PaymentGroup: Codable {
        let id: Int
        let name: String
        let image: String
        let listImage: String
        let darkImage: String
        let darkListImage: String
        let services: [ServiceItem]
        let childGroups: [PaymentGroup]
        
        struct ServiceItem: Codable {
            let id: Int
            let name: String
            let image: String
            let listImage: String
            let darkImage: String
            let darkListImage: String
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
    
    struct Merchant: Codable {
        var id: Int?
        var merchantAddress: String
        var merchantID: String
        var name: String
    }
    
    struct Favourite: Codable, Hashable {
        var id: Int
        var account: String
        var amount: Double
        var comment: String
        var params: [String]
        var name: String
        var serviceID: Int
    }
    
    struct NotificationNews: Codable {
        let id: Int
        let category: Int
        let dateTime: String
        let title: String
        let text: String
        let image: String
    }
    
    struct Showcase: Codable {
        let address: String?
        let cashBack: Int
        var contacts: [Contact]?
        let description: String?
        let id: Int
        let image: String
        let lat: Double?
        let long: Double?
        let name: String?
        let payText: String?
        let validityDate: String?
        
        struct Contact: Codable {
            let cashID: Int
            let id: Int
            let logo: String?
            let text: String?
            let type: String
        }
    }
    
    struct Stories: Codable {
        let type: Int
        let id: Int
        let images: [Image]
        let mainImage: String
        
        struct Image: Codable {
            let id: Int
            let source: String
            let storyID: Int
            let button: String?
            let action: String?
        }
    }
    
    struct Banner: Codable {
        let id: Int
        let image: String
        let text: String
        let title: String
    }
    
    struct CurrencyRate: Codable {
        let code: String
        let icon: String
        let id: Int
        let name: String
        let purchase: Double
        let sale: Double
    }
}
