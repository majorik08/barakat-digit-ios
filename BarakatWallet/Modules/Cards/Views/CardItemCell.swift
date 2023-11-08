//
//  CardItemCell.swift
//  BarakatWallet
//
//  Created by km1tj on 06/11/23.
//

import Foundation
import UIKit

class CardItemCell: UICollectionViewCell {
    
    let rootView: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.layer.borderColor = Theme.current.secondTintColor.withAlphaComponent(0.3).cgColor
        view.layer.borderWidth = 0.5
        view.startColor = Theme.current.cardGradientStartColor
        view.endColor = Theme.current.cardGradientEndColor
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
        view.textColor = .white
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.8
        return view
    }()
    let cardExpireView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 14)
        view.textColor = .white
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.8
        return view
    }()
    let cardCvvView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 14)
        view.textColor = .white
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.8
        return view
    }()
    let cardHolderView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 14)
        view.textColor = .white
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.8
        return view
    }()
    let cardBalanceView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 14)
        view.textColor = .white
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.8
        return view
    }()
    let cardBankView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 14)
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
        return view
    }()
    
    override var isHighlighted: Bool {
        didSet {
            self.rootView.alpha = self.isHighlighted ? 0.5 : 1
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.addSubview(self.rootView)
        self.rootView.addSubview(self.mainImage)
        self.rootView.addSubview(self.cardNumberView)
        self.rootView.addSubview(self.cardExpireView)
        self.rootView.addSubview(self.cardCvvView)
        self.rootView.addSubview(self.cardHolderView)
        self.rootView.addSubview(self.cardBalanceView)
        self.rootView.addSubview(self.cardBankView)
        self.rootView.addSubview(self.cardTypeIconView)
        NSLayoutConstraint.activate([
            self.rootView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.rootView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.rootView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            self.rootView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
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
    
    
    func configure(card: String) {
        self.cardNumberView.text = card
        self.cardExpireView.text = "24/12"
        self.cardCvvView.text = "CVV 123"
        self.cardHolderView.text = "Mr. Musk"
        self.cardBalanceView.text = "1 000 000 000 som."
        self.cardBankView.text = "Bank X"
        self.cardTypeIconView.image = UIImage(name: .card_visa)
    }
}
