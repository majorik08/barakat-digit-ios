//
//  HistoryItemCell.swift
//  BarakatWallet
//
//  Created by km1tj on 02/11/23.
//

import Foundation
import UIKit

class HistoryItemCell: UITableViewCell {
    
    let rootView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    let iconView: GradientImageView = {
        let view = GradientImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageView.image = UIImage(name: .wallet_inset)
        view.imageView.contentMode = .scaleAspectFit
        view.tintColor = .white
        return view
    }()
    let titleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 16)
        view.textColor = Theme.current.primaryTextColor
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.8
        return view
    }()
    let detailView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 16)
        view.textColor = Theme.current.primaryTextColor
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.8
        view.textAlignment = .right
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
        self.rootView.addSubview(self.titleView)
        self.rootView.addSubview(self.detailView)
        NSLayoutConstraint.activate([
            self.rootView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.rootView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 6),
            self.rootView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            self.rootView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -6),
            self.iconView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 10),
            self.iconView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 0),
            self.iconView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0),
            self.iconView.widthAnchor.constraint(equalTo: self.iconView.heightAnchor, multiplier: 1),
            self.titleView.leftAnchor.constraint(equalTo: self.iconView.rightAnchor, constant: 10),
            self.titleView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 0),
            self.titleView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0),
            self.titleView.centerYAnchor.constraint(equalTo: self.rootView.centerYAnchor),
            self.detailView.leftAnchor.constraint(equalTo: self.titleView.rightAnchor, constant: 10),
            self.detailView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 0),
            self.detailView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -10),
            self.detailView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0),
            self.detailView.centerYAnchor.constraint(equalTo: self.rootView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(history: AppStructs.HistoryItem) {
        self.titleView.text = "Group name"
        self.detailView.text = "-13s"
    }
}
