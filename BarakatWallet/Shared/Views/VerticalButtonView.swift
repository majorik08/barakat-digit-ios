//
//  VerticalButtonView.swift
//  BarakatWallet
//
//  Created by km1tj on 25/10/23.
//

import Foundation
import UIKit

class VerticalButtonView: UIControl {
    
    let iconView: CircleImageView = {
        let view = CircleImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    let nameView: GradientLabel = {
        let view = GradientLabel(shadowEnabled: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 14)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
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
            self.iconView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.68),
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
