//
//  MainEmptyView.swift
//  BarakatWallet
//
//  Created by km1tj on 08/11/23.
//

import Foundation
import UIKit

class MainEmptyView: UIView {
    
    let titleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.secondaryTextColor
        view.font = UIFont.medium(size: 14)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.textAlignment = .center
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.layer.borderColor = Theme.current.secondTintColor.withAlphaComponent(0.3).cgColor
        self.layer.borderWidth = 0.5
        self.backgroundColor = Theme.current.plainTableCellColor
        self.addSubview(self.titleView)
        NSLayoutConstraint.activate([
            self.titleView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.titleView.topAnchor.constraint(equalTo: self.topAnchor),
            self.titleView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.titleView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
