//
//  BalanceView.swift
//  BarakatWallet
//
//  Created by km1tj on 10/11/23.
//

import Foundation
import UIKit

class BalanceView: UIView {
    
    let rootView: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.layer.borderColor = Theme.current.secondTintColor.withAlphaComponent(0.3).cgColor
        view.layer.borderWidth = 0.5
        view.startColor = Theme.current.mainGradientStartColor
        view.endColor = Theme.current.mainGradientEndColor
        return view
    }()
    let mainImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = .clear
        return view
    }()
    let accountNameView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 16)
        view.textColor = .white
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.8
        return view
    }()
    let cardBalanceView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 16)
        view.textColor = .white
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.8
        return view
    }()
    let cardNumberView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 14)
        view.textColor = .white
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.8
        return view
    }()
    let cardAuthorView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 14)
        view.textColor = .white
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.8
        return view
    }()
    let cardTypeIconView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(name: .wallet_icon)
        view.tintColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(self.rootView)
        self.rootView.addSubview(self.mainImage)
        self.rootView.addSubview(self.accountNameView)
        self.rootView.addSubview(self.cardBalanceView)
        self.rootView.addSubview(self.cardNumberView)
        self.rootView.addSubview(self.cardAuthorView)
        self.rootView.addSubview(self.cardTypeIconView)
        NSLayoutConstraint.activate([
            self.rootView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.rootView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.rootView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.rootView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            self.mainImage.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
            self.mainImage.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 0),
            self.mainImage.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
            self.mainImage.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0),
            self.accountNameView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 16),
            self.accountNameView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 16),
            self.accountNameView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -16),
            self.cardBalanceView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 16),
            self.cardBalanceView.topAnchor.constraint(equalTo: self.accountNameView.bottomAnchor, constant: 10),
            self.cardBalanceView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -16),
            self.cardNumberView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 16),
            self.cardNumberView.topAnchor.constraint(greaterThanOrEqualTo: self.cardBalanceView.bottomAnchor, constant: 10),
            self.cardNumberView.rightAnchor.constraint(equalTo: self.cardTypeIconView.leftAnchor, constant: -16),
            self.cardAuthorView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 16),
            self.cardAuthorView.topAnchor.constraint(equalTo: self.cardNumberView.bottomAnchor, constant: 10),
            self.cardAuthorView.rightAnchor.constraint(equalTo: self.cardTypeIconView.leftAnchor, constant: -16),
            self.cardAuthorView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -16),
            self.cardTypeIconView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -16),
            self.cardTypeIconView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -16),
            self.cardTypeIconView.heightAnchor.constraint(equalTo: self.rootView.heightAnchor, multiplier: 0.25),
            self.cardTypeIconView.widthAnchor.constraint(equalTo: self.cardTypeIconView.heightAnchor, multiplier: 1.4),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareForReuse() {
        self.cardTypeIconView.image = nil
        self.accountNameView.text = nil
        self.cardBalanceView.text = nil
        self.cardAuthorView.text = nil
        self.cardNumberView.text = nil
        
    }
    
    func configure(account: AppStructs.AccountInfo.BalanceType) {
        switch account {
        case .wallet(let account):
            if account.isBonus {
                self.accountNameView.text = "BONUS_ACCOUNT".localized
            } else {
                self.accountNameView.text = "WALLET_BALANCE_HINT".localized
            }
            self.cardBalanceView.text = account.balance.balanceText
            self.cardAuthorView.text = ""
            self.cardTypeIconView.image = UIImage(name: .wallet_icon)
        case .card(let card):
            let last4 = String(card.pan.suffix(4))
            self.accountNameView.text = "•• \(last4)"
            if card.showBalance {
                self.cardBalanceView.text = card.balance.balanceText
            } else {
                self.cardBalanceView.text = ""
            }
            self.cardAuthorView.text = card.cardHolder
            self.cardTypeIconView.loadImage(filePath: card.logo)
        }
    }
}
