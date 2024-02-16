//
//  NetworkProtocol.swift
//  BarakatWallet
//
//  Created by km1tj on 24/10/23.
//

import Foundation
import Alamofire

public protocol EndpointRequestType {
    associatedtype Params: Codable
    associatedtype Result: Codable
    
    static var method: HTTPMethod {get}
    var url: String {get set}
    var params: Params {get set}
    static var result: Result.Type {get}
    
    init(_ params: Params)
}

extension EndpointRequestType {
    public static var method: HTTPMethod { fatalError("\(type(of: self)) METHOD NAME NOT SPECIFIED") }
    public static var url: String { fatalError("\(type(of: self)) URL NAME NOT SPECIFIED") }
    public var params: EmptyParams {EmptyParams()}
    public static var result: EmptyParams.Type {EmptyParams.self}
}

public struct EmptyParams: Codable {
    public init(){}
}

public struct EndpointRequest<Params: Codable, Response: Codable>: EndpointRequestType {
    public let method: HTTPMethod
    public var url: String
    public var params: Params
    public let result: Response.Type
    
    public init(_ params: Params) {
        fatalError("EndpointRequest init params not implemented")
    }
    
    public init<Type: EndpointRequestType>(_ request: Type) where Type.Params == Params, Type.Result == Response  {
        self.url = request.url
        self.params = request.params
        self.result = Type.result
        self.method = Type.method
    }
}

public struct NetworkError: Error, Codable, Equatable {
    var message: String?
    var error: String?
}

public enum Result<Response: Codable>{
    case success(Response)
    case failure(NetworkError)
}

public struct ResponseModel<T: Codable>: Codable {
    
    public let result: Result<T>
    
    public init(result: Result<T>) {
        self.result = result
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.singleValueContainer()
        do {
            let result = try values.decode(T.self)
            self.result = .success(result)
        } catch {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let message = try values.decodeIfPresent(String.self, forKey: .message)
            let err = try values.decodeIfPresent(String.self, forKey: .error)
            if message == nil && err == nil {
                throw error
            } else {
                self.result = .failure(.init(message: message, error: err))
            }
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self.result {
        case .success(let res):
            try container.encode(res)
        case .failure(let err):
            var container = encoder.container(keyedBy: CodingKeys.self)
            if let m = err.message {
                try container.encode(m, forKey: .message)
            }
            if let e = err.error {
                try container.encode(e, forKey: .error)
            }
        }
    }
    
    public enum CodingKeys: String, CodingKey {
        case message
        case error
        case unblockTime
    }
}

enum ServerErrors: String, Codable {
    case expiredToken = "0x000"
    case registrationData = "0x001"
    case ConfirmData = "1x001"
    case ConfirmDeviceNotFound = "1x002"
    case ConfirmInvalidCode = "1x003"
    case ConfirmWentWrong = "1x004"
    case ConfirmDeviceBlocked = "1x005"
    case PinCodeDeviceNotFound = "2x002"
    case UpdateDeviceData = "3x001"
    case UpdateDeviceInternal = "3x002"
    case ResourceNotFound = "4x001"
    case tokenRefreshTimeExpired = "0x900"

    case GroupsNotFound = "7x001"
    case TransactionFormatError = "7x002"
    case TransactionErrorChecking = "7x003"
    case TransactionNotFound = "7x004"
    case RequestInfoNotAllowed = "7x005"
    case AccountNotFound = "7x006"
    case TransactionTimeout = "7x007"
    case TransactionIncorrectCode = "7x008"
    case TransactionCommitError = "7x009"
    
    case CardsNotFound = "11x001"
    case IncorrectCardData = "11x002"
    case CardNotCreated = "11x003"
    case WrongParams = "11x004"

    case BankCardsNotFound = "11x005"
    case CategoriesNotFound = "11x006"
    case CardOrdersNotFound  = "11x007"
    case IncorrectOrderData  = "11x008"
    case ErrorCreatingOrder  = "11x009"
    case RegionsNotFound = "11x010"
    case ErrorGettingBalance = "11x011"
}
