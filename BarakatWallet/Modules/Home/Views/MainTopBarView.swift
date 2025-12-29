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
        return HeaderView(frame: .zero)
    }()
    let accountInfoView: AccountInfoView = {
        return AccountInfoView()
    }()
    let storiesView: StoriesView = {
        return StoriesView(frame: .zero)
    }()
    private var shadowView: UIView = {
        let view = UIView()
        view.clipsToBounds = false
        view.backgroundColor = .clear
        return view
    }()
    private var cornerView: GradientView = {
        let view = GradientView()
        view.radius = 24 // Larger modern radius
        view.backgroundColor = .clear
        view.startColor = Theme.current.mainGradientStartColor
        view.endColor = Theme.current.mainGradientEndColor
        view.startPoint = .init(x: 0, y: 0)
        view.endPoint = .init(x: 1, y: 1) // Diagonal gradient for modern look
        return view
    }()
    private var shadowLayer: CALayer?
    
    init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.addSubview(self.cornerView)
        self.addSubview(self.shadowView)
        self.addSubview(self.headerView)
        self.addSubview(self.accountInfoView)
        self.addSubview(self.storiesView)
        NSLayoutConstraint.activate([
            self.headerView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.headerView.topAnchor.constraint(equalTo: self.topAnchor, constant: UIApplication.statusBarHeight),
            self.headerView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 44),
            self.accountInfoView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.accountInfoView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 0),
            self.accountInfoView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.accountInfoView.heightAnchor.constraint(equalToConstant: 66),
            self.storiesView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.storiesView.topAnchor.constraint(equalTo: self.accountInfoView.bottomAnchor, constant: 0),
            self.storiesView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.storiesView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
    }
    
    func configure(viewModel: HomeViewModel) {
        self.headerView.avatarView.loadImage(filePath: viewModel.accountInfo.client.avatar)
        if Constants.HideBalanceInMain {
            self.accountInfoView.balanceLabel.text = "**** с."
            self.accountInfoView.bonusLabel.text = "\(viewModel.accountInfo.bonusBalance) с. \("BONUSES".localized)"
        } else {
            self.accountInfoView.balanceLabel.text = "\(viewModel.accountInfo.walletBalance) с."
            self.accountInfoView.bonusLabel.text = "\(viewModel.accountInfo.bonusBalance) с. \("BONUSES".localized)"
        }
    }
    
    func themeChanged(newTheme: Theme) {
        self.updateShadow()
        self.cornerView.startColor = Theme.current.mainGradientStartColor
        self.cornerView.endColor = Theme.current.mainGradientEndColor
        self.headerView.themeChanged(newTheme: newTheme)
        self.accountInfoView.themeChanged(newTheme: newTheme)
        self.storiesView.themeChanged(newTheme: newTheme)
    }
    
    func languageChanged() {
        self.headerView.searchView.languageChanged()
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
