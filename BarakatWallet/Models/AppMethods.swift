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
            static var url: String = "registration"
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
            static var url: String = "registration/confirm"
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
                let code: Int
                let expire: String
                let token: String
            }
        }
        
        struct DeviceUpdate: EndpointRequestType {
            static var method: HTTPMethod = .post
            static var url: String = "device/update"
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
            static var url: String = "refresh/token"
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
            static var url: String = "accounts/accounts"
            public static var result: [[AppStructs.Account]].Type = [[AppStructs.Account]].self
            public var params: EmptyParams
            
            public init(_ params: EmptyParams) {
                self.params = params
            }
        }
    }
    
    struct Client {
        struct Info: EndpointRequestType {
            static var method: HTTPMethod = .get
            static var url: String = "clients/client"
            public static var result: [AppStructs.ClientInfo].Type = [AppStructs.ClientInfo].self
            public var params: EmptyParams
            
            public init(_ params: EmptyParams) {
                self.params = params
            }
        }
        struct InfoSet: EndpointRequestType {
            static var method: HTTPMethod = .put
            static var url: String = "clients/client"
            public static var result: EmptyParams.Type = EmptyParams.self
            public var params: Params
            
            public init(_ params: Params) {
                self.params = params
            }
            public struct Params: Codable {
                var avatar: String?
                var birthDate: String?
                var email: String?
                var firstName: String?
                var gender: String?
                var inn: String?
                var lastName: String?
                var midName: String?
                var pushNotify: Bool?
                var smsPush: Bool?
            }
        }
    }
    
    struct Payments {
        struct GetServices: EndpointRequestType {
            static var method: HTTPMethod = .get
            static var url: String = "services/services"
            public static var result: [ServicesResult].Type = [ServicesResult].self
            public var params: EmptyParams
            
            public init(_ params: EmptyParams) {
                self.params = params
            }
            
            public struct ServicesResult: Codable {
                let groups: [AppStructs.PaymentGroup]
                let transfers: [AppStructs.TransferTypes]
            }
        }
    }
}
