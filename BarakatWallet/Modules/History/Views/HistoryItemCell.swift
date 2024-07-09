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
    let iconView: CircleImageView = {
        let view = CircleImageView(frame: .zero)
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
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
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
    }()
    let infoView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 15)
        view.textColor = Theme.current.secondaryTextColor
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.8
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
    }()
    let detailView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 16)
        view.textColor = Theme.current.primaryTextColor
        view.numberOfLines = 1
        view.textAlignment = .right
        view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
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
        self.rootView.addSubview(self.infoView)
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
            self.infoView.leftAnchor.constraint(equalTo: self.titleView.leftAnchor),
            self.infoView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 0),
            self.infoView.rightAnchor.constraint(equalTo: self.titleView.rightAnchor),
            self.infoView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0),
            
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleView.text = nil
        self.detailView.text = nil
        self.iconView.image = nil
    }
    
    func configure(history: AppStructs.HistoryItem, service: AppStructs.PaymentGroup.ServiceItem?, fromMe: Bool) {
        self.titleView.textColor = Theme.current.primaryTextColor
        if history.amount < 0 {
            self.detailView.textColor = Theme.current.primaryTextColor
        } else {
            self.detailView.textColor = Theme.current.tintColor
        }
        if let service = service {
            self.titleView.text = service.name
            self.iconView.loadImage(filePath: Theme.current.dark ? service.darkListImage : service.listImage)
        } else {
            self.titleView.text = "UNKNOWN".localized
            self.iconView.image = UIImage(name: .wallet_icon)
        }
        self.detailView.text = "\(history.amount.balanceText)"
        if fromMe {
            self.infoView.text = history.accountTo
        } else {
            self.infoView.text = history.accountFrom
        }
    }
}
