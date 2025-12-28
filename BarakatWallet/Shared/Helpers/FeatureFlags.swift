//
//  FeatureFlags.swift
//  BarakatWallet
//
//  Created by Codex on 2024-xx-xx.
//

import Foundation

struct FeatureFlags {
    private static let pinningOverrideKey = "pinning_enabled_override"
    
    static var pinningEnabled: Bool {
        if let override = Constants.SharedDefaults.object(forKey: Self.pinningOverrideKey) as? Bool {
            return override
        }
        if let plistValue = Bundle.main.object(forInfoDictionaryKey: "PINNING_ENABLED") as? Bool {
            return plistValue
        }
        return true
    }
    
    static func setPinningEnabled(_ enabled: Bool) {
        Constants.SharedDefaults.set(enabled, forKey: Self.pinningOverrideKey)
    }
}
