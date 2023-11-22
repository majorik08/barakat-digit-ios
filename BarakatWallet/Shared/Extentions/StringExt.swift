//
//  StringExt.swift
//  BarakatWallet
//
//  Created by km1tj on 22/10/23.
//

import Foundation
import PhoneNumberKit

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
}
