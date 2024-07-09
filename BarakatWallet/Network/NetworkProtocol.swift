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
    case tokenExpired = "0x000"
    case incorrectRegistrationData = "0x001"
    case incorrectVerificationCodeData = "1x001"
    case deviceNotFoundDuringVerification = "1x002"
    case incorrectVerificationCode = "1x003"
    case verificationCodeConfirmationError = "1x004"
    case verificationCodeConfirmationDeviceBlocked = "1x005"
    case deviceDataUpdateError = "3x001"
    case serverErrorDeviceModification = "3x002"
    case requestedResourceNotFound = "4x001"
    case clientNotFound = "5x001"
    case incorrectClientData = "5x002"
    case clientDataUpdateError = "5x003"
    case incorrectIdentificationData = "5x004"
    case clientIdentificationDataSaveError = "5x005"
    case incorrectSaveToFavoritesData = "5x006"
    case serverErrorSaveToFavorites = "5x007"
    case favoritesNotFound = "5x008"
    case limitsNotFound = "5x009"
    case exchangeRatesNotFound = "5x010"
    case incorrectFavoriteServiceID = "5x011"
    case removeFromFavoritesError = "5x012"
    case contactDataNotFound = "5x013"
    case documentsNotFound = "5x014"
    case accountsNotFound = "6x001"
    case operationTypesNotFound = "6x002"
    case incorrectHistoryRequestFilters = "6x003"
    case historyNotFound = "6x004"
    case groupsNotFound = "7x001"
    case invalidTransactionFormat = "7x002"
    case transactionVerificationError = "7x003"
    case transactionNotFound = "7x004"
    case informationRequestNotPermitted = "7x005"
    case accountNotFound = "7x006"
    case transactionConfirmationTimeout = "7x007"
    case invalidTransactionConfirmationCode = "7x008"
    case transactionConfirmationError = "7x009"
    case storiesNotFound = "8x001"
    case bannersNotFound = "8x002"
    case cashbacksNotFound = "8x003"
    case invalidRequestParameter = "8x004"
    case notificationNotFound = "9x001"
    case invalidNotificationCategory = "9x002"
    case invalidQRCodeData = "10x001"
    case QRCodeVerificationError = "10x002"
    case cardsNotFound = "11x001"
    case incorrectCardData = "11x002"
    case cardNotCreated = "11x003"
    case incorrectBankCardRequestData = "11x004"
    case bankCardsNotFound = "11x005"
    case categoriesNotFound = "11x006"
    case cardOrderNotFound = "11x007"
    case incorrectCardOrderData = "11x008"
    case cardOrderServerError = "11x009"
    case regionsNotFound = "11x010"
    case cardBalanceNotFound = "11x011"
    case invalidToken = "1x006"
    case incorrectPinCode = "1x008"
    case incorrectPinCodeResetStructure = "1x009"
    case pinCodeResetInternalError = "1x010"
    case incorrectLoginData = "1x011"
    case accountNotFoundDuringLogin = "1x012"
    case deviceTemporarilyBlocked = "1x013"
    case exchangeRatesNotFoundAfterLogin = "7x010"
    case transferDataNotFound = "7x011"
    case incorrectTransferData = "7x012"
    case internalErrorDuringTransfer = "7x013"
    case smsVerificationDisabled = "7x014"
    case smsSendingError = "7x015"
}
