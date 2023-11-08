//
//  Localize.swift
//  BarakatWallet
//
//  Created by km1tj on 05/10/23.
//

import Foundation

internal extension String {
    
    var localized: String {
        return localized(in: .main)
    }
    
    func localizedFormat(arguments: CVarArg...) -> String {
        return String(format: localized, arguments: arguments)
    }

    func localizedPlural(argument: CVarArg) -> String {
        return NSString.localizedStringWithFormat(localized as NSString, argument) as String
    }
}

public extension String {
    
    func localized(in bundle: Bundle? = nil) -> String {
        return localized(using: nil, in: bundle)
    }
    
    func localizedFormat(arguments: CVarArg..., in bundle: Bundle?) -> String {
        return String(format: localized(in: bundle), arguments: arguments)
    }

    func localizedPlural(argument: CVarArg, in bundle: Bundle?) -> String {
        return NSString.localizedStringWithFormat(localized(in: bundle) as NSString, argument) as String
    }
    
    func localized(using tableName: String?) -> String {
        return localized(using: tableName, in: .main)
    }
        
    func localizedFormat(arguments: CVarArg..., using tableName: String?) -> String {
        return String(format: localized(using: tableName), arguments: arguments)
    }
    
    func localizedPlural(argument: CVarArg, using tableName: String?) -> String {
        return NSString.localizedStringWithFormat(localized(using: tableName) as NSString, argument) as String
    }
    
    func localized(using tableName: String?, in bundle: Bundle?) -> String {
        let bundle: Bundle = bundle ?? .main
        if let path = bundle.path(forResource: Constants.Language ?? Localize.Language.english.rawValue, ofType: "lproj"), let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: tableName)
        } else if let path = bundle.path(forResource: "Base", ofType: "lproj"), let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: tableName)
        }
        return self
    }
    
    func localizedFormat(arguments: CVarArg..., using tableName: String?, in bundle: Bundle?) -> String {
        return String(format: localized(using: tableName, in: bundle), arguments: arguments)
    }
    
    func localizedPlural(argument: CVarArg, using tableName: String?, in bundle: Bundle?) -> String {
        return NSString.localizedStringWithFormat(localized(using: tableName, in: bundle) as NSString, argument) as String
    }
}


class Localize {
    
    enum Language: String {
        case english = "en"
        case russian = "ru"
        case tajik = "tg"
    }
    static var bundle: Bundle = .main
    
    static var currentLanguage: Language {
        if let langCode = Constants.Language {
            return Language(rawValue: langCode) ?? .english
        }
        return .english
    }
    
    static func configure() {
        if let lang = Constants.Language {
            if let path = Bundle.main.path(forResource: lang, ofType: "lproj"), let bundle = Bundle(path: path) {
                Localize.bundle = bundle
            }
        } else {
            let systemLang = Locale.current.languageCode ?? "en"
            let appLang = Language(rawValue: systemLang) ?? .english
            Constants.Language = appLang.rawValue
            if let path = Bundle.main.path(forResource: appLang.rawValue, ofType: "lproj"), let bundle = Bundle(path: path) {
                Localize.bundle = bundle
            }
        }
    }
    
    static func setLanguage(langCode: String) -> Bool {
        if let appLang = Language(rawValue: langCode) {
            if let path = Bundle.main.path(forResource: appLang.rawValue, ofType: "lproj"), let bundle = Bundle(path: path) {
                Constants.Language = appLang.rawValue
                Localize.bundle = bundle
                return true
            }
        }
        return false
    }
    
    static func availableLanguages(_ excludeBase: Bool = true) -> [String] {
        var availableLanguages = Bundle.main.localizations
        if let indexOfBase = availableLanguages.firstIndex(of: "Base") , excludeBase == true {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }
}
