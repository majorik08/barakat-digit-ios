//
//  BeforeAuthRootViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 22/10/23.
//

import Foundation
import UIKit

class BeforeAuthRootViewController: BaseTabBarController, UITabBarControllerDelegate {
    
    enum MainItems: Int {
        case main = 1, history = 2, menu = 3, cards = 4
        func getContrller(vc: BeforeAuthRootViewController) -> UIViewController {
            switch self {
            case .main:
                let vc = TransferMainViewController(bannerService: vc.coordinator!.bannerService)
                vc.tabBarItem.title = "MAIN".localized
                vc.tabBarItem.image = UIImage(name: .tab_home)
                vc.tabBarItem.tag = self.rawValue
                return vc
            case .history:
                let vc = BaseViewController(nibName: nil, bundle: nil)
                vc.tabBarItem.title = "HISTORY".localized
                vc.tabBarItem.image = UIImage(name: .tab_history)
                vc.tabBarItem.tag = self.rawValue
                return vc
            case .menu:
                let vc = BaseViewController(nibName: nil, bundle: nil)
                vc.tabBarItem.title = "MENU".localized
                vc.tabBarItem.image = UIImage(name: .tab_menu)
                vc.tabBarItem.tag = self.rawValue
                return vc
            case .cards:
                let vc = BaseViewController(nibName: nil, bundle: nil)
                vc.tabBarItem.title = "CARDS".localized
                vc.tabBarItem.image = UIImage(name: .tab_cards)
                vc.tabBarItem.tag = self.rawValue
                return vc
            }
        }
    }
    weak var coordinator: TransferCoordinator?
    public var items: [MainItems] = [.main, .cards, .history, .menu]
    
    private var tabShadowView: UIView = {
        let view = UIView(frame: .zero)
        view.clipsToBounds = false
        return view
    }()
    private var tabShapeView: UIView = {
        let view = UIView(frame: .zero)
        view.clipsToBounds = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.tabBar.isTranslucent = false
        if #available(iOS 13, *) {
            let appearance = tabBar.standardAppearance
            appearance.configureWithOpaqueBackground()
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            self.tabBar.standardAppearance = appearance
        } else {
            self.tabBar.shadowImage = UIImage()
            self.tabBar.backgroundImage = UIImage()
        }
        self.tabBar.addSubview(self.tabShadowView)
        self.tabBar.addSubview(self.tabShapeView)
        self.updateShadow()
        self.updateShapeView()
        self.hidesBottomBarWhenPushed = false
        self.setViewControllers(self.items.map({ $0.getContrller(vc: self) }), animated: false)
    }
    
    private func updateShadow() {
        self.tabShadowView.frame = self.view.frame
        let shadowPath0 = UIBezierPath(roundedRect: self.tabShadowView.bounds, cornerRadius: 15)
        let layer0: CALayer
        if let l = self.tabShadowView.layer.sublayers?.first {
            layer0 = l
        } else {
            layer0 = CALayer()
            self.tabShadowView.layer.addSublayer(layer0)
        }
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = Theme.current.shadowColor.cgColor
        layer0.shadowOpacity = 1
        layer0.shadowRadius = 30
        layer0.shadowOffset = CGSize(width: 0, height: -4)
        layer0.bounds = self.tabShadowView.bounds
        layer0.position = self.tabShadowView.center
    }
    
    private func updateShapeView() {
        self.tabShapeView.frame = self.view.frame
        let layer0: CALayer
        if let l = self.tabShapeView.layer.sublayers?.first {
            layer0 = l
        } else {
            layer0 = CALayer()
            self.tabShapeView.layer.addSublayer(layer0)
            self.tabShapeView.layer.cornerRadius = 15
        }
        layer0.backgroundColor = Theme.current.navigationColor.cgColor
        layer0.bounds = self.tabShapeView.bounds
        layer0.position = self.tabShapeView.center
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return false
    }
    
    public override func languageChanged() {
        super.languageChanged()
    }
    
    public override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
        self.updateShadow()
        self.updateShapeView()
    }
}
