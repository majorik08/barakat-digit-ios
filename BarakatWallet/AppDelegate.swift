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
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.tintColor = Theme.current.tintColor
        self.appCoordinator = AppCoordinator(window: self.window!)
        self.appCoordinator?.start()
        application.registerForRemoteNotifications()
        return true
    }
}
