//
//  LaunchTopView.swift
//  BarakatWallet
//
//  Created by km1tj on 22/10/23.
//

import Foundation
import UIKit

class LaunchTopView: UIView {
    
    private var shadowView: UIView = {
        let view = UIView()
        view.clipsToBounds = false
        view.backgroundColor = .clear
        return view
    }()
    private var cornerView: GradientView = {
        let view = GradientView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 14
        view.backgroundColor = .clear
        view.startColor = Theme.current.mainGradientStartColor
        view.endColor = Theme.current.mainGradientEndColor
        return view
    }()
    private let appIcon: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(name: .app_logo)
        view.tintColor = .white
        view.contentMode = .scaleAspectFit
        return view
    }()
    private let appNameLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.text = Constants.AppName
        view.font = UIFont.regular(size: 16)
        view.textAlignment = .center
        return view
    }()
    private let appInfoLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.text = "WELLCOME_TO_APP".localized
        view.font = UIFont.regular(size: 16)
        view.textAlignment = .center
        return view
    }()
    let storiesView: StoriesView = {
        let view = StoriesView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let pageControl: AdvancedPageControlView = {
        let view = AdvancedPageControlView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var shadowLayer: CALayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    func setup() {
        self.backgroundColor = .clear
        self.addSubview(self.cornerView)
        self.addSubview(self.shadowView)
        self.addSubview(self.appIcon)
        self.addSubview(self.appNameLabel)
        self.addSubview(self.appInfoLabel)
        self.addSubview(self.storiesView)
        self.addSubview(self.pageControl)
        NSLayoutConstraint.activate([
            self.appIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: UIApplication.statusBarHeight + 20),
            self.appIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.appIcon.heightAnchor.constraint(equalToConstant: 70),
            self.appIcon.widthAnchor.constraint(equalToConstant: 70),
            self.appNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.appNameLabel.topAnchor.constraint(equalTo: self.appIcon.bottomAnchor, constant: 6),
            self.appNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.appInfoLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.appInfoLabel.topAnchor.constraint(equalTo: self.appNameLabel.bottomAnchor, constant: 16),
            self.appInfoLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.storiesView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.storiesView.topAnchor.constraint(equalTo: self.appInfoLabel.bottomAnchor, constant: 14),
            self.storiesView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.pageControl.topAnchor.constraint(equalTo: self.storiesView.bottomAnchor, constant: 20),
            self.pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            self.pageControl.heightAnchor.constraint(equalToConstant: 12),
            self.pageControl.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
            self.pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
        ])
        self.pageControl.drawer = ExtendedDotDrawer(numberOfPages: 1, space: 8, indicatorColor: .white, dotsColor: .white, isBordered: false, borderWidth: 0.0, indicatorBorderColor: .clear, indicatorBorderWidth: 0.0)
    }
    
    func themeChanged(newTheme: Theme) {
        self.updateShadow()
    }
    
    private func updateShadow() {
        if self.shadowLayer == nil {
            self.shadowLayer = CALayer()
            self.shadowView.layer.addSublayer(self.shadowLayer!)
        }
        let shadowPath0 = UIBezierPath(roundedRect: self.shadowView.bounds, cornerRadius: 14)
        self.shadowLayer!.shadowPath = shadowPath0.cgPath
        self.shadowLayer!.shadowColor = UIColor(red: 0.204, green: 0.584, blue: 0.918, alpha: 0.38).cgColor
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
