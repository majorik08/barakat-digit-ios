//
//  PublicKeyPinningTrustEvaluator.swift
//  BarakatWallet
//
//  Created by Codex on 2024-xx-xx.
//

import Foundation
import Alamofire
import Security
import CommonCrypto

final class PublicKeyPinningTrustEvaluator: ServerTrustEvaluating {
    
    private let allowedKeyHashes: Set<String>
    
    init(allowedKeyHashes: [String]) {
        self.allowedKeyHashes = Set(allowedKeyHashes)
    }
    
    func evaluate(_ trust: SecTrust, forHost host: String) throws {
        guard !self.allowedKeyHashes.isEmpty else {
            throw AFError.serverTrustEvaluationFailed(reason: .noRequiredEvaluator(host: host))
        }
        guard SecTrustEvaluateWithError(trust, nil) else {
            throw AFError.serverTrustEvaluationFailed(reason: .trustEvaluationFailed(error: nil))
        }
        let certificateCount = SecTrustGetCertificateCount(trust)
        for index in 0..<certificateCount {
            guard let certificate = SecTrustGetCertificateAtIndex(trust, index),
                  let serverPublicKey = SecCertificateCopyKey(certificate),
                  let serverPublicKeyData = SecKeyCopyExternalRepresentation(serverPublicKey, nil) as Data? else {
                continue
            }
            let hash = self.sha256Base64(serverPublicKeyData)
            if self.allowedKeyHashes.contains(hash) {
                return
            }
        }
        throw AFError.serverTrustEvaluationFailed(reason: .trustEvaluationFailed(error: nil))
    }
    
    private func sha256Base64(_ data: Data) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes { bytes in
            _ = CC_SHA256(bytes.baseAddress, CC_LONG(data.count), &digest)
        }
        return Data(digest).base64EncodedString()
    }
}
