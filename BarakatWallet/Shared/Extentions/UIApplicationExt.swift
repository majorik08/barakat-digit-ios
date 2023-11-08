//
//  UIApplicationExt.swift
//  BarakatWallet
//
//  Created by km1tj on 05/10/23.
//

import Foundation
import UIKit

extension UIApplication {
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let split = controller as? UISplitViewController {
            for item in split.viewControllers {
                return topViewController(controller: item)
            }
        }
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    var isSplitOrSlideOver: Bool {
        guard let window = self.windows.filter({ $0.isKeyWindow }).first else { return false }
        return !(window.frame.width == window.screen.bounds.width)
    }
    
    class var mainWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    class var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    var mainViewController: RooTabBarViewController {
        return (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController as! RooTabBarViewController
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
