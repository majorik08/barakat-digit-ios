//
//  CardActionButton.swift
//  BarakatWallet
//
//  Created by km1tj on 18/11/23.
//

import Foundation
import UIKit

class CardActionButton: UIControl {
    
    let iconView: GradientImageView = {
        let view = GradientImageView(insets: .zero)
        view.circleImage = false
        view.imageView.contentMode = .scaleAspectFit
        view.imageView.tintColor = Theme.current.whiteColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.isUserInteractionEnabled = false
        return view
    }()
    let nameView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 12)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.textColor = Theme.current.primaryTextColor
        return view
    }()
    
    public override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                self.alpha = 0.8
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
                self.alpha = 0.8
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(self.iconView)
        self.addSubview(self.nameView)
        NSLayoutConstraint.activate([
            self.iconView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.iconView.topAnchor.constraint(equalTo: self.topAnchor),
            self.iconView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.64),
            self.iconView.widthAnchor.constraint(equalTo: self.iconView.heightAnchor, multiplier: 1),
            self.nameView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.nameView.topAnchor.constraint(equalTo: self.iconView.bottomAnchor, constant: 10),
            self.nameView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.nameView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func themeChanged(newTheme: Theme) {
        self.nameView.textColor = Theme.current.primaryTextColor
    }
}
