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
        view.layer.borderColor = Theme.current.whiteColor.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    let searchView: CustomSearchBar = {
        let view = CustomSearchBar(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
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
            self.avatarView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Theme.current.mainPaddings),
            self.avatarView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            self.avatarView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            self.avatarView.widthAnchor.constraint(equalTo: self.avatarView.heightAnchor, multiplier: 1),
            self.searchView.leftAnchor.constraint(equalTo: self.avatarView.rightAnchor, constant: 8),
            self.searchView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            self.searchView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            self.searchView.rightAnchor.constraint(equalTo: self.notifyView.leftAnchor, constant: -8),
            self.notifyView.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            self.notifyView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6),
            self.notifyView.widthAnchor.constraint(equalTo: self.notifyView.heightAnchor, multiplier: 1),
            self.menuView.leftAnchor.constraint(equalTo: self.notifyView.rightAnchor, constant: 8),
            self.menuView.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            self.menuView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Theme.current.mainPaddings),
            self.menuView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6),
            self.menuView.widthAnchor.constraint(equalTo: self.menuView.heightAnchor, multiplier: 1),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func themeChanged(newTheme: Theme) {
        self.avatarView.layer.borderColor = Theme.current.whiteColor.cgColor
        self.avatarView.backgroundColor = Theme.current.secondTintColor
        self.menuView.imageView?.tintColor = Theme.current.whiteColor
        self.notifyView.imageView?.tintColor = Theme.current.whiteColor
        self.searchView.layer.borderColor = Theme.current.whiteColor.cgColor
        self.searchView.leftIcon.tintColor = Theme.current.whiteColor
        self.searchView.searchField.textColor = Theme.current.whiteColor
    }
}


class CustomSearchBar: UIView {
    
    let leftIcon: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(name: .search)
        view.tintColor = Theme.current.whiteColor
        return view
    }()
    let searchField: UITextField = {
        let view = UITextField(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.borderStyle = .none
        view.textColor = Theme.current.whiteColor
        view.backgroundColor = .clear
        view.leftViewMode = .always
        view.attributedPlaceholder = NSAttributedString(string: "SEARCH".localized, attributes: [.foregroundColor: UIColor.white])
        view.isEnabled = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderColor = Theme.current.whiteColor.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 18
        self.clipsToBounds = true
        self.addSubview(self.leftIcon)
        self.addSubview(self.searchField)
        NSLayoutConstraint.activate([
            self.leftIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            self.leftIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.leftIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            self.leftIcon.widthAnchor.constraint(equalTo: self.leftIcon.heightAnchor, multiplier: 1),
            self.searchField.leftAnchor.constraint(equalTo: self.leftIcon.rightAnchor, constant: 10),
            self.searchField.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.searchField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.searchField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
