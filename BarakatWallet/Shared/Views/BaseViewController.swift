//
//  BaseViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 05/10/23.
//

import Foundation
import UIKit

public protocol UIEvents {
    func languageChanged()
    func themeChanged(newTheme: Theme)
}

open class BaseViewController: UIViewController, UIEvents {
    
    open func languageChanged() {}
    
    open func themeChanged(newTheme: Theme) {
        self.view.backgroundColor = Theme.current.plainTableBackColor
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.current.plainTableBackColor
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let a = UIBarButtonItem()
        a.title = "BACK".localized
        self.navigationItem.backBarButtonItem = a
    }
    open func setStatusBarStyle(dark: Bool?) {
        guard let baseNav = self.navigationController as? BaseNavigationController else { return }
        if let dark {
            if dark {
                if #available(iOS 13.0, *) {
                    baseNav.setCustomStyle(style: .darkContent)
                } else {
                    baseNav.setCustomStyle(style: .default)
                }
            } else {
                baseNav.setCustomStyle(style: .lightContent)
            }
        } else {
            baseNav.setCustomStyle(style: nil)
        }
    }
}

open class BaseTableCell: UITableViewCell {
    
    public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, tableView: UITableView) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = tableView.style == .grouped ? Theme.current.groupedTableCellColor : Theme.current.plainTableCellColor
        let view = UIView()
        view.backgroundColor = tableView.style == .grouped ? Theme.current.groupedSelectedCellBackground : Theme.current.plainSelectedCellBackground
        self.selectedBackgroundView = view
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class BaseTableViewController: UITableViewController, UIEvents {
    
    public override init(style: UITableView.Style) {
        super.init(style: style)
        if self.tableView.style == .plain {
            self.tableView.backgroundColor = Theme.current.plainTableBackColor
            self.tableView.separatorColor = Theme.current.plainTableSeparatorColor
        } else if self.tableView.style == .grouped {
            self.tableView.backgroundColor = Theme.current.groupedTableBackColor
            self.tableView.separatorColor = Theme.current.groupedTableSeparatorColor
        } else {
            if #available(iOS 13.0, *), self.tableView.style == .insetGrouped {
                self.tableView.backgroundColor = Theme.current.groupedTableBackColor
                self.tableView.separatorColor = Theme.current.groupedTableSeparatorColor
            } else {
                self.tableView.backgroundColor = Theme.current.plainTableBackColor
                self.tableView.separatorColor = Theme.current.plainTableSeparatorColor
            }
        }
        if #available(iOS 15.0, tvOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    
    open func languageChanged() {
        
    }
    
    open func themeChanged(newTheme: Theme) {
        if self.tableView.style == .plain {
            self.tableView.backgroundColor = newTheme.plainTableBackColor
            self.tableView.separatorColor = newTheme.plainTableSeparatorColor
        } else if self.tableView.style == .grouped {
            self.tableView.backgroundColor = newTheme.groupedTableBackColor
            self.tableView.separatorColor = newTheme.groupedTableSeparatorColor
        } else {
            if #available(iOS 13.0, *), self.tableView.style == .insetGrouped {
                self.tableView.backgroundColor = newTheme.groupedTableBackColor
                self.tableView.separatorColor = newTheme.groupedTableSeparatorColor
            } else {
                self.tableView.backgroundColor = newTheme.plainTableBackColor
                self.tableView.separatorColor = newTheme.plainTableSeparatorColor
            }
        }
        self.tableView.reloadData()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let a = UIBarButtonItem(title: "BACK".localized, style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = a
    }
}

open class BaseCollectionViewController: UICollectionViewController, UIEvents {
    open func languageChanged() {}
    open func themeChanged(newTheme: Theme) {}
    open override func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return false
    }
}

