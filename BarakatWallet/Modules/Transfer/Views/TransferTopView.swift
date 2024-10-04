//
//  TransferTopView.swift
//  BarakatWallet
//
//  Created by km1tj on 23/10/23.
//

import Foundation
import UIKit

class TransferTopView: UIView {
    
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
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        view.startColor = Theme.current.mainGradientStartColor
        view.endColor = Theme.current.mainGradientEndColor
        return view
    }()
    let backButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(name: .back_arrow), for: .normal)
        view.tintColor = Theme.current.primaryTextColor
        return view
    }()
    let titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 20)
        view.textColor = .white
        view.textAlignment = .center
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    let subTitleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 16)
        view.textColor = .white
        view.textAlignment = .center
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
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
        self.addSubview(self.backButton)
        self.addSubview(self.titleLabel)
        self.addSubview(self.subTitleLabel)
        NSLayoutConstraint.activate([
            self.backButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            self.backButton.topAnchor.constraint(equalTo: self.topAnchor, constant: UIApplication.statusBarHeight + 10),
            self.backButton.heightAnchor.constraint(equalToConstant: 28),
            self.backButton.widthAnchor.constraint(equalToConstant: 28),
            self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 48),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: UIApplication.statusBarHeight + 10),
            self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -48),
            self.subTitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 24),
            self.subTitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            self.subTitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -24),
            self.subTitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -10),
        ])
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
