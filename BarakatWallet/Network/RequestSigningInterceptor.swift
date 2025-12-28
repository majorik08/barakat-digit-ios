//
//  RequestSigningInterceptor.swift
//  BarakatWallet
//
//  Created by Codex on 2024-xx-xx.
//

import Foundation
import Alamofire
import CommonCrypto

final class RequestSigningInterceptor: RequestInterceptor {
    
    private let deviceKeyService: DeviceKeyService
    private let tokenProvider: () -> String?
    
    init(deviceKeyService: DeviceKeyService, tokenProvider: @escaping () -> String?) {
        self.deviceKeyService = deviceKeyService
        self.tokenProvider = tokenProvider
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Swift.Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        guard let url = request.url else {
            completion(.success(request))
            return
        }
        
        // Authorization заголовок остаётся, если его уже проставил клиент
        if request.headers["Authorization"] == nil, let token = self.tokenProvider() {
            request.headers.update(name: "Authorization", value: "Bearer \(token)")
        }
        
        let nonce = UUID().uuidString
        let timestamp = String(Int(Date().timeIntervalSince1970))
        let host = url.host ?? ""
        var pathWithQuery = url.path
        if let query = url.query {
            pathWithQuery += "?\(query)"
        }
        
        let bodyHash = self.hashBody(request.httpBody)
        let signingString = [
            request.method?.rawValue ?? "GET",
            host,
            pathWithQuery,
            timestamp,
            nonce,
            bodyHash
        ].joined(separator: "\n")
        
        if let signature = self.deviceKeyService.sign(message: Data(signingString.utf8))?.base64EncodedString() {
            request.headers.update(name: "X-Device-Id", value: self.deviceKeyService.deviceId())
            request.headers.update(name: "X-Nonce", value: nonce)
            request.headers.update(name: "X-Timestamp", value: timestamp)
            request.headers.update(name: "X-Signature", value: signature)
            request.headers.update(name: "X-Signature-Alg", value: "ES256")
            request.headers.update(name: "X-Body-Hash", value: bodyHash)
        } else {
            Logger.log(tag: "RequestSigningInterceptor", message: "Signature missing; request will be sent unsigned")
        }
        
        completion(.success(request))
    }
    
    private func hashBody(_ body: Data?) -> String {
        let bodyData = body ?? Data()
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        bodyData.withUnsafeBytes { bytes in
            _ = CC_SHA256(bytes.baseAddress, CC_LONG(bodyData.count), &digest)
        }
        return Data(digest).base64EncodedString()
    }
}