open class BaseNavigationController: UINavigationController, UIEvents {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.current.plainTableBackColor
    }
    
    var customStyle: UIStatusBarStyle? = nil
    open var transparentNavigation: Bool = false
    open var overrideInterfaceStyle: Bool = true
    
    open func languageChanged() {
        for controller in self.viewControllers {
            if let uiEvent = controller as? UIEvents {
                uiEvent.languageChanged()
            }
            if let uiEvent = controller.presentedViewController as? UIEvents {
                uiEvent.languageChanged()
            }
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public init(title: String? = nil, image: UIImage? = nil, tag: Int = 0, overrideInterfaceStyle: Bool = true) {
        self.overrideInterfaceStyle = overrideInterfaceStyle
        super.init(nibName: nil, bundle: nil)
        if tag >= 0 {
            self.tabBarItem.title = title
            self.tabBarItem.image = image
        }
        self.tabBarItem.tag = tag
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = Theme.current.navigationColor
        self.navigationBar.tintColor = Theme.current.tintColor
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Theme.current.navigationTextColor, NSAttributedString.Key.font: UIFont.bold(size: 17)]
        if #available(iOS 11.0, *) {
            self.navigationBar.prefersLargeTitles = true
            self.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : Theme.current.navigationTextColor, NSAttributedString.Key.font: UIFont.bold(size: 34)]
        }
        self.navigationBar.prefersLargeTitles = false
        if #available(iOS 13.0, tvOS 13.0, *) {
            if self.overrideInterfaceStyle {
                self.overrideUserInterfaceStyle = Theme.current.dark ? .dark : .light
            }
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: Theme.current.navigationTextColor, .font: UIFont.bold(size: 17)]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: Theme.current.navigationTextColor, .font: UIFont.bold(size: 34)]
            navBarAppearance.backgroundColor = Theme.current.navigationColor
            navBarAppearance.shadowColor = .clear
            navigationBar.standardAppearance = navBarAppearance
            navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
    
    public init(rootViewController: UIViewController, title: String? = nil, image: UIImage? = nil, tag: Int = 0, overrideInterfaceStyle: Bool = true) {
        self.overrideInterfaceStyle = overrideInterfaceStyle
        super.init(rootViewController: rootViewController)
        if tag >= 0 {
            self.tabBarItem.title = title
            self.tabBarItem.image = image
        }
        rootViewController.navigationItem.title = title
        self.tabBarItem.tag = tag
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = Theme.current.navigationColor
        self.navigationBar.tintColor = Theme.current.tintColor
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Theme.current.navigationTextColor, NSAttributedString.Key.font: UIFont.bold(size: 17)]
        if #available(iOS 11.0, *) {
            self.navigationBar.prefersLargeTitles = true
            self.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : Theme.current.navigationTextColor, NSAttributedString.Key.font: UIFont.bold(size: 34)]
        }
        self.navigationBar.prefersLargeTitles = false
        if #available(iOS 13.0, tvOS 13.0, *) {
            if self.overrideInterfaceStyle {
                self.overrideUserInterfaceStyle = Theme.current.dark ? .dark : .light
            }
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: Theme.current.navigationTextColor, .font: UIFont.bold(size: 17)]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: Theme.current.navigationTextColor, .font: UIFont.bold(size: 34)]
            navBarAppearance.backgroundColor = Theme.current.navigationColor
            navBarAppearance.shadowColor = .clear
            navigationBar.standardAppearance = navBarAppearance
            navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configForTransparent() {
        self.transparentNavigation = true
        if #available(iOS 13.0, tvOS 13.0, *) {
            if self.overrideInterfaceStyle {
                self.overrideUserInterfaceStyle = Theme.current.dark ? .dark : .light
            }
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithTransparentBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: Theme.current.navigationTextColor, .font: UIFont.bold(size: 17)]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: Theme.current.navigationTextColor, .font: UIFont.bold(size: 34)]
            navBarAppearance.backgroundColor = .clear
            navigationBar.standardAppearance = navBarAppearance
            navigationBar.scrollEdgeAppearance = navBarAppearance
        }
        self.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
    }
    
    open func configForOpaque() {
        self.transparentNavigation = false
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = Theme.current.navigationColor
        self.navigationBar.tintColor = Theme.current.tintColor
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Theme.current.navigationTextColor, NSAttributedString.Key.font: UIFont.bold(size: 17)]
        if #available(iOS 11.0, *) {
            self.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : Theme.current.navigationTextColor, NSAttributedString.Key.font: UIFont.bold(size: 34)]
        }
        if #available(iOS 13.0, tvOS 13.0, *) {
            if self.overrideInterfaceStyle {
                self.overrideUserInterfaceStyle = Theme.current.dark ? .dark : .light
            }
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: Theme.current.navigationTextColor, .font: UIFont.bold(size: 17)]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: Theme.current.navigationTextColor, .font: UIFont.bold(size: 34)]
            navBarAppearance.backgroundColor = Theme.current.navigationColor
            navBarAppearance.shadowColor = .clear
            navigationBar.standardAppearance = navBarAppearance
            navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
    
    open func themeChanged(newTheme: Theme) {
        if #available(iOS 13.0, tvOS 13.0, *) {
            if self.overrideInterfaceStyle {
                self.overrideUserInterfaceStyle = newTheme.dark ? .dark : .light
            }
        }
        self.view.backgroundColor = Theme.current.plainTableBackColor
        setNeedsStatusBarAppearanceUpdate()
        self.navigationBar.barTintColor = Theme.current.navigationColor
        self.navigationBar.tintColor = Theme.current.tintColor
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : newTheme.navigationTextColor, NSAttributedString.Key.font: UIFont.bold(size: 17)]
        if #available(iOS 11.0, *) {
            self.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : newTheme.navigationTextColor, NSAttributedString.Key.font: UIFont.bold(size: 34)]
        }
        if self.transparentNavigation {
            self.configForTransparent()
        } else {
            if #available(iOS 13.0, tvOS 13.0, *) {
                let navBarAppearance = UINavigationBarAppearance()
                navBarAppearance.configureWithOpaqueBackground()
                navBarAppearance.titleTextAttributes = [.foregroundColor: newTheme.navigationTextColor, .font: UIFont.bold(size: 17)]
                navBarAppearance.largeTitleTextAttributes = [.foregroundColor: newTheme.navigationTextColor, .font: UIFont.bold(size: 34)]
                navBarAppearance.backgroundColor = newTheme.navigationColor
                navBarAppearance.shadowColor = .clear
                navigationBar.standardAppearance = navBarAppearance
                navigationBar.scrollEdgeAppearance = navBarAppearance
            }
        }
        for controller in self.viewControllers {
            if let uiEvent = controller as? UIEvents {
                uiEvent.themeChanged(newTheme: newTheme)
            }
            if let uiEvent = controller.presentedViewController as? UIEvents {
                uiEvent.themeChanged(newTheme: newTheme)
            }
        }
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        if let cs = self.customStyle {
            return cs
        } else if #available(iOS 13.0, *) {
            return Theme.current.lightStatusBar ? .lightContent : .darkContent
        } else {
            return Theme.current.lightStatusBar ? .lightContent : .default
        }
    }
    
    
    open func setCustomStyle(style: UIStatusBarStyle?) {
        self.customStyle = style
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
}

