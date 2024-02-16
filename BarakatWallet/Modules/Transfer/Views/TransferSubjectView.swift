//
//  TransferSubjectView.swift
//  BarakatWallet
//
//  Created by km1tj on 16/02/24.
//

import Foundation
import UIKit

class TransferSubjectView: UIView {
    
    let titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 14)
        view.textColor = Theme.current.secondaryTextColor
        return view
    }()
    let subTitleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 16)
        view.textColor = Theme.current.tintColor
        return view
    }()
    let itemIcon: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    let typeIcon: CircleImageView = {
        let view = CircleImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.tintColor = Theme.current.tintColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
        self.addSubview(self.subTitleLabel)
        self.addSubview(self.itemIcon)
        self.addSubview(self.typeIcon)
        NSLayoutConstraint.activate([
            self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.titleLabel.rightAnchor.constraint(equalTo: self.subTitleLabel.rightAnchor, constant: 0),
            self.subTitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.subTitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 0),
            self.subTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            self.itemIcon.leftAnchor.constraint(equalTo: self.subTitleLabel.rightAnchor, constant: 10),
            self.itemIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.itemIcon.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),
            self.itemIcon.widthAnchor.constraint(equalTo: self.itemIcon.heightAnchor, multiplier: 1.4),
            self.typeIcon.leftAnchor.constraint(equalTo: self.itemIcon.rightAnchor, constant: 10),
            self.typeIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.typeIcon.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            self.typeIcon.widthAnchor.constraint(equalTo: self.typeIcon.heightAnchor, multiplier: 1),
            self.typeIcon.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
