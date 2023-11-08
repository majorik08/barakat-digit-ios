//
//  AppStructs.swift
//  BarakatWallet
//
//  Created by km1tj on 26/10/23.
//

import Foundation

struct AppStructs {
    
    class AccountInfo: Codable {
        var accounts: [Account]
        var client: ClientInfo
        
        init(accounts: [Account], client: ClientInfo) {
            self.accounts = accounts
            self.client = client
        }
    }
    
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
    
    struct HistoryItem: Codable {
        var date: Date
    }
    
    struct Showcase: Codable {
        
    }
    
    struct Favourite: Codable {
        
    }
}
