//
//  NetworkRequests.swift
//  BarakatWallet
//
//  Created by km1tj on 26/10/23.
//

import Foundation
import Alamofire

struct AppMethods {
    
    struct Auth {
        
        struct Register: EndpointRequestType {
            static var method: HTTPMethod = .post
            var url: String = "registration"
            public static var result: Result.Type = Result.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
            }
            public struct Params: Codable {
                let device: AppStructs.Device
                let wallet: String
            }
            public struct Result: Codable {
                let key: String
            }
        }
        
        struct Confirm: EndpointRequestType {
            static var method: HTTPMethod = .post
            var url: String = "registration/confirm"
            public static var result: Result.Type = Result.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
            }
            public struct Params: Codable {
                let device: AppStructs.Device
                let code: String
                let key: String
            }
            public struct Result: Codable {
                let walletExist: Bool
                let key: String
            }
        }
        
        struct SetPin: EndpointRequestType {
            static var method: HTTPMethod = .post
            var url: String = "registration/pin"
            public static var result: Result.Type = Result.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
            }
            public struct Params: Codable {
                let pin: String
                let key: String
            }
            public struct Result: Codable {
                let code: Int
                let expire: String
                let token: String
            }
        }
        
        struct Resend: EndpointRequestType {
            static var method: HTTPMethod = .post
            var url: String = "registration/resend"
            public static var result: Result.Type = Result.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
            }
            public struct Params: Codable {
                let key: String
            }
            public struct Result: Codable {
                let key: String
            }
        }
        
        struct SignIn: EndpointRequestType {
            static var method: HTTPMethod = .post
            var url: String = "sign"
            public static var result: Result.Type = Result.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
            }
            public struct Params: Codable {
                let pin: String
            }
            public struct Result: Codable {
                let smsSign: Bool
            }
        }
        
        struct SignConfirm: EndpointRequestType {
            static var method: HTTPMethod = .post
            var url: String = "sign/confirm"
            public static var result: Result.Type = Result.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
            }
            public struct Params: Codable {
                let token: String
            }
            public struct Result: Codable {
                let message: String
            }
        }
        
        struct ResetConfirm: EndpointRequestType {
            static var method: HTTPMethod = .post
            var url: String = "reset/confirm"
            public static var result: Result.Type = Result.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
            }
            public struct Params: Codable {
                let token: String
                let key: String
            }
            public struct Result: Codable {
                let message: String
            }
        }
        
        struct ResetPin: EndpointRequestType {
            static var method: HTTPMethod = .post
            var url: String = "reset/pin"
            public static var result: Result.Type = Result.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
            }
            public struct Params: Codable {
                let key: String
            }
            public struct Result: Codable {
                let wallet: String
            }
        }
        
        struct DeviceUpdate: EndpointRequestType {
            static var method: HTTPMethod = .post
            var url: String = "device/update"
            public static var result: Result.Type = Result.self
            public var params: AppStructs.Device
            
            public init(_ params: AppStructs.Device) {
                self.params = params
            }
            public struct Result: Codable {
                let message: String
            }
        }
        struct RefreshToken: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "refresh/token"
            public static var result: Result.Type = Result.self
            public var params: EmptyParams
            
            public init(_ params: EmptyParams) {
                self.params = params
            }
            public struct Result: Codable {
                let code: Int
                let expire: String
                let token: String
            }
        }
    }
    
    struct Acccount {
        struct Accounts: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "accounts/accounts"
            public static var result: [AppStructs.Account].Type = [AppStructs.Account].self
            public var params: EmptyParams
            
            public init(_ params: EmptyParams) {
                self.params = params
            }
        }
        struct GetEntries: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "accounts/entries"
            public static var result: [AppStructs.EntryItem].Type = [AppStructs.EntryItem].self
            public var params: EmptyParams
            
            public init(_ params: EmptyParams) {
                self.params = params
            }
        }
        struct GetHistory: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "accounts/history"
            public static var result: [AppStructs.HistoryItem].Type = [AppStructs.HistoryItem].self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
                var str = "accounts/history?"
                if let t = params.account {
                    str += "account=\(t)&"
                }
                if let t = params.amountFrom {
                    str += "amountFrom=\(t)&"
                }
                if let t = params.amountTo {
                    str += "amountTo=\(t)&"
                }
                if let t = params.dateFrom {
                    str += "dateFrom=\(t)&"
                }
                if let t = params.dateTo {
                    str += "dateTo=\(t)&"
                }
                if let t = params.expenses {
                    str += "expenses=\(t)&"
                }
                if let t = params.incoming {
                    str += "incoming=\(t)&"
                }
                if let t = params.type {
                    str += "type=\(t)&"
                }
                str += "limit=\(params.limit)&"
                str += "offset=\(params.offset)"
                self.url = str
            }
            public struct Params: Codable {
                var account: String?
                var amountFrom: Double?
                var amountTo: Double?
                var dateFrom: String?
                var dateTo: String?
                var expenses: Bool?
                var incoming: Bool?
                var type: Int?
                var limit: Int
                var offset: Int
            }
        }
        struct GetHistoryById: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "accounts/history"
            public static var result: AppStructs.HistoryItem.Type = AppStructs.HistoryItem.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
                self.url = "accounts/history/\(params.tranId)"
            }
            public struct Params: Codable {
                var tranId: String
            }
        }
    }
    
    struct Client {
        struct Info: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "clients/client"
            public static var result: AppStructs.ClientInfo.Type = AppStructs.ClientInfo.self
            public var params: EmptyParams
            
            public init(_ params: EmptyParams) {
                self.params = params
            }
        }
        struct InfoSet: EndpointRequestType {
            static var method: HTTPMethod = .put
            var url: String = "clients/client"
            public static var result: EmptyParams.Type = EmptyParams.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
            }
            public struct Params: Codable {
                var birthDate: String
                var email: String
                var firstName: String
                var gender: String
                var lastName: String
                var midName: String
            }
        }
        struct AvatarSet: EndpointRequestType {
            static var method: HTTPMethod = .put
            var url: String = "clients/client/avatar"
            public static var result: EmptyParams.Type = EmptyParams.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
            }
            public struct Params: Codable {
                var avatar: String
            }
        }
        struct SettingsSet: EndpointRequestType {
            static var method: HTTPMethod = .put
            var url: String = "clients/client/settings"
            public static var result: EmptyParams.Type = EmptyParams.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
            }
            public struct Params: Codable {
                var pushNotify: Bool
                var smsPush: Bool
            }
        }
        
        struct IdentifyGet: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "clients/client/identification"
            public static var result: IdentifyResult.Type = IdentifyResult.self
            public var params: EmptyParams
            
            public init(_ params: EmptyParams) {
                self.params = params
            }
            public struct IdentifyResult: Codable {
                let front: String
                let rear: String
                let selfie: String
                let status: Int
                let cause: String?
                
                var idStatus: Status {
                    return .init(rawValue: self.status) ?? .notidentified
                }
                enum Status: Int {
                case notidentified = 0
                case inReview = 1
                case success = 2
                case rejected = 3
                }
            }
        }
        struct IdentifyLimitsGet: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "clients/limits"
            public static var result: [AppStructs.ClientInfo.Limit].Type = [AppStructs.ClientInfo.Limit].self
            public var params: EmptyParams
            
            public init(_ params: EmptyParams) {
                self.params = params
            }
        }
        struct IdentifySet: EndpointRequestType {
            static var method: HTTPMethod = .post
            var url: String = "clients/client/identification"
            public static var result: EmptyParams.Type = EmptyParams.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
            }
            public struct Params: Codable {
                let front: String
                let rear: String
                let selfie: String
                let status: Int
            }
        }
        struct FavoritesGet: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "clients/favorites"
            public static var result: [AppStructs.Favourite].Type = [AppStructs.Favourite].self
            public var params: EmptyParams
            
            public init(_ params: EmptyParams) {
                self.params = params
            }
        }
        struct FavoriteSet: EndpointRequestType {
            static var method: HTTPMethod = .post
            var url: String = "clients/favorites"
            public static var result: EmptyParams.Type = EmptyParams.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
            }
            public struct Params: Codable {
                var account: String
                var amount: Double
                var comment: String
                var params: [String]
                var name: String
                var serviceID: Int
            }
        }
        struct FavoriteDelete: EndpointRequestType {
            static var method: HTTPMethod = .delete
            var url: String = "clients/favorites"
            public static var result: EmptyParams.Type = EmptyParams.self
            public var params: Params
            public init(_ params: Params) {
                self.params = params
                self.url = "clients/favorites/\(params.id)"
            }
            public struct Params: Codable {
                var id: Int
            }
        }
        struct Logout: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "logout"
            public static var result: EmptyParams.Type = EmptyParams.self
            public var params: EmptyParams
            
            public init(_ params: EmptyParams) {
                self.params = params
            }
        }
    }
    
    struct Transfers {
        struct GetNumberInfo: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "simple/services/info/"
            public static var result: [GetNumberInfoResult].Type = [GetNumberInfoResult].self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
                self.url = "simple/services/info/\(params.account)"
            }
            public struct Params: Codable {
                let account: String
            }
            public struct GetNumberInfoResult: Codable {
                let accountInfo: AppMethods.Payments.GetNumberInfo.GetNumberInfoResult.Account
                let service: AppStructs.PaymentGroup.ServiceItem
            }
        }
        struct GetTransgerData: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "simple/services/transfer/data"
            public static var result: GetTransgerDataResult.Type = GetTransgerDataResult.self
            public var params: EmptyParams
            
            public init(_ params: EmptyParams) {
                self.params = params
            }
            public struct GetTransgerDataResult: Codable {
                let commissions: [Commissions]
                let rate: AppStructs.CurrencyRate
                
                struct Commissions: Codable {
                    let calcMethod: Int
                    let commissionValue: Double
                    let maxValue: Double
                    let minValue: Double
                }
            }
        }
        struct TransferSend: EndpointRequestType {
            static var method: HTTPMethod = .post
            var url: String = "simple/services/transfer/data"
            public static var result: TransferSendResult.Type = TransferSendResult.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
            }
            public struct Params: Codable {
                let accountFrom: String
                let accountTo: String
                let accountType: AppStructs.AccountType
                let amountCurrency: Int
                let phoneNumber: String
                let serviceID: Int
            }
            public struct TransferSendResult: Codable {
                let formURL: String
                let OrderId: Int
            }
        }
    }
    
    struct Payments {
        struct GetServices: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "services/services"
            public static var result: ServicesResult.Type = ServicesResult.self
            public var params: EmptyParams
            
            public init(_ params: EmptyParams) {
                self.params = params
            }
            
            public struct ServicesResult: Codable {
                let groups: [AppStructs.PaymentGroup]
                let transfers: [AppStructs.PaymentGroup.ServiceItem]
            }
        }
        struct TransactionVerify: EndpointRequestType {
            static var method: HTTPMethod = .post
            var url: String = "services/transaction/verify"
            public static var result: VerifyResult.Type = VerifyResult.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
            }
            public struct Params: Codable {
                let account: String
                let accountType: AppStructs.AccountType
                let amount: Double
                let comment: String
                let params: [String]
                let serviceID: Int
            }
            public struct VerifyResult: Codable {
                let admission: Double
                let commission: Double
                let dateTran: String
                let isCheckVerify: Bool
                let timeTran: String
                let tranID: String
            }
        }
        struct TransactionSendCode: EndpointRequestType {
            static var method: HTTPMethod = .post
            var url: String = "services/send/verify/trainId"
            public static var result: TransactionSendCodeResult.Type = TransactionSendCodeResult.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
                self.url = "services/send/verify/\(params.tranID)"
            }
            public struct Params: Codable {
                let tranID: String
            }
            public struct TransactionSendCodeResult: Codable {
                let verifyKey: String
            }
        }
        struct TransactionCommit: EndpointRequestType {
            static var method: HTTPMethod = .post
            var url: String = "services/transaction/commit/trainId"
            public static var result: EmptyParams.Type = EmptyParams.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
                self.url = "services/transaction/commit/\(params.tranID)"
            }
            public struct Params: Codable {
                let tranID: String
                let code: String
                let key: String
            }
        }
        struct GetAccountInfo: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "services/account/info/service/account"
            public static var result: GetAccountResult.Type = GetAccountResult.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
                self.url = "services/account/info/\(params.service)/\(params.account)"
            }
            public struct Params: Codable {
                let service: String
                let account: String
            }
            public struct GetAccountResult: Codable {
                let info: String
                let available: Bool
            }
        }
        struct GetNumberInfo: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "services/info/"
            public static var result: [GetNumberInfoResult].Type = [GetNumberInfoResult].self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
                self.url = "services/info/\(params.account)"
            }
            public struct Params: Codable {
                let account: String
            }
            public struct GetNumberInfoResult: Codable {
                let accountInfo: Account
                let service: AppStructs.PaymentGroup.ServiceItem
                
                public struct Account: Codable {
                    let info: String
                    let available: Bool
                }
            }
        }
        struct QrCheck: EndpointRequestType {
            static var method: HTTPMethod = .post
            var url: String = "qr/check"
            public static var result: CheckResult.Type = CheckResult.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
            }
            public struct Params: Codable {
                let data: String
            }
            public struct CheckResult: Codable {
                let merchant: AppStructs.Merchant?
                let service: Int
                let transferParam: String?
            }
        }
    }
    
    struct App {
        struct GetBanners: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "simple/banners/banners"
            public static var result: [AppStructs.Banner].Type = [AppStructs.Banner].self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
            }
            public struct Params: Codable {}
        }
        struct GetCashbeks: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "banners/cash_back"
            public static var result: [AppStructs.Showcase].Type = [AppStructs.Showcase].self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
                self.url = "banners/cash_back?limit=\(params.limit)&offset=\(params.offset)"
            }
            public struct Params: Codable {
                let limit: Int
                let offset: Int
            }
        }
        struct GetStories: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "simple/banners/stories"
            public static var result: [AppStructs.Stories].Type = [AppStructs.Stories].self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
            }
            public struct Params: Codable {}
        }
        struct NotificationsGet: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "notify/notifications"
            public static var result: [AppStructs.NotificationNews].Type = [AppStructs.NotificationNews].self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
                self.url = "notify/notifications?limit=\(params.limit)&offset=\(params.offset)"
            }
            public struct Params: Codable {
                let limit: Int
                let offset: Int
            }
        }
        struct GetRates: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "/services/rates"
            public static var result: [AppStructs.CurrencyRate].Type = [AppStructs.CurrencyRate].self
            public var params: EmptyParams
            
            public init(_ params: EmptyParams) {
                self.params = params
            }
        }
        struct GetDocs: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "/clients/docs"
            public static var result: GetDocsResult.Type = GetDocsResult.self
            public var params: EmptyParams
            
            public init(_ params: EmptyParams) {
                self.params = params
            }
            
            struct GetDocsResult: Codable {
                let aboutApp: String
                let documents: [Document]
                
                struct Document: Codable {
                    let fileAddress: String
                    let id: Int
                    let name: String
                }
            }
        }
        struct GetHelp: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "simple/clients/help"
            public static var result: GetHelpResult.Type = GetHelpResult.self
            public var params: EmptyParams
            
            public init(_ params: EmptyParams) {
                self.params = params
            }
            
            struct GetHelpResult: Codable {
                let callCenter: String
                let socials: [Socials]
                
                struct Socials: Codable {
                    let darkLogo: String
                    let id: Int
                    let name: String
                    let link: String
                    let logo: String
                }
            }
        }
    }
    
    struct Card {
        struct GetCategories: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "cards/categories"
            public static var result: [AppStructs.CreditDebitCardCategory].Type = [AppStructs.CreditDebitCardCategory].self
            public var params: EmptyParams
            
            public init(_ params: EmptyParams) {
                self.params = params
            }
        }
        struct GetRegions: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "cards/regions"
            public static var result: [AppStructs.Region].Type = [AppStructs.Region].self
            public var params: EmptyParams
            
            public init(_ params: EmptyParams) {
                self.params = params
            }
        }
        struct GetBankCards: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "cards/bank/cards"
            public static var result: [AppStructs.CreditDebitCardTypes].Type = [AppStructs.CreditDebitCardTypes].self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
                self.url = "cards/bank/cards?category=\(params.category)"
            }
            public struct Params: Codable {
                let category: Int
            }
        }
        struct OrderBankCard: EndpointRequestType {
            static var method: HTTPMethod = .post
            var url: String = "cards/card/order"
            public static var result: OrderResult.Type = OrderResult.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
            }
            public struct Params: Codable {
                let account: String
                let accountType: AppStructs.AccountType
                let bankCardID: Int
                let holderMidname: String
                let holderName: String
                let holderSurname: String
                let phoneNumber: String
                let receivingType: ReceivingType
                let regionID: Int
                let pointID: Int
                
                enum ReceivingType: Int, Codable {
                    case ship = 0
                    case point = 1
                }
            }
            struct OrderResult: Codable {
                let DeliveryTranID: String?
                let cardTranID: String?
                let id: Int
                let succeedTime: String
            }
        }
        struct GetOrderBankCard: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "cards/card/orders"
            public static var result: [OrderResult].Type = [OrderResult].self
            public var params: EmptyParams
            
            public init(_ params: EmptyParams) {
                self.params = params
            }
            public struct OrderResult: Codable {
                let bankCard: AppStructs.CreditDebitCardTypes
                let bankCardID: Int
                let cardStatus: Int
                let holderMidname: String
                let holderName: String
                let holderSurname: String
                let id: Int
                let paymentStatus: PaymentStatus
                let phoneNumber: String
                let receivingType: OrderBankCard.Params.ReceivingType
                let region: AppStructs.Region
                let point: AppStructs.Region.Points
                let regionID: Int
                let pointID: Int
            }
            
            enum PaymentStatus: Int, Codable {
                case notPay = 0
                case pay = 1
            }
        }
        
        struct GetUserCards: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "cards/card"
            public static var result: [AppStructs.CreditDebitCard].Type = [AppStructs.CreditDebitCard].self
            public var params: EmptyParams
            
            public init(_ params: EmptyParams) {
                self.params = params
            }
        }
        struct GetUserCardsBalance: EndpointRequestType {
            static var method: HTTPMethod = .get
            var url: String = "cards/card/balance"
            public static var result: AppStructs.CreditDebitCard.Type = AppStructs.CreditDebitCard.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
                self.url = "cards/card/balance/\(params.id)"
            }
            public struct Params: Codable {
                let id: Int
            }
        }
        struct UpdateUserCard: EndpointRequestType {
            static var method: HTTPMethod = .put
            var url: String = "cards/card"
            public static var result: EmptyParams.Type = EmptyParams.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
            }
            public struct Params: Codable {
                let PINOnPay: Bool?
                let block: Bool?
                let colorID: Int?
                let id: Int
                let internetPay: Bool?
            }
        }
        struct UpdatePinUserCard: EndpointRequestType {
            static var method: HTTPMethod = .put
            var url: String = "cards/card/pin"
            public static var result: EmptyParams.Type = EmptyParams.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
            }
            public struct Params: Codable {
                let PINCode: String
                let cardID: Int
            }
        }
        struct AddUserCard: EndpointRequestType {
            static var method: HTTPMethod = .post
            var url: String = "cards/card"
            public static var result: AddCardResult.Type = AddCardResult.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
            }
            public struct Params: Codable {
                let cardHolder: String
                let colorID: Int
                let cvv: String
                let pan: String
                let validMonth: String
                let validYear: String
            }
            public struct AddCardResult: Codable {
                let id: Int
                let isVerify: Bool
            }
        }
        struct AddUserCardVerify: EndpointRequestType {
            static var method: HTTPMethod = .post
            var url: String = "cards/card/verify"
            public static var result: EmptyParams.Type = EmptyParams.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
            }
            public struct Params: Codable {
                let cardID: Int
                let verifyCode: String
            }
        }
        struct DeleteUserCard: EndpointRequestType {
            static var method: HTTPMethod = .delete
            var url: String = "cards/card"
            public static var result: EmptyParams.Type = EmptyParams.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
                self.url = "cards/card/\(params.id)"
            }
            public struct Params: Codable {
                let id: Int
            }
        }
    }
}
