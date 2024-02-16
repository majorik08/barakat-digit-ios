//
//  StringExt.swift
//  BarakatWallet
//
//  Created by km1tj on 22/10/23.
//

import Foundation
import PhoneNumberKit

extension Double {
    
    var balanceText: String {
        return "\(String(format: "%.2f", self)) с."
    }
    var currencyText: String {
        return "\(String(format: "%.4f", self)) TJS"
    }
}

extension String {
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
    }
    
    func isValidUrl() -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: self)
        return result
    }
    
    func formatedPrefix(countryCode: String = Constants.defaultRegionCode()) -> String {
        do {
            let str = self.starts(with: "+") ? self : "+\(self)"
            let info = try Constants.phoneNumberKit.parse(str, withRegion: countryCode, ignoreType: true)
            let formated = Constants.phoneNumberKit.format(info, toType: .international, withPrefix: true)
            if formated.count < self.count {
                return str
            }
            return formated
        } catch {
            return self
        }
    }
    
    var djb2hash: Int {
        let unicodeScalars = self.unicodeScalars.map { $0.value }
        return unicodeScalars.reduce(5381) {
            ($0 << 5) &+ $0 &+ Int($1)
        }
    }

    var sdbmhash: Int {
        let unicodeScalars = self.unicodeScalars.map { $0.value }
        return unicodeScalars.reduce(0) {
            (Int($1) &+ ($0 << 6) &+ ($0 << 16)).addingReportingOverflow(-$0).partialValue
        }
    }
    
    func capitalizingFirstLetter() -> String {
        prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func toDate(format: String = "dd-MM-yyyy HH:mm") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
    
    func toDate2(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "GMT")// TimeZone(secondsFromGMT: 3600 * 5) //TimeZone(abbreviation: "GMT+5:00")
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
    
    func toDate3(format: String = "dd-MM-yyyy HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
    
//    func dateToMillis() -> Date? {
//        let components = self.split(separator: " ")
//        let dateComponents = components[0].trimmingCharacters(in: .whitespaces).split(separator: "-")
//        let timeComponents = components[1].trimmingCharacters(in: .whitespaces).split(separator: ":")
//        var calendar = Calendar(identifier: .gregorian)
//        calendar.timeZone = TimeZone(identifier: "GMT")!
//        let year = Int(dateComponents[0])!
//        let month = Int(dateComponents[1])! - 1
//        let day = Int(dateComponents[2])!
//        let hour = Int(timeComponents[0])!
//        let minute = Int(timeComponents[1])!
//        let second = Int(timeComponents[2])!
//        if let date = calendar.date(from: DateComponents(year: year, month: month, day: day, hour: hour, minute: minute, second: second)) {
//            return date
//        } else {
//            return nil
//        }
//    }
}
