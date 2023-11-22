//
//  AccountInfoView-.swift
//  BarakatWallet
//
//  Created by km1tj on 21/10/23.
//

import Foundation
import UIKit

class AccountInfoView: UIView {
   
    private let balanceHintLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 20)
        view.textColor = Theme.current.whiteColor
        view.text = "WALLET_BALANCE_HINT".localized
        return view
    }()
    private let balanceLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 25)
        view.textColor = Theme.current.whiteColor
        view.text = "00.00 s."
        return view
    }()
    private let bonusLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 16)
        view.textColor = Theme.current.whiteColor
        view.text = "00.00 som. bonus"
        return view
    }()
    private let plusButton: CircleButtonView = {
        let view = CircleButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = Theme.current.whiteColor
        view.setImage(UIImage(name: .plus_icon), for: .normal)
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.19)
        view.imageView?.contentMode = .scaleAspectFit
        view.imageEdgeInsets = .init(top: 4, left: 4, bottom: 4, right: 4)
        return view
    }()
    private let hideButton: UIButton = {
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
        self.addSubview(self.balanceHintLabel)
        self.addSubview(self.balanceLabel)
        self.addSubview(self.bonusLabel)
        self.addSubview(self.plusButton)
        self.addSubview(self.hideButton)
        NSLayoutConstraint.activate([
            self.balanceHintLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.balanceHintLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.balanceHintLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            self.balanceHintLabel.heightAnchor.constraint(equalToConstant: 20),
            self.balanceLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.balanceLabel.topAnchor.constraint(equalTo: self.balanceHintLabel.bottomAnchor, constant: 6),
            self.balanceLabel.heightAnchor.constraint(equalToConstant: 24),
            self.plusButton.leftAnchor.constraint(equalTo: self.balanceLabel.rightAnchor, constant: 10),
            self.plusButton.topAnchor.constraint(equalTo: self.balanceHintLabel.bottomAnchor, constant: 4),
            self.plusButton.heightAnchor.constraint(equalToConstant: 26),
            self.plusButton.widthAnchor.constraint(equalToConstant: 26),
            self.hideButton.leftAnchor.constraint(equalTo: self.plusButton.rightAnchor, constant: 10),
            self.hideButton.topAnchor.constraint(equalTo: self.balanceHintLabel.bottomAnchor, constant: 4),
            self.hideButton.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -10),
            self.hideButton.heightAnchor.constraint(equalToConstant: 26),
            self.hideButton.widthAnchor.constraint(equalToConstant: 26),
            self.bonusLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.bonusLabel.topAnchor.constraint(equalTo: self.balanceLabel.bottomAnchor, constant: 6),
            self.bonusLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            self.bonusLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            self.bonusLabel.heightAnchor.constraint(equalToConstant: 16),
        ])
    }
    
    func themeChanged(newTheme: Theme) {
        self.balanceHintLabel.textColor = newTheme.whiteColor
        self.balanceLabel.textColor = newTheme.whiteColor
        self.bonusLabel.textColor = newTheme.whiteColor
        self.hideButton.tintColor = newTheme.whiteColor
        self.plusButton.tintColor = newTheme.whiteColor
    }
}
