//
//  MainTopBarView.swift
//  BarakatWallet
//
//  Created by km1tj on 21/10/23.
//

import Foundation
import UIKit

class MainTopBarView: UIView {
    
    let headerView: HeaderView = {
        let view = HeaderView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    let accountInfoView: AccountInfoView = {
        let view = AccountInfoView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var shadowView: UIView = {
        let view = UIView()
        view.clipsToBounds = false
        view.backgroundColor = .clear
        return view
    }()
    private var cornerView: GradientView = {
        let view = GradientView()
        view.radius = 14
        view.backgroundColor = .clear
        view.startColor = Theme.current.mainGradientStartColor
        view.endColor = Theme.current.mainGradientEndColor
        view.startPoint = .init(x: 0.25, y: 0.5)
        view.endPoint = .init(x: 1, y: 0)
        return view
    }()
    private var shadowLayer: CALayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup() {
        self.backgroundColor = .clear
        self.addSubview(self.cornerView)
        self.addSubview(self.shadowView)
        self.addSubview(self.headerView)
        self.addSubview(self.accountInfoView)
        NSLayoutConstraint.activate([
            self.headerView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.headerView.topAnchor.constraint(equalTo: self.topAnchor, constant: UIApplication.statusBarHeight),
            self.headerView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 44),
            self.accountInfoView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.accountInfoView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 0),
            self.accountInfoView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.accountInfoView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
    }
    
    func themeChanged(newTheme: Theme) {
        self.updateShadow()
        self.cornerView.startColor = Theme.current.mainGradientStartColor
        self.cornerView.endColor = Theme.current.mainGradientEndColor
        self.headerView.themeChanged(newTheme: newTheme)
        self.accountInfoView.themeChanged(newTheme: newTheme)
    }
    
    private func updateShadow() {
        if self.shadowLayer == nil {
            self.shadowLayer = CALayer()
            self.shadowView.layer.addSublayer(self.shadowLayer!)
        }
        let shadowPath0 = UIBezierPath(roundedRect: self.shadowView.bounds, cornerRadius: 14)
        self.shadowLayer!.shadowPath = shadowPath0.cgPath
        self.shadowLayer!.shadowColor = Theme.current.shadowColor.cgColor
        self.shadowLayer!.shadowOpacity = 0.6
        self.shadowLayer!.shadowRadius = 8
        self.shadowLayer!.shadowOffset = CGSize(width: 0, height: 2)
        self.shadowLayer!.bounds = self.shadowView.bounds
        self.shadowLayer!.position = self.shadowView.center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.shadowView.frame = self.frame
        self.cornerView.frame = self.frame
        self.updateShadow()
    }
}
