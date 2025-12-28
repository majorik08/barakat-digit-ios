//
//  CoreAccount.swift
//  BarakatWallet
//
//  Created by km1tj on 27/10/23.
//

import Foundation
import KeychainSwift

final class CoreAccount: Codable {
    
    public var accountId: String
    public var token: String
    public var lastSelected: Double
    public var pin: String
    public var wallet: String
    public var lockState: LockState
    
    init(accountId: String, token: String, lastSelected: Double, lockState: LockState, pin: String, wallet: String) {
        self.accountId = accountId
        self.token = token
        self.lastSelected = lastSelected
        self.pin = pin
        self.lockState = lockState
        self.wallet = wallet
    }
    
    @discardableResult
    public static func login(accountId: String, token: String, pin: String, wallet: String, lastSelected: Double) -> CoreAccount {
        let account = CoreAccount(accountId: accountId, token: token, lastSelected: lastSelected, lockState: LockState(), pin: pin, wallet: wallet)
        Self.update(accountId: accountId, account: account, add: true)
        return account
    }
    
    public static func logout(account: CoreAccount) -> Bool {
        Self.update(accountId: account.accountId, account: account, add: false)
        return true
    }
    
    public static func updateLockState(accountId: String, state: LockState) {
        guard let account = self.accounts().first(where: { $0.accountId == accountId }) else { return }
        account.lockState = state
        self.update(account: account)
    }
    
    public static func updateToken(oldToken: String, newToken: String) {
        guard let account = self.accounts().first(where: { $0.token == oldToken }) else { return }
        account.token = newToken
        self.update(account: account)
    }
    
    public static func update(account: CoreAccount) {
        Self.update(accountId: account.accountId, account: account, add: true)
    }
    
    public static func accounts() -> [CoreAccount] {
        if let data = Constants.keychain.getData(Constants.DeviceId) {
            do {
                let dec = JSONDecoder()
                dec.dateDecodingStrategy = .millisecondsSince1970
                let accounts = try dec.decode([CoreAccount].self, from: data)
                return accounts
            } catch {
                Logger.log(tag: "CoreAccount", message: "Failed to decode accounts, removing corrupted entry")
                Constants.keychain.delete(Constants.DeviceId)
            }
        }
        return []
    }
    
    private static func update(accountId: String, account: CoreAccount, add: Bool) {
        do {
            if let data = Constants.keychain.getData(Constants.DeviceId) {
                let dec = JSONDecoder()
                dec.dateDecodingStrategy = .millisecondsSince1970
                var accounts: [CoreAccount] = (try? dec.decode([CoreAccount].self, from: data)) ?? []
                if add {
                    if let ind = accounts.firstIndex(where: { $0.accountId == accountId }) {
                        accounts[ind] = account
                    } else {
                        accounts.append(account)
                    }
                } else {
                    if let ind = accounts.firstIndex(where: { $0.accountId == accountId }) {
                        accounts.remove(at: ind)
                    }
                }
                let enc = JSONEncoder()
                enc.dateEncodingStrategy = .millisecondsSince1970
                let writeData = try enc.encode(accounts)
                Constants.keychain.set(writeData, forKey: Constants.DeviceId, withAccess: .accessibleAfterFirstUnlock)
            } else {
                let enc = JSONEncoder()
                enc.dateEncodingStrategy = .millisecondsSince1970
                let writeData = try enc.encode([account])
                Constants.keychain.set(writeData, forKey: Constants.DeviceId, withAccess: .accessibleAfterFirstUnlock)
            }
        } catch {
            debugPrint(error)
        }
    }
    
    func getKey() -> String? {
        let dec = self.decodeToken(jwtToken: self.token)
        return dec["key"] as? String
    }
    
    func decodeToken(jwtToken jwt: String) -> [String: Any] {
        let segments = jwt.components(separatedBy: ".")
        return decodeJWTPart(segments[1]) ?? [:]
    }

    private func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/")
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 = base64 + padding
        }
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }
    
    private func decodeJWTPart(_ value: String) -> [String: Any]? {
        guard let bodyData = base64UrlDecode(value), let json = try? JSONSerialization.jsonObject(with: bodyData, options: []),
                let payload = json as? [String: Any] else {
          return nil
        }
        return payload
    }
}

public struct MonotonicTimestamp: Codable, Equatable {
    public var bootTimestamp: Int32
    public var uptime: Int32

    public init(bootTimestamp: Int32, uptime: Int32) {
        self.bootTimestamp = bootTimestamp
        self.uptime = uptime
    }
}

public struct UnlockAttempts: Codable, Equatable {
    public var count: Int32
    public var timestamp: MonotonicTimestamp

    public init(count: Int32, timestamp: MonotonicTimestamp) {
        self.count = count
        self.timestamp = timestamp
    }
}

public struct LockState: Codable, Equatable {
    public var isManuallyLocked: Bool
    public var autolockTimeout: Int32?
    public var unlockAttemts: UnlockAttempts?
    public var applicationActivityTimestamp: MonotonicTimestamp?

    public init(isManuallyLocked: Bool = false, autolockTimeout: Int32? = nil, unlockAttemts: UnlockAttempts? = nil, applicationActivityTimestamp: MonotonicTimestamp? = nil) {
        self.isManuallyLocked = isManuallyLocked
        self.autolockTimeout = autolockTimeout
        self.unlockAttemts = unlockAttemts
        self.applicationActivityTimestamp = applicationActivityTimestamp
    }
}
