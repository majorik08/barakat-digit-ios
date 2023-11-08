//
//  Logger.swift
//  BarakatWallet
//
//  Created by km1tj on 24/10/23.
//

import Foundation

public final class Logger {
    
    public static func log(tag: String, message: String, send: Bool = false) {
        Logger.shared.log(tag: tag, message: message, send: send)
    }
    
    public static func log(tag: String, error: Error, send: Bool = false) {
        Logger.shared.log(tag: tag, error: error, send: send)
    }
    
    public static func log(error: Error) {
        Logger.shared.log(error: error)
    }
    
    public static let shared = Logger()
    
    public var logToConsole: Bool = false
    public var tracingEnabled: Bool = false
    public var allLogVerbose: String = ""
    public var logQueueName: String = "redapp.log"
    
    private init() {
        self.logToConsole = false
    }
    
    func log(tag: String, message: String, send: Bool = false) {
        let ll = "\(tag): \(message)"
        print(ll)
        if send {
            if self.logToConsole {
                NSLog("\(self.logQueueName)-\(tag): %@", message)
            }
            if self.tracingEnabled {
                //MainController.instance.session.reportError(reason: message, tag: tag)
            }
        }
    }
    
    func log(tag: String, error: Error, send: Bool = false) {
        print(tag, error)
        if send {
            //let userInfo = ["accountId" : "\(Constants.sharedDefaults.string(forKey: Constants.AccountKey) ?? "not_account_exist")"]
            //Crashlytics.crashlytics().record(error: NSError(domain: NSCocoaErrorDomain, code: -1002, userInfo: userInfo))
        }
        let text = error.localizedDescription
        if self.logToConsole {
            NSLog("\(self.logQueueName)-\(tag): %@", text)
        }
        if self.tracingEnabled {
            //MainController.instance.session.reportError(reason: text, tag: tag)
        }
    }
    
    func log(error: Error) {
        debugPrint(error)
        let text = error.localizedDescription
        if self.logToConsole {
            NSLog("\(self.logQueueName)-ERROR: %@", text)
        }
        if self.tracingEnabled {
            //MainController.instance.session.reportError(reason: text, tag: "WS_PROTOCOL")
        }
    }
}
