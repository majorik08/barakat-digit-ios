//
//  PaymentServiceCell.swift
//  BarakatWallet
//
//  Created by km1tj on 08/11/23.
//

import Foundation
import UIKit

class PaymentServiceCell: UITableViewCell {
    
    let rootView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.current.plainTableBackColor
        return view
    }()
    let iconView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(name: .profile_add)
        view.contentMode = .scaleAspectFit
        return view
    }()
    let titleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 17)
        view.textColor = Theme.current.primaryTextColor
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.8
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
        NSLayoutConstraint.activate([
            self.rootView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            self.rootView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            self.rootView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20),
            self.rootView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            self.iconView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
            self.iconView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 0),
            self.iconView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0),
            self.iconView.widthAnchor.constraint(equalTo: self.iconView.heightAnchor, multiplier: 1),
            self.titleView.leftAnchor.constraint(equalTo: self.iconView.rightAnchor, constant: 10),
            self.titleView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 0),
            self.titleView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
            self.titleView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0),
            self.titleView.centerYAnchor.constraint(equalTo: self.rootView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(service: AppStructs.PaymentGroup.ServiceItem) {
        self.rootView.backgroundColor = Theme.current.plainTableBackColor
        self.titleView.textColor = Theme.current.primaryTextColor
        
        self.titleView.text = service.name
    }
}
