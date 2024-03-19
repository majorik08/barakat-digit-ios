//
//  BeforeAuthRootViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 22/10/23.
//

import Foundation
import UIKit

final class BeforeAuthCoordinator: Coordinator {
 
    enum MainItems: Int {
        case main = 1, history = 2, qr = 3, payments = 4, cards = 5
    }
    weak var parent: LoginCoordinator? = nil
    var children: [Coordinator] = []
    var tabBar: BeforeAuthRootViewController
    let nav: BaseNavigationController
    
    lazy var transferCoordinator: TransferCoordinator = {
        return TransferCoordinator(nav: BaseNavigationController(title: "MAIN".localized, image: UIImage(name: .tab_home), tag: MainItems.main.rawValue, overrideInterfaceStyle: true))
    }()
    
    init(nav: BaseNavigationController) {
        self.nav = nav
        self.tabBar = BeforeAuthRootViewController()
        self.tabBar.coordinator = self
    }
    
    func goToLogin() {
        self.nav.popViewController(animated: true)
        self.parent?.navigateToLogin()
    }
    
    func start() {
        let items: [MainItems] = [.main, .history, .payments, .cards]
        var vcs: [UIViewController] = []
        for item in items {
            switch item {
            case .main:
                self.transferCoordinator.parent = self
                self.transferCoordinator.start()
                vcs.append(self.transferCoordinator.nav)
            case .history:
                let vc = BaseViewController(nibName: nil, bundle: nil)
                vc.tabBarItem.title = "HISTORY".localized
                vc.tabBarItem.image = UIImage(name: .tab_history)
                vc.tabBarItem.tag = item.rawValue
                vcs.append(vc)
            case .qr:
                let vc = BaseViewController(nibName: nil, bundle: nil)
                vc.tabBarItem.title = nil
                vc.tabBarItem.image = UIImage(name: .tab_qr)
                vc.tabBarItem.tag = item.rawValue
                vcs.append(vc)
            case .payments:
                let vc = BaseViewController(nibName: nil, bundle: nil)
                vc.tabBarItem.title = "PAYMENTS".localized
                vc.tabBarItem.image = UIImage(name: .tab_payments)
                vc.tabBarItem.tag = item.rawValue
                vcs.append(vc)
            case .cards:
                let vc = BaseViewController(nibName: nil, bundle: nil)
                vc.tabBarItem.title = "CARDS".localized
                vc.tabBarItem.image = UIImage(name: .tab_cards)
                vc.tabBarItem.tag = item.rawValue
                vcs.append(vc)
            }
        }
        self.tabBar.setViewControllers(vcs, animated: false)
        self.nav.pushViewController(self.tabBar, animated: true)
    }
}

class BeforeAuthRootViewController: BaseTabBarController, UITabBarControllerDelegate {
    
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
    weak var coordinator: BeforeAuthCoordinator?
    
    init() {
        super.init(overrideInterfaceStyle: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        print("BeforeAuthRootViewController")
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
        layer0.shadowOpacity = 0.6
        layer0.shadowRadius = 8
        layer0.shadowOffset = CGSize(width: 0, height: -2)
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
        if viewController.tabBarItem.tag != BeforeAuthCoordinator.MainItems.main.rawValue {
            self.showErrorAlert(title: "", message: "FOR_FULL_ACCESS_JOIN".localized)
        }
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
