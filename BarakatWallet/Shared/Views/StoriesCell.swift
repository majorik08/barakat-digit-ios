//
//  StoriesCell.swift
//  BarakatWallet
//
//  Created by km1tj on 22/10/23.
//

import Foundation
import UIKit

class StoriesCell: UICollectionViewCell {
    
    let rootView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.backgroundColor = Theme.current.secondTintColor
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 0.5
        view.clipsToBounds = true
        return view
    }()
    let mainImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.backgroundColor = .clear
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
        self.rootView.addSubview(self.mainImage)
        NSLayoutConstraint.activate([
            self.rootView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 2),
            self.rootView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 2),
            self.rootView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -2),
            self.rootView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -2),
            self.mainImage.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
            self.mainImage.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 0),
            self.mainImage.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
            self.mainImage.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
