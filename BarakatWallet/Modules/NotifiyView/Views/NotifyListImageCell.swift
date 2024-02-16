//
//  NotifyListImageCell.swift
//  BarakatWallet
//
//  Created by km1tj on 28/11/23.
//

import Foundation
import UIKit

class NotifyListImageCell: UITableViewCell {
    
    let rootView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.current.plainTableCellColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 14
        return view
    }()
    let iconView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        return view
    }()
    let arrowView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.tintColor = Theme.current.tintColor
        return view
    }()
    let titleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.medium(size: 16)
        view.numberOfLines = 0
        return view
    }()
    let subTitleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.regular(size: 14)
        view.numberOfLines = 0
        return view
    }()
    let dateView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.secondaryTextColor
        view.font = UIFont.regular(size: 14)
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
        self.rootView.addSubview(self.arrowView)
        self.rootView.addSubview(self.subTitleView)
        self.rootView.addSubview(self.dateView)
        NSLayoutConstraint.activate([
            self.rootView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Theme.current.mainPaddings),
            self.rootView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.rootView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.rootView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            self.iconView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
            self.iconView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 0),
            self.iconView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
            self.iconView.heightAnchor.constraint(equalTo: self.iconView.widthAnchor, multiplier: 0.6),
            self.titleView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 16),
            self.titleView.topAnchor.constraint(equalTo: self.iconView.bottomAnchor, constant: 10),
            self.arrowView.leftAnchor.constraint(equalTo: self.titleView.rightAnchor, constant: 16),
            self.arrowView.topAnchor.constraint(equalTo: self.iconView.bottomAnchor, constant: 10),
            self.arrowView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -16),
            self.arrowView.heightAnchor.constraint(equalToConstant: 16),
            self.arrowView.widthAnchor.constraint(equalToConstant: 16),
            self.subTitleView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 16),
            self.subTitleView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 10),
            self.subTitleView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -16),
            self.dateView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 16),
            self.dateView.topAnchor.constraint(equalTo: self.subTitleView.bottomAnchor, constant: 10),
            self.dateView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -16),
            self.dateView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFullText(item: AppStructs.NotificationNews, showText: Bool = false) {
        self.subTitleView.text = showText ? item.text : nil
    }
    
    func configure(item: AppStructs.NotificationNews, showText: Bool = false) {
        self.rootView.backgroundColor = Theme.current.plainTableCellColor
        self.iconView.backgroundColor = Theme.current.grayColor
        self.arrowView.tintColor = Theme.current.primaryTextColor
        self.titleView.textColor = Theme.current.primaryTextColor
        self.subTitleView.textColor = Theme.current.primaryTextColor
        self.dateView.textColor = Theme.current.secondaryTextColor
        
        self.titleView.text = item.title
        self.subTitleView.text = showText ? item.text : nil
        self.arrowView.image = showText ? UIImage(name: .arrow_up) : UIImage(name: .down_arrow)
        self.dateView.text = item.dateTime
        if !item.image.isEmpty {
            self.iconView.loadImage(filePath: item.image)
        }
    }
}
