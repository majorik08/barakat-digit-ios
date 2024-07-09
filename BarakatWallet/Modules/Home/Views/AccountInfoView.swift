//
//  AccountInfoView-.swift
//  BarakatWallet
//
//  Created by km1tj on 21/10/23.
//

import Foundation
import UIKit

class AccountInfoView: UIView {
   
    let balanceLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 25)
        view.textColor = .black
        view.text = "00.0 с."
        return view
    }()
    let bonusLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 16)
        view.textColor = .black
        view.text = "00.0 с. bonus"
        return view
    }()
    let plusButton: CircleButtonView = {
        let view = CircleButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = Theme.current.whiteColor
        view.setImage(UIImage(name: .plus_icon), for: .normal)
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.19)
        view.imageView?.contentMode = .scaleAspectFit
        view.imageEdgeInsets = .init(top: 4, left: 4, bottom: 4, right: 4)
        return view
    }()
    let hideButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = Theme.current.whiteColor
        view.setImage(UIImage(name: .hide_eyes), for: .normal)
        view.imageView?.contentMode = .scaleAspectFit
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        self.backgroundColor = .clear
        self.addSubview(self.balanceLabel)
        self.addSubview(self.bonusLabel)
        self.addSubview(self.plusButton)
        self.addSubview(self.hideButton)
        NSLayoutConstraint.activate([
            self.balanceLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Theme.current.mainPaddings),
            self.balanceLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.balanceLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Theme.current.mainPaddings),
            self.balanceLabel.heightAnchor.constraint(equalToConstant: 24),
            self.bonusLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Theme.current.mainPaddings + 1.5),
            self.bonusLabel.topAnchor.constraint(equalTo: self.balanceLabel.bottomAnchor, constant: 6),
            self.bonusLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            self.bonusLabel.heightAnchor.constraint(equalToConstant: 16),
            self.plusButton.leftAnchor.constraint(equalTo: self.bonusLabel.rightAnchor, constant: 10),
            self.plusButton.bottomAnchor.constraint(equalTo: self.bonusLabel.bottomAnchor, constant: 0),
            self.plusButton.heightAnchor.constraint(equalToConstant: 26),
            self.plusButton.widthAnchor.constraint(equalToConstant: 26),
            self.hideButton.leftAnchor.constraint(equalTo: self.plusButton.rightAnchor, constant: 10),
            self.hideButton.bottomAnchor.constraint(equalTo: self.bonusLabel.bottomAnchor, constant: 0),
            self.hideButton.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -Theme.current.mainPaddings),
            self.hideButton.heightAnchor.constraint(equalToConstant: 26),
            self.hideButton.widthAnchor.constraint(equalToConstant: 26),
        ])
    }
    
    func themeChanged(newTheme: Theme) {
        //self.balanceLabel.textColor = newTheme.whiteColor
        //self.bonusLabel.textColor = newTheme.whiteColor
        self.hideButton.tintColor = newTheme.whiteColor
        self.plusButton.tintColor = newTheme.whiteColor
    }
}