open class BaseTabBarController: UITabBarController, UIEvents {
    
    var overrideInterfaceStyle: Bool
    
    init(overrideInterfaceStyle: Bool = true) {
        self.overrideInterfaceStyle = overrideInterfaceStyle
        super.init(nibName: nil, bundle: nil)
        if #available(iOS 13.0, tvOS 13.0, *), self.overrideInterfaceStyle {
            self.overrideUserInterfaceStyle = Theme.current.dark ? .dark : .light
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func languageChanged() {
        if let controllers = self.viewControllers {
            for controller in controllers {
                if let uiEvent = controller as? UIEvents {
                    uiEvent.languageChanged()
                }
                if let uiEvent = controller.presentedViewController as? UIEvents {
                    uiEvent.languageChanged()
                }
            }
        }
    }
    open func themeChanged(newTheme: Theme) {
        if #available(iOS 13.0, tvOS 13.0, *), self.overrideInterfaceStyle {
            self.overrideUserInterfaceStyle = newTheme.dark ? .dark : .light
        }
        setNeedsStatusBarAppearanceUpdate()
        self.view.backgroundColor = newTheme.plainTableBackColor
        self.tabBar.barTintColor = newTheme.navigationColor
        self.tabBar.unselectedItemTintColor = newTheme.secondaryTextColor
        if let controllers = self.viewControllers {
            for controller in controllers {
                if let uiEvent = controller as? UIEvents {
                    uiEvent.themeChanged(newTheme: newTheme)
                }
                if let uiEvent = controller.presentedViewController as? UIEvents {
                    uiEvent.themeChanged(newTheme: newTheme)
                }
            }
        }
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return Theme.current.lightStatusBar ? .lightContent : .darkContent
        } else {
            return Theme.current.lightStatusBar ? .lightContent : .default
        }
    }
}

