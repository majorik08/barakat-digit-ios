//
//  NotificationManager.swift
//  BarakatWallet
//
//  Created by km1tj on 19/02/24.
//

import Foundation
import UserNotifications
import AudioToolbox
import UIKit

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    static let instance = NotificationManager()
    private var hasPermission = false
    

    private override init() {
        super.init()
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                self.hasPermission = true
                self.setNotificationCategories()
            case .denied:
                self.hasPermission = false
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge], completionHandler: { (result, error) in
                    guard error == nil else {
                        self.hasPermission = false
                        return
                    }
                    self.hasPermission = result
                    if result {
                        self.setNotificationCategories()
                    }
                })
            default:
                break
            }
        }
    }
    
    private func setNotificationCategories() {
        UNUserNotificationCenter.current().delegate = self
        let eventsCat = UNNotificationCategory(identifier: "events", actions: [], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([eventsCat])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        Logger.log(tag: "userNotificationCenter", message: "willPresent notification")
        completionHandler([.alert, .sound, .badge])
    }
    
//    func checkLoginOptions(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
//        guard let lo = launchOptions else { return }
//        if let n = lo[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any], let aps = n["aps"] as? [String: Any], let cat = aps["category"] as? String, cat == "NEW_MESSAGE_CATEGORY" {
//            if let alert = aps["alert"] as? [String: Any], let body = alert["body"] as? String {
//                if let encryptedData = Data(base64Encoded: body) {
//                    let decoder = JSONDecoder()
//                    decoder.dataDecodingStrategy = .base64
//                    decoder.dateDecodingStrategy = .millisecondsSince1970
//                    do {
//                        let message = try decoder.decode(Chat.Message.self, from: encryptedData)
//                        if let delegate = UIApplication.topViewController(), let nav = delegate.navigationController {
//                            NCPCore.instance.chatKit.channel.getBy(channelId: message.channelId.stringValue).subscribe(onNext: { channelObj in
//                                nav.pushViewController(ChatViewControllerNew(channelObj: channelObj), animated: true)
//                            }).disposed(by: self.bag)
//                        }
//                    } catch {
//                        print(error)
//                    }
//                }
//            }
//        }
//    }
}
