//
//  TransferCardView.swift
//  BarakatWallet
//
//  Created by km1tj on 24/10/23.
//

import Foundation
import UIKit

class TransferCardView: UIControl {
    
    let rootView: GradientView = {
        let view = GradientView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.radius = 14
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.isUserInteractionEnabled = false
        return view
    }()
    let iconView: CircleImageView = {
        let view = CircleImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(name: .card_icon)
        view.layer.borderWidth = 1
        view.tintColor = .white
        view.clipsToBounds = true
        view.isUserInteractionEnabled = false
        return view
    }()
    let titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.bold(size: 16)
        view.isUserInteractionEnabled = false
        return view
    }()
    let subTitleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.bold(size: 14)
        view.isUserInteractionEnabled = false
        return view
    }()
    let logoImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = false
        return view
    }()
    let changeButton: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "CHANGE".localized
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.bold(size: 14)
        view.isUserInteractionEnabled = false
        return view
    }()
    public override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                self.rootView.alpha = 0.6
            } else {
                self.rootView.alpha = 1
            }
        }
    }
    public override var isEnabled: Bool {
        didSet {
            if !self.isEnabled {
                self.rootView.alpha = 0.6
            } else {
                self.rootView.alpha = 1
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(self.rootView)
        self.rootView.addSubview(self.iconView)
        self.rootView.addSubview(self.titleLabel)
        self.rootView.addSubview(self.subTitleLabel)
        self.rootView.addSubview(self.logoImageView)
        self.rootView.addSubview(self.changeButton)
        NSLayoutConstraint.activate([
            self.rootView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.rootView.topAnchor.constraint(equalTo: self.topAnchor),
            self.rootView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.rootView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.iconView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 24),
            self.iconView.topAnchor.constraint(greaterThanOrEqualTo: self.rootView.topAnchor, constant: 8),
            self.iconView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -8),
            self.iconView.heightAnchor.constraint(equalToConstant: 40),
            self.iconView.widthAnchor.constraint(equalTo: self.iconView.heightAnchor, multiplier: 1),
            self.titleLabel.leftAnchor.constraint(equalTo: self.iconView.rightAnchor, constant: 24),
            self.titleLabel.topAnchor.constraint(greaterThanOrEqualTo: self.rootView.topAnchor, constant: 8),
            self.titleLabel.rightAnchor.constraint(equalTo: self.changeButton.leftAnchor, constant: -10),
            self.subTitleLabel.leftAnchor.constraint(equalTo: self.iconView.rightAnchor, constant: 24),
            self.subTitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 2),
            self.subTitleLabel.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -8),
            self.logoImageView.leftAnchor.constraint(equalTo: self.subTitleLabel.rightAnchor, constant: 6),
            self.logoImageView.rightAnchor.constraint(lessThanOrEqualTo: self.changeButton.leftAnchor, constant: 10),
            self.logoImageView.widthAnchor.constraint(equalTo: self.logoImageView.heightAnchor, multiplier: 2),
            self.logoImageView.heightAnchor.constraint(equalToConstant: 14),
            self.logoImageView.centerYAnchor.constraint(equalTo: self.subTitleLabel.centerYAnchor, constant: 0),
            self.changeButton.topAnchor.constraint(greaterThanOrEqualTo: self.rootView.topAnchor, constant: 8),
            self.changeButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -24),
            self.changeButton.bottomAnchor.constraint(lessThanOrEqualTo: self.rootView.bottomAnchor, constant: -8),
            self.changeButton.centerYAnchor.constraint(equalTo: self.iconView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TransferCardNumberView: UIControl {
    
    let rootView: GradientView = {
        let view = GradientView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.radius = 14
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.isUserInteractionEnabled = false
        return view
    }()
    let iconView: CircleImageView = {
        let view = CircleImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(name: .wallet_inset)
        view.layer.borderWidth = 1
        view.tintColor = Theme.current.tintColor
        view.clipsToBounds = true
        view.isUserInteractionEnabled = false
        return view
    }()
    let titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.bold(size: 16)
        view.isUserInteractionEnabled = false
        return view
    }()
    let subTitleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.secondaryTextColor
        view.font = UIFont.regular(size: 14)
        view.isUserInteractionEnabled = false
        return view
    }()
    let numberLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.bold(size: 16)
        view.isUserInteractionEnabled = false
        return view
    }()
    let accountLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.bold(size: 12)
        view.isUserInteractionEnabled = false
        return view
    }()
    let logoImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = false
        return view
    }()
    let changeButton: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "CHANGE".localized
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.bold(size: 14)
        view.textAlignment = .right
        view.isUserInteractionEnabled = false
        return view
    }()
    public override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                self.rootView.alpha = 0.6
            } else {
                self.rootView.alpha = 1
            }
        }
    }
    public override var isEnabled: Bool {
        didSet {
            if !self.isEnabled {
                self.rootView.alpha = 0.6
            } else {
                self.rootView.alpha = 1
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(self.rootView)
        self.rootView.addSubview(self.iconView)
        self.rootView.addSubview(self.titleLabel)
        self.rootView.addSubview(self.subTitleLabel)
        self.rootView.addSubview(self.numberLabel)
        self.rootView.addSubview(self.accountLabel)
        self.rootView.addSubview(self.logoImageView)
        self.rootView.addSubview(self.changeButton)
        NSLayoutConstraint.activate([
            self.rootView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.rootView.topAnchor.constraint(equalTo: self.topAnchor),
            self.rootView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.rootView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.iconView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 24),
            self.iconView.topAnchor.constraint(equalTo: self.titleLabel.topAnchor, constant: 0),
            self.iconView.bottomAnchor.constraint(lessThanOrEqualTo: self.rootView.bottomAnchor, constant: -8),
            self.iconView.heightAnchor.constraint(equalToConstant: 40),
            self.iconView.widthAnchor.constraint(equalTo: self.iconView.heightAnchor, multiplier: 1),
            self.titleLabel.leftAnchor.constraint(equalTo: self.iconView.rightAnchor, constant: 24),
            self.titleLabel.topAnchor.constraint(greaterThanOrEqualTo: self.rootView.topAnchor, constant: 8),
            self.titleLabel.rightAnchor.constraint(lessThanOrEqualTo: self.changeButton.leftAnchor, constant: -10),
            self.subTitleLabel.leftAnchor.constraint(equalTo: self.iconView.rightAnchor, constant: 24),
            self.subTitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 2),
            self.subTitleLabel.rightAnchor.constraint(lessThanOrEqualTo: self.changeButton.leftAnchor, constant: -10),
            self.numberLabel.leftAnchor.constraint(equalTo: self.iconView.rightAnchor, constant: 24),
            self.numberLabel.topAnchor.constraint(equalTo: self.subTitleLabel.bottomAnchor, constant: 2),
            self.numberLabel.rightAnchor.constraint(lessThanOrEqualTo: self.changeButton.leftAnchor, constant: -10),
            self.accountLabel.leftAnchor.constraint(equalTo: self.iconView.rightAnchor, constant: 24),
            self.accountLabel.topAnchor.constraint(equalTo: self.numberLabel.bottomAnchor, constant: 2),
            self.accountLabel.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -8),
            self.logoImageView.leftAnchor.constraint(equalTo: self.accountLabel.rightAnchor, constant: 6),
            self.logoImageView.rightAnchor.constraint(lessThanOrEqualTo: self.changeButton.leftAnchor, constant: 10),
            self.logoImageView.widthAnchor.constraint(equalTo: self.logoImageView.heightAnchor, multiplier: 2),
            self.logoImageView.heightAnchor.constraint(equalToConstant: 14),
            self.logoImageView.centerYAnchor.constraint(equalTo: self.accountLabel.centerYAnchor, constant: 0),
            self.changeButton.topAnchor.constraint(greaterThanOrEqualTo: self.rootView.topAnchor, constant: 8),
            self.changeButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -24),
            self.changeButton.bottomAnchor.constraint(lessThanOrEqualTo: self.rootView.bottomAnchor, constant: -8),
            self.changeButton.centerYAnchor.constraint(equalTo: self.iconView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
