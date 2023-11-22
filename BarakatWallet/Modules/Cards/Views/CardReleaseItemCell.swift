//
//  CardReleaseItemCell.swift
//  BarakatWallet
//
//  Created by km1tj on 19/11/23.
//

import Foundation
import UIKit

class CardReleaseItemCell: UICollectionViewCell {
    
    let rootView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    let imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.backgroundColor = Theme.current.cardGradientStartColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    let titleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.medium(size: 12)
        view.numberOfLines = 0
        return view
    }()
    let subTitleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.secondaryTextColor
        view.font = UIFont.medium(size: 12)
        view.numberOfLines = 0
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
        self.rootView.addSubview(self.imageView)
        self.rootView.addSubview(self.titleView)
        self.rootView.addSubview(self.subTitleView)
        NSLayoutConstraint.activate([
            self.rootView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0),
            self.rootView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            self.rootView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0),
            self.rootView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            self.imageView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.imageView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 6),
            self.imageView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -6),
            self.imageView.widthAnchor.constraint(equalTo: self.imageView.heightAnchor, multiplier: 1.6),
            self.titleView.leftAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: 16),
            self.titleView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 6),
            self.titleView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.subTitleView.leftAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: 16),
            self.subTitleView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 0),
            self.subTitleView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.subTitleView.bottomAnchor.constraint(lessThanOrEqualTo: self.rootView.bottomAnchor, constant: -6),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(item: AppStructs.CreditDebitCardItem) {
        self.imageView.backgroundColor = Theme.current.cardGradientStartColor
        self.titleView.textColor = Theme.current.primaryTextColor
        self.subTitleView.textColor = Theme.current.secondaryTextColor
        self.titleView.text = "\(item.name)\nДействует 3 года\n0% на остаток"
        self.subTitleView.text = "Стоимость: 10 сомони\nСтраховой депозит 00.00 сомони"
    }
}
