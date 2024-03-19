//
//  PayWithNumberCell.swift
//  BarakatWallet
//
//  Created by km1tj on 21/10/23.
//

import Foundation
import UIKit

class PayWithNumberCell: UICollectionViewCell {
    
    let titleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.medium(size: 16)
        view.text = "PAY_WITH_NUMBER".localized
        return view
    }()
    let searchView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 2
        view.layer.borderColor = Theme.current.borderColor.cgColor
        return view
    }()
    let iconView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = Theme.current.borderColor
        view.contentMode = .scaleAspectFit
        view.image = UIImage(name: .add_number)
        return view
    }()
    let labelView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "+992"
        view.font = UIFont.medium(size: 18)
        view.textColor = Theme.current.secondaryTextColor
        return view
    }()
    weak var delegate: HomeViewControllerItemDelegate? = nil
    
    override var isHighlighted: Bool {
        didSet {
            self.searchView.alpha = self.isHighlighted ? 0.5 : 1
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.addSubview(self.titleView)
        self.contentView.addSubview(self.searchView)
        self.searchView.addSubview(self.labelView)
        self.searchView.addSubview(self.iconView)
        NSLayoutConstraint.activate([
            self.titleView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Theme.current.mainPaddings),
            self.titleView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            self.titleView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.titleView.heightAnchor.constraint(equalToConstant: 18),
            self.searchView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Theme.current.mainPaddings),
            self.searchView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 8),
            self.searchView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.searchView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            self.labelView.leftAnchor.constraint(equalTo: self.searchView.leftAnchor, constant: 10),
            self.labelView.topAnchor.constraint(equalTo: self.searchView.topAnchor, constant: 8),
            self.labelView.bottomAnchor.constraint(equalTo: self.searchView.bottomAnchor, constant: -8),
            self.iconView.leftAnchor.constraint(greaterThanOrEqualTo: self.labelView.rightAnchor, constant: -10),
            self.iconView.topAnchor.constraint(equalTo: self.searchView.topAnchor, constant: 14),
            self.iconView.rightAnchor.constraint(equalTo: self.searchView.rightAnchor, constant: -8),
            self.iconView.bottomAnchor.constraint(equalTo: self.searchView.bottomAnchor, constant: -14),
            self.iconView.widthAnchor.constraint(equalTo: self.iconView.heightAnchor, multiplier: 1)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.titleView.text = "PAY_WITH_NUMBER".localized
        self.titleView.textColor = Theme.current.primaryTextColor
        self.iconView.tintColor = Theme.current.borderColor
        self.labelView.textColor = Theme.current.secondaryTextColor
    }
}
