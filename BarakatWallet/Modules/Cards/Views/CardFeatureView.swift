//
//  CardNewTypeCell.swift
//  BarakatWallet
//
//  Created by km1tj on 18/11/23.
//

import Foundation
import UIKit

class CardFeatureView: UIView {
    
    let iconView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let textView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 16)
        view.text = ""
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    
    init(text: String) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.addSubview(self.iconView)
        self.addSubview(self.textView)
        NSLayoutConstraint.activate([
            self.iconView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.iconView.topAnchor.constraint(equalTo: self.topAnchor),
            self.iconView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.iconView.widthAnchor.constraint(equalTo: self.iconView.heightAnchor, multiplier: 1),
            self.textView.leftAnchor.constraint(equalTo: self.iconView.rightAnchor, constant: 20),
            self.textView.topAnchor.constraint(equalTo: self.topAnchor),
            self.textView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.textView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.textView.centerYAnchor.constraint(equalTo: self.iconView.centerYAnchor),
        ])
        if Theme.current.dark {
            self.iconView.image = UIImage(name: .check_dark)
        } else {
            self.iconView.image = UIImage(name: .check_light)
        }
        self.textView.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
