//
//  PaymentResultItemView.swift
//  BarakatWallet
//
//  Created by km1tj on 03/02/24.
//

import Foundation
import UIKit

class PaymentResultItemView: UIView {
    
    let titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 14)
        view.textColor = Theme.current.secondaryTextColor
        view.numberOfLines = 0
        return view
    }()
    let infoLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 18)
        view.textColor = Theme.current.tintColor
        view.numberOfLines = 0
        return view
    }()
    
    init(title: String, info: String) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.addSubview(self.titleLabel)
        self.addSubview(self.infoLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.infoLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.infoLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 2),
            self.infoLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])
        self.titleLabel.text = title
        self.infoLabel.text = info
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
