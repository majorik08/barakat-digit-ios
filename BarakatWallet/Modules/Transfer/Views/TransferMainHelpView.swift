//
//  TransferMainHelpView.swift
//  BarakatWallet
//
//  Created by km1tj on 23/10/23.
//

import Foundation
import UIKit

class TransferMainHelpView: UIView {
    
    let imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(name: .transfer_help)
        view.contentMode = .scaleAspectFit
        return view
    }()
    let titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 20)
        view.textColor = .white
        view.textAlignment = .center
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    let subTitleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 16)
        view.textColor = .white
        view.textAlignment = .center
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Theme.current.dark ? .black : .white
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 14
        self.layer.shadowColor = Theme.current.shadowColor.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 2
        self.layer.shadowOffset = CGSize(width: 2, height: 4)
        self.layer.borderColor = Theme.current.secondTintColor.cgColor
        self.layer.borderWidth = 1
        self.addSubview(self.imageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.subTitleLabel)
        NSLayoutConstraint.activate([
            self.imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            self.imageView.widthAnchor.constraint(equalTo: self.imageView.heightAnchor, multiplier: 1),
            self.titleLabel.leftAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: 16),
            self.titleLabel.topAnchor.constraint(equalTo: self.imageView.topAnchor, constant: 0),
            self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.subTitleLabel.leftAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: 16),
            self.subTitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            self.subTitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.subTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func themeChanged(newTheme: Theme) {
        
    }
}
