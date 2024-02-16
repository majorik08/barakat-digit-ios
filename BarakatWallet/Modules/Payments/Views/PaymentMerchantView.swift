//
//  PaymentMerchantView.swift
//  BarakatWallet
//
//  Created by km1tj on 04/02/24.
//

import Foundation
import UIKit

class PaymentMerchantView: UIView {
    
    let imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(name: .qr_button)
        view.tintColor = Theme.current.tintColor
        return view
    }()
    let titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 14)
        view.textColor = Theme.current.tintColor
        view.numberOfLines = 0
        return view
    }()
    let infoLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 18)
        view.textColor = Theme.current.secondaryTextColor
        view.numberOfLines = 0
        return view
    }()
    
    init(title: String, info: String, image: String?) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = Theme.current.plainTableCellColor
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.addSubview(self.imageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.infoLabel)
        NSLayoutConstraint.activate([
            self.imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.imageView.heightAnchor.constraint(equalToConstant: 36),
            self.imageView.widthAnchor.constraint(equalToConstant: 36),
            self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.titleLabel.leftAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: 16),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            self.infoLabel.leftAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: 16),
            self.infoLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 0),
            self.infoLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            self.infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6),
        ])
        self.titleLabel.text = title
        self.infoLabel.text = info
        if let image  {
            self.imageView.loadImage(filePath: image)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
