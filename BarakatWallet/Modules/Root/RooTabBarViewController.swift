//
//  ViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 05/10/23.
//

import UIKit

class RooTabBarViewController: BaseTabBarController, UITabBarControllerDelegate {
    
    private var tabShadowView: UIView = {
        let view = UIView(frame: .zero)
        view.clipsToBounds = false
        view.isUserInteractionEnabled = false
        return view
    }()
    private var tabShapeView: UIView = {
        let view = UIView(frame: .zero)
        view.clipsToBounds = true
        view.isUserInteractionEnabled = false
        return view
    }()
    weak var coordinator: RootTabCoordinator? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.isTranslucent = false
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.tabBar.backgroundColor = Theme.current.plainTableBackColor
        if #available(iOS 13, *) {
            let appearance = tabBar.standardAppearance
            appearance.configureWithOpaqueBackground()
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            appearance.backgroundColor = Theme.current.plainTableBackColor
            self.tabBar.standardAppearance = appearance
        } else {
            self.tabBar.shadowImage = UIImage()
            self.tabBar.backgroundImage = UIImage()
        }
        self.tabBar.insertSubview(self.tabShadowView, at: 0)
        self.tabBar.insertSubview(self.tabShapeView, at: 1)
        self.updateShadow()
        self.updateShapeView()
        self.hidesBottomBarWhenPushed = false
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return self.coordinator?.canShowTabItemController(tag: viewController.tabBarItem.tag) ?? false
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.coordinator?.didSelectTabItem(tag: viewController.tabBarItem.tag)
    }
    
    private func updateShadow() {
        let bounds = self.tabBar.bounds
        self.tabShadowView.frame = bounds
        let shadowPath0 = UIBezierPath(roundedRect: bounds, cornerRadius: 15)
        let layer0: CALayer
        if let l = self.tabShadowView.layer.sublayers?.first {
            layer0 = l
        } else {
            layer0 = CALayer()
            self.tabShadowView.layer.addSublayer(layer0)
        }
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = Theme.current.shadowColor.cgColor
        layer0.shadowOpacity = 0.6
        layer0.shadowRadius = 8
        layer0.shadowOffset = CGSize(width: 0, height: -2)
        layer0.bounds = bounds
        layer0.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private func updateShapeView() {
        let bounds = self.tabBar.bounds
        self.tabShapeView.frame = bounds
        let layer0: CALayer
        if let l = self.tabShapeView.layer.sublayers?.first {
            layer0 = l
        } else {
            layer0 = CALayer()
            self.tabShapeView.layer.addSublayer(layer0)
            self.tabShapeView.layer.cornerRadius = 15
        }
        layer0.backgroundColor = Theme.current.navigationColor.cgColor
        layer0.bounds = bounds
        layer0.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updateShadow()
        self.updateShapeView()
    }
  
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    public override func languageChanged() {
        super.languageChanged()
        if let items = self.tabBar.items {
            items.forEach { (item) in
                if item.tag == 1 {
                    item.title = "MAIN".localized
                } else if item.tag == 2 {
                    item.title = "HISTORY".localized
                } else if item.tag == 3 {
                    item.title = ""
                } else if item.tag == 4 {
                    item.title = "PAYMENTS".localized
                } else if item.tag == 5 {
                    item.title = "CARDS".localized
                }
            }
        }
    }
    
    public override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
        self.tabBar.backgroundColor = Theme.current.plainTableBackColor
        if #available(iOS 13, *) {
            let appearance = tabBar.standardAppearance
            appearance.configureWithOpaqueBackground()
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            appearance.backgroundColor = Theme.current.plainTableBackColor
            self.tabBar.standardAppearance = appearance
        } else {
            self.tabBar.shadowImage = UIImage()
            self.tabBar.backgroundImage = UIImage()
        }
        UITabBar.appearance().tintColor = newTheme.tintColor
        UINavigationBar.appearance().tintColor = newTheme.tintColor
        UISearchBar.appearance().tintColor = newTheme.tintColor
        UITableView.appearance().backgroundColor = newTheme.plainTableBackColor
        self.tabBar.backgroundColor = Theme.current.plainTableBackColor
        self.updateShadow()
        self.updateShapeView()
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
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
