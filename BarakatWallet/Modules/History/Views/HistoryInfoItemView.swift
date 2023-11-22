//
//  HistoryInfoItemView.swift
//  BarakatWallet
//
//  Created by km1tj on 11/11/23.
//

import Foundation
import UIKit

class HistoryInfoItemView: UIView {
    
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
        view.font = UIFont.regular(size: 14)
        view.textColor = Theme.current.primaryTextColor
        view.numberOfLines = 0
        view.textAlignment = .right
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        let line = UIView(backgroundColor: Theme.current.plainTableSeparatorColor)
        line.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
        self.addSubview(self.infoLabel)
        self.addSubview(line)
        NSLayoutConstraint.activate([
            self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: line.topAnchor, constant: -10),
            self.infoLabel.leftAnchor.constraint(equalTo: self.titleLabel.rightAnchor, constant: 10),
            self.infoLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.infoLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.infoLabel.bottomAnchor.constraint(lessThanOrEqualTo: line.topAnchor, constant: -10),
            line.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            line.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            line.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            line.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
