//
//  CurrencyExt.swift
//  BarakatWallet
//
//  Created by km1tj on 15/02/24.
//

import Foundation

public extension CurrencyEnum {
    var formated: String {
        if self == .TJS {
            return "с."
        }
        return self.description
    }
}

public extension Int {
    
    func decimalValue(currency: CurrencyEnum) -> Decimal {
        let value: Decimal
        /// NOTE: SHOULD BE BETTER WAY OF DOING THIS
        switch currency.minorUnit {
        case 0: value = 1.0
        case 1: value = 10.0
        case 2: value = 100.0
        case 3: value = 1000.0
        case 4: value = 10000.0
        default: fatalError("Currency Minor is more than value is supported")
        }
        return Decimal(self) / value
    }
    
    func formattedAmount(_ currency: CurrencyEnum) -> String {
        let decimal = self.decimalValue(currency: currency)
        return decimal.formattedAmount(currency)
    }
}

public extension Float {
    
    func formattedAmount(_ currency: CurrencyEnum) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        //formatter.generatesDecimalNumbers = true
        formatter.currencyCode = currency.rawValue
        formatter.locale = Locale.init(identifier: Constants.Language ?? "en")
        if currency == .TJS {
            formatter.currencySymbol = ""
            let ddd = NSDecimalNumber(value: self)
            return "\(formatter.string(from: ddd) ?? "\(self)") с." //    с. • смн. • сом.
        } else if currency == .RUB {
            formatter.currencySymbol = "₽"
        }
        let ddd = NSDecimalNumber(value: self)
        return formatter.string(from: ddd) ?? "\(self)"
    }
}

public extension Decimal {
    
    func intValue(currency: CurrencyEnum) -> Int {
        return Int((self.rounded(currency) * pow(10, currency.minorUnit)).description.split(separator: ".")[0]) ?? 0
    }
//
    func formattedAmount(_ currency: CurrencyEnum) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        //formatter.generatesDecimalNumbers = true
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.currencyCode = currency.rawValue
        formatter.locale = Locale.init(identifier: Constants.Language ?? "en")
        if currency == .TJS {
            formatter.currencySymbol = ""
            return "\(formatter.string(from: self as NSDecimalNumber) ?? "\(self)") с." //    с. • смн. • сом.
        } else if currency == .RUB {
            formatter.currencySymbol = "₽"
        }
        return formatter.string(from: self as NSDecimalNumber) ?? "\(self)"
    }
}

extension Decimal {
    
    func rounded(_ c: CurrencyEnum) -> Decimal {
        var approximate = self
        var rounded = Decimal()
        NSDecimalRound(&rounded, &approximate, c.minorUnit, .bankers)
        return rounded
    }
}
