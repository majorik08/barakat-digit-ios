//
//  ProfileTabelCell.swift
//  BarakatWallet
//
//  Created by km1tj on 30/10/23.
//

import Foundation
import UIKit

class ProfileTabelCell: UITableViewCell {
    
    let rootView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        view.layer.borderColor = Theme.current.secondTintColor.withAlphaComponent(0.3).cgColor
        view.layer.borderWidth = 0.5
        view.backgroundColor = Theme.current.plainTableCellColor
        return view
    }()
    let iconView: GradientImageView = {
        let view = GradientImageView(insets: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageView.image = UIImage(name: .profile_add)
        view.tintColor = .white
        return view
    }()
    let titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 17)
        view.textColor = Theme.current.primaryTextColor
        view.text = "Title"
        return view
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        self.rootView.alpha = selected ? 0.5 : 1
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        self.rootView.alpha = highlighted ? 0.5 : 1
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .none
        self.separatorInset = .zero
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.selectedBackgroundView = UIView(backgroundColor: .clear)
        self.contentView.addSubview(self.rootView)
        self.rootView.addSubview(self.iconView)
        self.rootView.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.rootView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Theme.current.mainPaddings),
            self.rootView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.rootView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.rootView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            self.titleLabel.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 20),
            self.titleLabel.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 10),
            self.titleLabel.rightAnchor.constraint(equalTo: self.iconView.leftAnchor, constant: -20),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -10),
            self.iconView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 10),
            self.iconView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -20),
            self.iconView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -10),
            self.iconView.widthAnchor.constraint(equalTo: self.iconView.heightAnchor, multiplier: 1),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.rootView.backgroundColor = Theme.current.plainTableCellColor
        self.rootView.layer.borderColor = Theme.current.secondTintColor.withAlphaComponent(0.3).cgColor
        self.iconView.startColor = Theme.current.mainGradientStartColor
        self.iconView.endColor = Theme.current.mainGradientEndColor
        self.titleLabel.textColor = Theme.current.primaryTextColor
    }
}
