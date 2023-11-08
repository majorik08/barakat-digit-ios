//
//  EditTopBar.swift
//  BarakatWallet
//
//  Created by km1tj on 30/10/23.
//

import Foundation
import UIKit

class EditTopBar: UIView {
    
    let avatarView: AvatarImageView = {
        let view = AvatarImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let buttonView: HighlightedButton = {
        let view = HighlightedButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.current.plainTableCellColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 6
        view.setImage(UIImage(name: .camera_pick), for: .normal)
        view.setTitle("PICK_PHOTO".localized, for: .normal)
        view.imageView?.contentMode = .scaleAspectFit
        view.imageView?.tintColor = Theme.current.primaryTextColor
        view.setTitleColor(Theme.current.primaryTextColor, for: .normal)
        view.titleLabel?.font = UIFont.bold(size: 16)
        view.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        return view
    }()
    let statusView: StatusView = {
        let view = StatusView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.current.dark ? .black : .white
        
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(self.avatarView)
        self.addSubview(self.buttonView)
        self.addSubview(self.statusView)
        NSLayoutConstraint.activate([
            self.avatarView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30),
            self.avatarView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.avatarView.heightAnchor.constraint(equalToConstant: 74),
            self.avatarView.widthAnchor.constraint(equalToConstant: 74),
            self.buttonView.leftAnchor.constraint(equalTo: self.avatarView.rightAnchor, constant: 30),
            self.buttonView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30),
            self.buttonView.heightAnchor.constraint(equalToConstant: 40),
            self.buttonView.centerYAnchor.constraint(equalTo: self.avatarView.centerYAnchor),
            self.statusView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            self.statusView.topAnchor.constraint(equalTo: self.avatarView.bottomAnchor, constant: 20),
            self.statusView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            self.statusView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            self.statusView.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
}
