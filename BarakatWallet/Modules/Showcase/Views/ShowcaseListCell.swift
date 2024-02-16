//
//  ShowcaseListCell.swift
//  BarakatWallet
//
//  Created by km1tj on 28/11/23.
//

import Foundation
import UIKit

class ShowcaseListCell: UITableViewCell {
    
    let rootView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    let iconView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.backgroundColor = .lightGray
        return view
    }()
    let titleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.medium(size: 14)
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
    let cashbackLabel: CircleLabel = {
        let view = CircleLabel()
        view.topInset = 4
        view.bottomInset = 4
        view.leftInset = 6
        view.rightInset = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.current.tintColor
        view.textColor = Theme.current.whiteColor
        view.font = UIFont.medium(size: 14)
        view.clipsToBounds = true
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
        self.separatorInset = .init(top: 0, left: Theme.current.mainPaddings, bottom: 0, right: Theme.current.mainPaddings)
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.selectedBackgroundView = UIView(backgroundColor: .clear)
        self.contentView.addSubview(self.rootView)
        self.rootView.addSubview(self.iconView)
        self.rootView.addSubview(self.titleView)
        self.rootView.addSubview(self.subTitleView)
        self.rootView.addSubview(self.cashbackLabel)
        NSLayoutConstraint.activate([
            self.rootView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0),
            self.rootView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            self.rootView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0),
            self.rootView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            self.iconView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.iconView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 6),
            self.iconView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -6),
            self.iconView.widthAnchor.constraint(equalTo: self.iconView.heightAnchor, multiplier: 1.6),
            self.titleView.leftAnchor.constraint(equalTo: self.iconView.rightAnchor, constant: 16),
            self.titleView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 6),
            self.cashbackLabel.leftAnchor.constraint(equalTo: self.titleView.rightAnchor, constant: 16),
            self.cashbackLabel.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 6),
            self.cashbackLabel.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.cashbackLabel.heightAnchor.constraint(equalToConstant: 16),
            self.subTitleView.leftAnchor.constraint(equalTo: self.iconView.rightAnchor, constant: 16),
            self.subTitleView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 0),
            self.subTitleView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.subTitleView.bottomAnchor.constraint(lessThanOrEqualTo: self.rootView.bottomAnchor, constant: -6),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(showcase: AppStructs.Showcase) {
        self.cashbackLabel.backgroundColor = Theme.current.tintColor
        self.cashbackLabel.textColor = Theme.current.whiteColor
        self.titleView.textColor = Theme.current.primaryTextColor
        self.subTitleView.textColor = Theme.current.secondaryTextColor
        
        self.titleView.text = "\("Name")\nДействует 3 года"
        self.subTitleView.text = "Стоимость: 10 сомони\nСтраховой депозит 00.00 сомони"
        self.cashbackLabel.text = "10%"
        
        self.iconView.setImage(url: "https://picsum.photos/300/300")
    }
}

