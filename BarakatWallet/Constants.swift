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
        return AppStructs.Device(APIKey: Self.ApiKey, appVersion: Self.Version, deviceID: Self.DeviceId, deviceName: Self.DeviceName, language: Self.Language ?? "ru", latitude: 0, longitude: 0, platform: Self.Platform)
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
    
    var baseUrl = "https://payment.sharq.tj/mobile/swagger/index.html#/"
    
    static let keychain: KeychainSwift = {
        let k = KeychainSwift()
        return k
    }()
    
    static var AppGroupId: String {
        return "group.com.kmi.BarakatWallet"
    }
    
    static var SharedDefaults: UserDefaults {
        return UserDefaults(suiteName: AppGroupId)!
    }
    
    static var AppName: String {
        return "Barakat Mobi"
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
        return "https://birdcoin.ru/app_privacy"
    }
    
    static var AppRateUrl: String {
        return "https://itunes.apple.com/app/id6469633721?action=write-review"
    }
    
    static var AppStoreUrl: String {
        return "https://itunes.apple.com/app/id6469633721"
    }
    
    static var DarkGlobalColor: UIColor {
        return UIColor(red: 0.00, green: 0.67, blue: 1.00, alpha: 1.00)
    }
    
    static var LighGlobalColor: UIColor {
        return UIColor(red: 0.00, green: 0.67, blue: 1.00, alpha: 1.00)
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
