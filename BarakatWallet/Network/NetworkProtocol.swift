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
    static var url: String {get}
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
    public let url: String
    public var params: Params
    public let result: Response.Type
    
    public init(_ params: Params) {
        fatalError("EndpointRequest init params not implemented")
    }
    
    public init<Type: EndpointRequestType>(_ request: Type) where Type.Params == Params, Type.Result == Response  {
        self.url = Type.url
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
