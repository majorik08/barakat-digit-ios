//
//  SettingsSwitchCell.swift
//  BarakatWallet
//
//  Created by km1tj on 31/10/23.
//

import Foundation
import UIKit

class SettingsSwitchCell: UITableViewCell {
    
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
    let switchView: UISwitch = {
        let view = UISwitch(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .lightGray
        view.onTintColor = Theme.current.tintColor
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .horizontal)
        return view
    }()
    let titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 17)
        view.textColor = Theme.current.primaryTextColor
        view.text = "Title"
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.5
        return view
    }()
    var switchDelegate: ((_ state: Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .none
        self.separatorInset = .zero
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.selectedBackgroundView = UIView(backgroundColor: .clear)
        self.selectionStyle = .none
        self.contentView.addSubview(self.rootView)
        self.rootView.addSubview(self.switchView)
        self.rootView.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.rootView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Theme.current.mainPaddings),
            self.rootView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.rootView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.rootView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            self.titleLabel.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 20),
            self.titleLabel.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 10),
            self.titleLabel.rightAnchor.constraint(equalTo: self.switchView.leftAnchor, constant: -20),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -10),
            self.switchView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -20),
            self.switchView.centerYAnchor.constraint(equalTo: self.rootView.centerYAnchor),
        ])
        self.switchView.addTarget(self, action: #selector(self.changed), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func changed() {
        self.switchDelegate?(self.switchView.isOn)
    }
}
