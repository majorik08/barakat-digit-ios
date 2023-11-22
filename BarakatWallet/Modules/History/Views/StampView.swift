//
//  RecipView.swift
//  BarakatWallet
//
//  Created by km1tj on 11/11/23.
//

import Foundation
import UIKit

class StampView: UIView {
    
    let titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 16)
        view.textColor = Theme.current.tintColor
        view.numberOfLines = 0
        view.textAlignment = .center
        view.text = "STAMP_TEXT".localized
        return view
    }()
    let payTypeLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 16)
        view.textColor = Theme.current.tintColor
        view.numberOfLines = 0
        view.textAlignment = .center
        view.text = "ЭЛЕКТРОННЫЙ ПЛАТЕЖ"
        return view
    }()
    let payStatusLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 18)
        view.textColor = Theme.current.tintColor
        view.numberOfLines = 0
        view.textAlignment = .center
        view.text = "ИСПОЛНЕННО"
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.layer.borderColor = Theme.current.borderColor.cgColor
        self.layer.borderWidth = 1
        self.clipsToBounds = true
        let line = UIView(backgroundColor: Theme.current.borderColor)
        line.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
        self.addSubview(line)
        self.addSubview(self.payTypeLabel)
        self.addSubview(self.payStatusLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            self.titleLabel.bottomAnchor.constraint(equalTo: line.topAnchor, constant: -20),
            self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            line.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            line.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            line.heightAnchor.constraint(equalToConstant: 1),
            self.payTypeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.payTypeLabel.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 20),
            self.payTypeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.payStatusLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.payStatusLabel.topAnchor.constraint(equalTo: self.payTypeLabel.bottomAnchor, constant: 0),
            self.payStatusLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.payStatusLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
