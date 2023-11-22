//
//  CardActions.swift
//  BarakatWallet
//
//  Created by km1tj on 06/11/23.
//

import Foundation
import UIKit

class CardActionCell: UICollectionViewCell {
    
    let rootView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.layer.borderColor = Theme.current.borderColor.withAlphaComponent(0.3).cgColor
        view.layer.borderWidth = 0.5
        view.backgroundColor = Theme.current.plainTableCellColor
        return view
    }()
    let addCardLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 14)
        view.text = "ADD_CARD".localized
        view.textColor = Theme.current.primaryTextColor
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    let addImageView: CircleImageView = {
        let view = CircleImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = Theme.current.whiteColor
        view.contentMode = .scaleAspectFit
        view.image = UIImage(name: .add_bold)
        view.backgroundColor = Theme.current.tintColor
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
        self.rootView.addSubview(self.addImageView)
        NSLayoutConstraint.activate([
            self.rootView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Theme.current.mainPaddings),
            self.rootView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.rootView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.rootView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            self.addCardLabel.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
            self.addCardLabel.topAnchor.constraint(greaterThanOrEqualTo: self.rootView.topAnchor, constant: 0),
            self.addCardLabel.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -0),
            self.addCardLabel.bottomAnchor.constraint(equalTo: self.addImageView.topAnchor, constant: -4),
            self.addImageView.topAnchor.constraint(equalTo: self.rootView.centerYAnchor, constant: -4),
            self.addImageView.centerXAnchor.constraint(equalTo: self.rootView.centerXAnchor),
            self.addImageView.heightAnchor.constraint(equalTo: self.rootView.heightAnchor, multiplier: 0.30),
            self.addImageView.widthAnchor.constraint(equalTo: self.addImageView.heightAnchor, multiplier: 1),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        self.rootView.layer.borderColor = Theme.current.borderColor.withAlphaComponent(0.3).cgColor
        self.rootView.backgroundColor = Theme.current.plainTableCellColor
        self.addCardLabel.textColor = Theme.current.primaryTextColor
        self.addImageView.backgroundColor = Theme.current.tintColor
        self.addImageView.tintColor = Theme.current.whiteColor
        
        self.addCardLabel.text = title
    }
}
