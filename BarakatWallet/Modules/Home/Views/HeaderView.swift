//
//  HeaderView.swift
//  BarakatWallet
//
//  Created by km1tj on 21/10/23.
//

import Foundation
import UIKit

class HeaderView: UIView {
    
    let avatarView: AvatarImageView = {
        let view = AvatarImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.layer.borderColor = Theme.current.borderColor.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    let searchView: LeftViewTextField = {
        let view = LeftViewTextField(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "SEARCH".localized
        view.borderStyle = .none
        view.layer.borderColor = Theme.current.borderColor.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 18
        view.textColor = Theme.current.whiteColor
        view.backgroundColor = .clear
        view.leftViewMode = .always
        view.leftImage = UIImage(name: .search)
        view.color = Theme.current.borderColor
        //view.attributedPlaceholder = NSAttributedString(string: "SEARCH".localized, attributes: [.foregroundColor: UIColor.white])
        //view.textContainerInset = .init(top: 0, left: 10, bottom: 0, right: 0)
        return view
    }()
    let notifyView: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(name: .notify), for: .normal)
        view.imageView?.tintColor = Theme.current.whiteColor
        return view
    }()
    let menuView: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(name: .menu_icon), for: .normal)
        view.imageView?.tintColor = Theme.current.whiteColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.addSubview(self.avatarView)
        self.addSubview(self.searchView)
        self.addSubview(self.notifyView)
        self.addSubview(self.menuView)
        NSLayoutConstraint.activate([
            self.avatarView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.avatarView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            self.avatarView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            self.avatarView.widthAnchor.constraint(equalTo: self.avatarView.heightAnchor, multiplier: 1),
            self.searchView.leftAnchor.constraint(equalTo: self.avatarView.rightAnchor, constant: 10),
            self.searchView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            self.searchView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            self.searchView.rightAnchor.constraint(equalTo: self.notifyView.leftAnchor, constant: -10),
            self.notifyView.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            self.notifyView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6),
            self.notifyView.widthAnchor.constraint(equalTo: self.notifyView.heightAnchor, multiplier: 1),
            self.menuView.leftAnchor.constraint(equalTo: self.notifyView.rightAnchor, constant: 10),
            self.menuView.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            self.menuView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.menuView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6),
            self.menuView.widthAnchor.constraint(equalTo: self.menuView.heightAnchor, multiplier: 1),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func themeChanged(newTheme: Theme) {
        self.avatarView.layer.borderColor = Theme.current.borderColor.cgColor
        self.avatarView.backgroundColor = Theme.current.secondTintColor
        self.menuView.imageView?.tintColor = Theme.current.whiteColor
        self.notifyView.imageView?.tintColor = Theme.current.whiteColor
        self.searchView.color = Theme.current.borderColor
        self.searchView.textColor = Theme.current.whiteColor
        self.searchView.layer.borderColor = Theme.current.borderColor.cgColor
    }
}
