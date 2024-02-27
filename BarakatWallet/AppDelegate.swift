//
//  AppDelegate.swift
//  BarakatWallet
//
//  Created by km1tj on 05/10/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Theme.configure(currenTheme: Constants.Theme, darkGlobalColor: Constants.DarkGlobalColor, lightGlobalColor: Constants.LighGlobalColor)
        Localize.configure()
        self.configureFonts()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.tintColor = Theme.current.tintColor
        self.appCoordinator = AppCoordinator(window: self.window!)
        self.appCoordinator?.startWithCheck()
        application.registerForRemoteNotifications()
        return true
    }
    
    func configureFonts() {
        UIFont.regular = "Montserrat-Regular"
        UIFont.regularItalic = "Montserrat-Italic"
        UIFont.medium = "Montserrat-Medium"
        UIFont.mediumItalic = "Montserrat-MediumItalic"
        UIFont.semibold = "Montserrat-SemiBold"
        UIFont.semiboldItalic = "Montserrat-SemiBoldItalic"
        UIFont.bold = "Montserrat-Bold"
        UIFont.boldItalic = "Montserrat-BoldItalic"
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        let blurEffect = UIBlurEffect(style: Theme.current.dark ? .dark : .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = UIScreen.main.bounds
        blurEffectView.tag = 221122
        self.window?.addSubview(blurEffectView)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        self.window?.viewWithTag(221122)?.removeFromSuperview()
    }
    
    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        if extensionPointIdentifier == UIApplication.ExtensionPointIdentifier.keyboard {
            return false
        }
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        DispatchQueue.main.async {
            let token = deviceToken.map { data in String(format: "%02.2hhx", data) }.joined()
            let lastToken = Constants.PushToken
            if token != lastToken {
                Constants.PushToken = token
                Constants.PushTokenSent = false
            }
            Logger.log(tag: "AppDelegate", message: "didRegisterForRemoteNotificationsWithDeviceToken: \(token)")
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint(error)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Logger.log(tag: "AppDelegate", message: "didReceiveRemoteNotification:fetchCompletionHandler")
//        guard let _ = NCPCore.instance.currentAccount else { completionHandler(.newData); return }
//        if NCPCore.instance.socketStateEvent.value == .synced {
//            NCPCore.instance.system.websocketPing()
//            completionHandler(.newData)
//            return
//        }
//        NCPCore.instance.network.connect()
//        NCPCore.instance.session.exporterWrite(events: [.init(name: "PushNotification", boolValue: nil, intValue: nil, doubleValue: nil, stringValue: "default push", ts: Date())])
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 15.0, execute: {
//            if UIApplication.shared.applicationState == .background {
//                NCPCore.instance.network.close(intentionalClose: true)
//            }
//            completionHandler(.newData)
//        })
    }
}
