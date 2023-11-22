//
//  CardView.swift
//  BarakatWallet
//
//  Created by km1tj on 17/11/23.
//

import Foundation
import UIKit

class CardView: UIView {
    
    let rootView: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.layer.borderColor = Theme.current.secondTintColor.withAlphaComponent(0.3).cgColor
        view.layer.borderWidth = 0.5
        view.startColor = Theme.current.mainGradientStartColor
        view.endColor = Theme.current.mainGradientStartColor
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
    let cardNumberView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.semibold(size: 24)
        view.textColor = Theme.current.whiteColor
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.8
        return view
    }()
    let cardExpireView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 14)
        view.textColor = Theme.current.whiteColor
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.8
        return view
    }()
    let cardCvvView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 14)
        view.textColor = Theme.current.whiteColor
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.8
        return view
    }()
    let cardHolderView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 14)
        view.textColor = Theme.current.whiteColor
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.8
        return view
    }()
    let cardBalanceView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 14)
        view.textColor = Theme.current.whiteColor
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.8
        return view
    }()
    let cardBankView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 14)
        view.textColor = Theme.current.whiteColor
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.8
        return view
    }()
    let cardTypeIconView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(self.rootView)
        self.rootView.addSubview(self.mainImage)
        self.rootView.addSubview(self.cardNumberView)
        self.rootView.addSubview(self.cardExpireView)
        self.rootView.addSubview(self.cardCvvView)
        self.rootView.addSubview(self.cardHolderView)
        self.rootView.addSubview(self.cardBalanceView)
        self.rootView.addSubview(self.cardBankView)
        self.rootView.addSubview(self.cardTypeIconView)
        NSLayoutConstraint.activate([
            self.rootView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Theme.current.mainPaddings),
            self.rootView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.rootView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Theme.current.mainPaddings),
            self.rootView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            self.mainImage.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
            self.mainImage.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 0),
            self.mainImage.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
            self.mainImage.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0),
            self.cardNumberView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 30),
            self.cardNumberView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 20),
            self.cardNumberView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -20),
            self.cardExpireView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 30),
            self.cardExpireView.topAnchor.constraint(equalTo: self.cardNumberView.bottomAnchor, constant: 20),
            self.cardCvvView.leftAnchor.constraint(equalTo: self.cardExpireView.rightAnchor, constant: 40),
            self.cardCvvView.topAnchor.constraint(equalTo: self.cardNumberView.bottomAnchor, constant: 20),
            self.cardCvvView.rightAnchor.constraint(lessThanOrEqualTo: self.rootView.rightAnchor, constant: -20),
            self.cardHolderView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 30),
            self.cardHolderView.topAnchor.constraint(equalTo: self.cardExpireView.bottomAnchor, constant: 20),
            self.cardHolderView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -20),
            self.cardBalanceView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 30),
            self.cardBalanceView.topAnchor.constraint(greaterThanOrEqualTo: self.cardHolderView.bottomAnchor, constant: 20),
            self.cardBalanceView.rightAnchor.constraint(equalTo: self.cardTypeIconView.leftAnchor, constant: -20),
            self.cardBankView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 30),
            self.cardBankView.topAnchor.constraint(equalTo: self.cardBalanceView.bottomAnchor, constant: 20),
            self.cardBankView.rightAnchor.constraint(equalTo: self.cardTypeIconView.leftAnchor, constant: -20),
            self.cardBankView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -20),
            self.cardTypeIconView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -30),
            self.cardTypeIconView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -20),
            self.cardTypeIconView.heightAnchor.constraint(equalTo: self.rootView.heightAnchor, multiplier: 0.2),
            self.cardTypeIconView.widthAnchor.constraint(equalTo: self.cardTypeIconView.heightAnchor, multiplier: 1.4),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColors(selectedColor: (start: UIColor, end: UIColor)? = nil) {
        if let selectedColor {
            self.rootView.startColor = selectedColor.start
            self.rootView.endColor = selectedColor.end
        } else {
            self.rootView.startColor = Theme.current.mainGradientStartColor
            self.rootView.endColor = Theme.current.mainGradientEndColor
        }
    }
    
    func configure(card: AppStructs.CreditDebitCard, show: Bool, selectedColor: (start: UIColor, end: UIColor)? = nil) {
        self.rootView.layer.borderColor = Theme.current.borderColor.withAlphaComponent(0.3).cgColor
        if let selectedColor {
            self.rootView.startColor = selectedColor.start
            self.rootView.endColor = selectedColor.end
        } else {
            self.rootView.startColor = Theme.current.mainGradientStartColor
            self.rootView.endColor = Theme.current.mainGradientEndColor
        }
        self.cardNumberView.textColor = Theme.current.whiteColor
        self.cardExpireView.textColor = Theme.current.whiteColor
        self.cardCvvView.textColor = Theme.current.whiteColor
        self.cardHolderView.textColor = Theme.current.whiteColor
        self.cardBalanceView.textColor = Theme.current.whiteColor
        self.cardBankView.textColor = Theme.current.whiteColor
       
        if show {
            self.cardNumberView.text = card.number
            self.cardExpireView.text = "24/12"
            self.cardCvvView.text = "CVV 123"
            self.cardHolderView.text = "Mr. Musk"
            self.cardBalanceView.text = "1 000 som."
            self.cardBankView.text = "Bank X"
            self.cardTypeIconView.image = UIImage(name: .card_visa)
        } else {
            let last4 = String(card.number.suffix(4))
            self.cardNumberView.text = "**** **** **** \(last4)"
            self.cardExpireView.text = "**/**"
            self.cardCvvView.text = "CVV ***"
            self.cardHolderView.text = "Mr. Musk"
            self.cardBalanceView.text = "1 000 som."
            self.cardBankView.text = "Bank X"
            self.cardTypeIconView.image = UIImage(name: .card_visa)
        }
    }
}
