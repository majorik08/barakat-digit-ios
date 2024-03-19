//
//  ProfileTopBar.swift
//  BarakatWallet
//
//  Created by km1tj on 30/10/23.
//

import Foundation
import UIKit

class ProfileAlertView: UIView {

    let infoLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 12)
        view.textColor = .black
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    func setup() {
        self.backgroundColor = UIColor(red: 1.00, green: 0.80, blue: 0.35, alpha: 1.00)
        self.clipsToBounds = true
        self.layer.cornerRadius = 14
        self.addSubview(self.infoLabel)
        NSLayoutConstraint.activate([
            self.infoLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Theme.current.mainPaddings),
            self.infoLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 40),
            self.infoLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Theme.current.mainPaddings),
            self.infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
}

class ProfileTopBar: UIView {
    
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
    let backButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(name: .back_arrow), for: .normal)
        view.tintColor = Theme.current.primaryTextColor
        return view
    }()
    let avatarView: AvatarImageView = {
        let view = AvatarImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 14)
        view.textColor = .white
        view.text = "WALLET_NUMBER".localized
        return view
    }()
    let subTitleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 24)
        view.textColor = .white
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.5
        view.text = "+992"
        return view
    }()
    let statusView: StatusView = {
        let view = StatusView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.current.plainTableCellColor
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
        self.addSubview(self.avatarView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.subTitleLabel)
        self.addSubview(self.statusView)
        NSLayoutConstraint.activate([
            self.backButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.backButton.topAnchor.constraint(equalTo: self.topAnchor, constant: UIApplication.statusBarHeight),
            self.backButton.heightAnchor.constraint(equalToConstant: 28),
            self.backButton.widthAnchor.constraint(equalToConstant: 28),
            self.avatarView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Theme.current.mainPaddings),
            self.avatarView.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 10),
            self.avatarView.heightAnchor.constraint(equalToConstant: 74),
            self.avatarView.widthAnchor.constraint(equalToConstant: 74),
            self.titleLabel.leftAnchor.constraint(equalTo: self.avatarView.rightAnchor, constant: 20),
            self.titleLabel.topAnchor.constraint(equalTo: self.avatarView.topAnchor, constant: 10),
            self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Theme.current.mainPaddings),
            self.subTitleLabel.leftAnchor.constraint(equalTo: self.avatarView.rightAnchor, constant: 20),
            self.subTitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 6),
            self.subTitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Theme.current.mainPaddings),
            self.statusView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Theme.current.mainPaddings),
            self.statusView.topAnchor.constraint(equalTo: self.avatarView.bottomAnchor, constant: 20),
            self.statusView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Theme.current.mainPaddings),
            self.statusView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
            self.statusView.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
    
    func themeChanged(newTheme: Theme) {
        self.updateShadow()
        self.statusView.themeChanged(theme: newTheme)
        self.cornerView.startColor = Theme.current.mainGradientStartColor
        self.cornerView.endColor = Theme.current.mainGradientEndColor
    }
    
    func languageChanged() {
        self.titleLabel.text = "WALLET_NUMBER".localized
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

class StatusView: UIControl {
    
    let iconView: GradientImageView = {
        let view = GradientImageView(insets: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageView.image = UIImage(name: .profile_add)
        view.tintColor = .white
        view.isUserInteractionEnabled = false
        return view
    }()
    let titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 17)
        view.textColor = Theme.current.primaryTextColor
        view.text = "ID_STATUS".localized
        return view
    }()
    let subTitleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 17)
        view.textColor = .systemRed
        view.text = "ID_NOT_IDENTIFY".localized
        return view
    }()
    
    public override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                self.alpha = 0.6
            } else {
                self.alpha = 1
            }
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            if self.isEnabled {
                self.alpha = 1
            } else {
                self.alpha = 0.6
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.iconView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.subTitleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.titleLabel.rightAnchor.constraint(equalTo: self.iconView.leftAnchor, constant: -20),
            self.subTitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            self.subTitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 4),
            self.subTitleLabel.rightAnchor.constraint(equalTo: self.iconView.leftAnchor, constant: -20),
            self.subTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            self.iconView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.iconView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            self.iconView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            self.iconView.widthAnchor.constraint(equalTo: self.iconView.heightAnchor, multiplier: 1),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func themeChanged(theme: Theme) {
        self.backgroundColor = Theme.current.plainTableCellColor
        self.iconView.startColor = Theme.current.mainGradientStartColor
        self.iconView.endColor = Theme.current.mainGradientEndColor
        self.titleLabel.textColor = Theme.current.primaryTextColor
    }
    
    func configure(limits: AppStructs.ClientInfo.Limit) {
        self.titleLabel.text = "ID_STATUS".localized
        switch limits.identifyed {
        case .noIdentified:
            self.iconView.imageView.image = UIImage(name: .status_one)
            self.subTitleLabel.textColor = .systemRed
            self.subTitleLabel.text = "ID_NOT_IDENTIFY".localized
        case .onlineIdentified:
            self.iconView.imageView.image = UIImage(name: .status_two)
            self.subTitleLabel.textColor = Theme.current.tintColor
            self.subTitleLabel.text = "IDENTIFY_ONLINE".localized
        case .identified:
            self.iconView.imageView.image = UIImage(name: .status_three)
            self.subTitleLabel.textColor = Theme.current.tintColor
            self.subTitleLabel.text = "IDENTIFIED".localized
        }
    }
}
