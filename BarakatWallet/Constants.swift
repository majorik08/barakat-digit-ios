//
//  Constants.swift
//  BarakatWallet
//
//  Created by km1tj on 05/10/23.
//

import Foundation
import UIKit
import PhoneNumberKit
import Contacts
import KeychainSwift

#if DEBUG
let ENVIRONMENT: Environment = .debug
#else
let ENVIRONMENT: Environment = .release
#endif

enum Environment {
    case debug
    case release
    
    var isMock: Bool {
        return false
    }
}

struct Constants {
    
    static var Device: AppStructs.Device {
        return AppStructs.Device(APIKey: Self.ApiKey, appVersion: Self.Version, deviceID: Self.DeviceId, deviceName: Self.DeviceName, language: Self.Language ?? "ru", latitude: 0, longitude: 0, platform: Self.Platform, notifyKey: Self.PushToken)
    }
    
    static var PushToken: String {
        set {
            Constants.SharedDefaults.set(newValue, forKey: "ios_push")
        }
        get {
            return Constants.SharedDefaults.string(forKey: "ios_push") ?? ""
        }
    }
    
    static var PushTokenSent: Bool {
        set {
            Constants.SharedDefaults.set(newValue, forKey: "ios_push_sent")
        }
        get {
            return Constants.SharedDefaults.bool(forKey: "ios_push_sent")
        }
    }
    
    static var DeviceBioData: Data? {
        set {
            if let v = newValue {
                Self.keychain.set(v, forKey: "DeviceBioData", withAccess: .accessibleAfterFirstUnlock)
            } else {
                Self.keychain.delete("DeviceBioData")
            }
        }
        get {
            return Self.keychain.getData("DeviceBioData")
        }
    }
    
    static var DeviceBio: Bool {
        set {
            Self.keychain.set(newValue, forKey: "DeviceBio", withAccess: .accessibleAfterFirstUnlock)
        }
        get {
            return Self.keychain.getBool("DeviceBio") ?? false
        }
    }
    
    static var Username: String? {
        get {
            return SharedDefaults.string(forKey: "username")
        }
        set {
            SharedDefaults.setValue(newValue, forKey: "username")
        }
    }
    
    static var HideBalanceInMain: Bool {
        get {
            return SharedDefaults.bool(forKey: "HideBalanceInMain")
        }
        set {
            SharedDefaults.set(newValue, forKey: "HideBalanceInMain")
        }
    }
    
    static var ShowCardInfo: Bool {
        get {
            return SharedDefaults.bool(forKey: "ShowCardInfo")
        }
        set {
            SharedDefaults.set(newValue, forKey: "ShowCardInfo")
        }
    }
    
    var baseUrl = "https://payment.sharq.tj/mobile/swagger/index.html#/"
    
    static let keychain: KeychainSwift = {
        let k = KeychainSwift()
        return k
    }()
    
    static var AppGroupId: String {
        return "group.tj.barakat.digit"
    }
    
    static var SharedDefaults: UserDefaults {
        return UserDefaults(suiteName: AppGroupId)!
    }
    
    static var AppName: String {
        return "Barakat digit"
    }
    
    static var Theme: String {
        get {
            return SharedDefaults.string(forKey: "theme") ?? "DEFAULT"
        }
        set {
            SharedDefaults.setValue(newValue, forKey: "theme")
        }
    }
    
    static var Language: String? {
        get {
            return SharedDefaults.string(forKey: "language")
        }
        set {
            SharedDefaults.setValue(newValue, forKey: "language")
        }
    }
    
    static var cardColors: [(start: UIColor, end: UIColor)] = [
        (start: UIColor(red: 0.11, green: 0.70, blue: 0.71, alpha: 1.00), end: UIColor(red: 0.11, green: 0.70, blue: 0.71, alpha: 1.00)),
        (start: UIColor(red: 0.09, green: 0.12, blue: 0.15, alpha: 1.00), end: UIColor(red: 0.09, green: 0.12, blue: 0.15, alpha: 1.00)),
        (start: UIColor(red: 0.03, green: 0.36, blue: 0.22, alpha: 1.00), end: UIColor(red: 0.03, green: 0.36, blue: 0.22, alpha: 1.00))
    ]
    
    static var DeviceId: String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    static var DeviceName: String {
        return "\(UIDevice.modelName), \(UIDevice.current.systemName), \(UIDevice.current.systemVersion)"
    }
    
    static var ApiUrl: String {
        return "https://payment.sharq.tj/mobile/"
    }
    
    static var ApiKey: String {
        return "ios"
    }
    
    static var Platform: String {
        return "ios"
    }
    
    static var Version: String {
        return "\(Bundle.main.releaseVersionNumber ?? "1.0.0") (\(Bundle.main.buildVersionNumber ?? "1"))" // 1.0.0 (1)
    }
    
    static var PrivacyUrl: String {
        return "https://google.ru/app_privacy"
    }
    
    static var AppRateUrl: String {
        return "https://itunes.apple.com/app/id6476505592?action=write-review"
    }
    
    static var AppStoreUrl: String {
        return "https://itunes.apple.com/app/id6476505592"
    }
    
    static var AppUrl: String {
        return "https://google.tj/"
    }
    
    static var FacebookUrl: String {
        return "https://google.com"
    }
    
    static var LinkedinUrl: String {
        return "https://google.com"
    }
    
    static var InstagramUrl: String {
        return "https://google.com"
    }
    
    static var TelegramUrl: String {
        return "https://google.com"
    }
    
    static var SupportNumber: String {
        return "+992987010395"
    }
    
    static var DarkGlobalColor: UIColor {
        return UIColor(red: 0.06, green: 0.85, blue: 0.86, alpha: 1.00)
    }
    
    static var LighGlobalColor: UIColor {
        return UIColor(red: 0.06, green: 0.85, blue: 0.86, alpha: 1.00)
    }
    
    static var phoneNumberKit = PhoneNumberKit()
    
    static func defaultRegionCode() -> String {
        #if canImport(Contacts)
        if #available(iOS 9, macOS 10.11, macCatalyst 13.1, watchOS 2.0, *) {
            let countryCode = CNContactsUserDefaults.shared().countryCode
            #if targetEnvironment(macCatalyst)
                if "ko".caseInsensitiveCompare(countryCode) == .orderedSame {
                    return "kr"
                }
            #endif
            return countryCode.uppercased()
        }
        #endif
        let currentLocale = Locale.current
        if let countryCode = (currentLocale as NSLocale).object(forKey: .countryCode) as? String {
            return countryCode.uppercased()
        }
        return "TJ"
    }
}
