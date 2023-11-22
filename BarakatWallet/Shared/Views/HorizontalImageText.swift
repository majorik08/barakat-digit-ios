//
//  HorizontalImageText.swift
//  BarakatWallet
//
//  Created by km1tj on 11/11/23.
//

import Foundation
import UIKit

class HorizontalImageText: UIView {
    
    let iconView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let textView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 16)
        view.text = "Service"
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.minimumScaleFactor = 0.7
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.addSubview(self.iconView)
        self.addSubview(self.textView)
        NSLayoutConstraint.activate([
            self.iconView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.iconView.topAnchor.constraint(equalTo: self.topAnchor),
            self.iconView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.iconView.widthAnchor.constraint(equalTo: self.iconView.heightAnchor, multiplier: 1),
            self.textView.leftAnchor.constraint(equalTo: self.iconView.rightAnchor, constant: 10),
            self.textView.topAnchor.constraint(equalTo: self.topAnchor),
            self.textView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.textView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.textView.centerYAnchor.constraint(equalTo: self.iconView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
