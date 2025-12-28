//
//  DeviceKeyService.swift
//  BarakatWallet
//
//  Created by Codex on 2024-xx-xx.
//

import Foundation
import Security
import CommonCrypto

final class DeviceKeyService {
    
    enum DeviceKeyError: Error {
        case unableToCreateKey
        case unableToSign
    }
    
    private let keyTag: Data = "com.barakat.devicekey".data(using: .utf8)!
    private let keyType = kSecAttrKeyTypeECSECPrimeRandom
    private let deviceIdCache = NSCache<NSString, NSString>()
    
    func ensureKeyExists() {
        if self.loadPrivateKey() != nil { return }
        _ = self.createKey()
    }

    func deviceId() -> String {
        if let cached = self.deviceIdCache.object(forKey: "deviceId") as String? {
            return cached
        }
        guard let pub = self.publicKeyData() else { return "unknown-device" }
        let id = self.sha256Base64(pub)
        self.deviceIdCache.setObject(id as NSString, forKey: "deviceId")
        return id
    }
    
    func publicKeyData() -> Data? {
        guard let privateKey = self.loadPrivateKey(), let publicKey = SecKeyCopyPublicKey(privateKey) else { return nil }
        return SecKeyCopyExternalRepresentation(publicKey, nil) as Data?
    }
    
    func sign(message: Data) -> Data? {
        guard let privateKey = self.loadPrivateKey() ?? self.createKey() else {
            Logger.log(tag: "DeviceKeyService", message: "No private key available for signing")
            return nil
        }
        var error: Unmanaged<CFError>?
        guard let signature = SecKeyCreateSignature(privateKey, .ecdsaSignatureMessageX962SHA256, message as CFData, &error) as Data? else {
            if let err = error?.takeRetainedValue() {
                Logger.log(tag: "DeviceKeyService", error: err)
            }
            return nil
        }
        return signature
    }
    
    private func loadPrivateKey() -> SecKey? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: self.keyTag,
            kSecAttrKeyType as String: self.keyType,
            kSecReturnRef as String: true
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecSuccess {
            return (item as! SecKey)
        }
        return nil
    }
    
    private func createKey() -> SecKey? {
        var privateAttributes: [String: Any] = [
            kSecAttrIsPermanent as String: true,
            kSecAttrApplicationTag as String: self.keyTag
        ]
        #if !targetEnvironment(simulator)
        if let access = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenUnlockedThisDeviceOnly, [.privateKeyUsage], nil) {
            privateAttributes[kSecAttrAccessControl as String] = access
        }
        #endif
        var attributes: [String: Any] = [
            kSecAttrKeyType as String: self.keyType,
            kSecAttrKeySizeInBits as String: 256,
            kSecPrivateKeyAttrs as String: privateAttributes
        ]
        #if !targetEnvironment(simulator)
        attributes[kSecAttrTokenID as String] = kSecAttrTokenIDSecureEnclave
        #endif
        var error: Unmanaged<CFError>?
        let key = SecKeyCreateRandomKey(attributes as CFDictionary, &error)
        if let err = error?.takeRetainedValue() {
            Logger.log(tag: "DeviceKeyService", error: err)
        }
        return key
    }
    
    private func sha256Base64(_ data: Data) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes { bytes in
            _ = CC_SHA256(bytes.baseAddress, CC_LONG(data.count), &digest)
        }
        return Data(digest).base64EncodedString()
    }
}
