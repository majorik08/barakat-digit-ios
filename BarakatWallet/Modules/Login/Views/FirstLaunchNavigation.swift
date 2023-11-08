//
//  FirstLaunchNavigation.swift
//  BarakatWallet
//
//  Created by km1tj on 23/10/23.
//

import Foundation
import UIKit

class FirstLaunchNavigation: BaseNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.current.plainTableBackColor
    }
    
    public override func languageChanged() {
        super.languageChanged()
    }
    
    public override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
        self.view.backgroundColor = Theme.current.plainTableBackColor
        UINavigationBar.appearance().tintColor = .white
        UISearchBar.appearance().tintColor = newTheme.tintColor
        UITableView.appearance().backgroundColor = newTheme.plainTableBackColor
        UITabBar.appearance().tintColor = newTheme.tintColor
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if previousTraitCollection?.hasDifferentColorAppearance(comparedTo: self.traitCollection) ?? false && Theme.current.value == "DEFAULT" {
                if UIApplication.shared.applicationState != .background {
                    let userInterfaceStyle = traitCollection.userInterfaceStyle
                    if userInterfaceStyle == .dark {
                        Theme.current = Theme.dark(globalColor: Constants.DarkGlobalColor)
                    } else {
                        Theme.current = Theme.light(globalColor: Constants.LighGlobalColor)
                    }
                    Theme.current.value = "DEFAULT"
                    if let delegate = UIApplication.shared.delegate, let window = delegate.window {
                        window?.tintColor = Theme.current.tintColor
                    }
                    self.themeChanged(newTheme: Theme.current)
                }
            }
        }
    }
}
