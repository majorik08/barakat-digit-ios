//
//  TransferTypeView.swift
//  BarakatWallet
//
//  Created by km1tj on 24/10/23.
//

import Foundation
import UIKit

class TransferTypeView: UIControl {
    
    let iconView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    let nameView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 16)
        view.textColor = Theme.current.primaryTextColor
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
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
            self.iconView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.iconView.topAnchor.constraint(equalTo: self.topAnchor),
            self.iconView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.iconView.heightAnchor.constraint(equalTo: self.iconView.widthAnchor, multiplier: 1),
            self.nameView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.nameView.topAnchor.constraint(equalTo: self.iconView.bottomAnchor),
            self.nameView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.nameView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func themeChanged(newTheme: Theme) {
        self.nameView.textColor = Theme.current.primaryTextColor
    }
}
