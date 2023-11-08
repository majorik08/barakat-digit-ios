//
//  CardActions.swift
//  BarakatWallet
//
//  Created by km1tj on 06/11/23.
//

import Foundation
import UIKit

class CardActionCell: UICollectionViewCell {
    
    let rootView: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.layer.borderColor = Theme.current.secondTintColor.withAlphaComponent(0.3).cgColor
        view.layer.borderWidth = 0.5
        view.startColor = Theme.current.cardGradientStartColor
        view.endColor = Theme.current.cardGradientEndColor
        return view
    }()
    let addCardLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 17)
        view.text = "ADD_CARD".localized
        view.textColor = Theme.current.tintColor
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    override var isHighlighted: Bool {
        didSet {
            self.rootView.alpha = self.isHighlighted ? 0.5 : 1
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.addSubview(self.rootView)
        self.rootView.addSubview(self.addCardLabel)
        NSLayoutConstraint.activate([
            self.rootView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8),
            self.rootView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.rootView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -8),
            self.rootView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            self.addCardLabel.leftAnchor.constraint(equalTo: self.rootView.leftAnchor),
            self.addCardLabel.topAnchor.constraint(equalTo: self.rootView.topAnchor),
            self.addCardLabel.rightAnchor.constraint(equalTo: self.rootView.rightAnchor),
            self.addCardLabel.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(title: String) {
        self.addCardLabel.text = title
    }
}
