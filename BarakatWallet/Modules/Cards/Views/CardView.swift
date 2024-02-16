//
//  CardView.swift
//  BarakatWallet
//
//  Created by km1tj on 17/11/23.
//

import Foundation
import UIKit

protocol CardViewDelegate: AnyObject {
    func copyInfo(cardView: CardView, number: Bool, date: Bool, cvv: Bool)
}

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
        view.minimumScaleFactor = 0.9
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return view
    }()
    let numberButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints  = false
        view.setImage(UIImage(name: .copy_value), for: .normal)
        view.tintColor = Theme.current.whiteColor
        view.imageView?.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()
    let cardExpireView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 17)
        view.textColor = Theme.current.whiteColor
        view.numberOfLines = 1
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        return view
    }()
    let expireButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints  = false
        view.setImage(UIImage(name: .copy_value), for: .normal)
        view.tintColor = Theme.current.whiteColor
        view.isHidden = true
        return view
    }()
    let cardCvvView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 17)
        view.textColor = Theme.current.whiteColor
        view.numberOfLines = 1
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        return view
    }()
    let cvvButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints  = false
        view.setImage(UIImage(name: .copy_value), for: .normal)
        view.tintColor = Theme.current.whiteColor
        view.imageView?.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()
    let cardHolderView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 17)
        view.textColor = Theme.current.whiteColor
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        return view
    }()
    let cardBalanceView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 17)
        view.textColor = Theme.current.whiteColor
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        return view
    }()
    let cardBankView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 17)
        view.textColor = Theme.current.whiteColor
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        return view
    }()
    let cardTypeIconView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    weak var delegate: CardViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(self.rootView)
        self.rootView.addSubview(self.mainImage)
        self.rootView.addSubview(self.cardNumberView)
        self.rootView.addSubview(self.numberButton)
        self.rootView.addSubview(self.cardExpireView)
        self.rootView.addSubview(self.expireButton)
        self.rootView.addSubview(self.cardCvvView)
        self.rootView.addSubview(self.cvvButton)
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
            self.numberButton.leftAnchor.constraint(equalTo: self.cardNumberView.rightAnchor, constant: 10),
            self.numberButton.rightAnchor.constraint(lessThanOrEqualTo: self.rootView.rightAnchor, constant: -20),
            self.numberButton.heightAnchor.constraint(equalToConstant: 16),
            self.numberButton.widthAnchor.constraint(equalToConstant: 16),
            self.numberButton.centerYAnchor.constraint(equalTo: self.cardNumberView.centerYAnchor),
           
            self.cardExpireView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 30),
            self.cardExpireView.topAnchor.constraint(equalTo: self.cardNumberView.bottomAnchor, constant: 20),
            self.cardExpireView.bottomAnchor.constraint(lessThanOrEqualTo: self.cardHolderView.topAnchor, constant: -10),
            self.expireButton.leftAnchor.constraint(equalTo: self.cardExpireView.rightAnchor, constant: 10),
            self.expireButton.heightAnchor.constraint(equalToConstant: 16),
            self.expireButton.widthAnchor.constraint(equalToConstant: 16),
            self.expireButton.centerYAnchor.constraint(equalTo: self.cardExpireView.centerYAnchor),
            
            self.cardCvvView.leftAnchor.constraint(equalTo: self.expireButton.rightAnchor, constant: 40),
            self.cardCvvView.topAnchor.constraint(equalTo: self.cardNumberView.bottomAnchor, constant: 20),
            self.cardCvvView.bottomAnchor.constraint(lessThanOrEqualTo: self.cardHolderView.topAnchor, constant: -10),
            self.cvvButton.leftAnchor.constraint(equalTo: self.cardCvvView.rightAnchor, constant: 10),
            self.cvvButton.rightAnchor.constraint(lessThanOrEqualTo: self.rootView.rightAnchor, constant: -20),
            self.cvvButton.heightAnchor.constraint(equalToConstant: 16),
            self.cvvButton.widthAnchor.constraint(equalToConstant: 16),
            self.cvvButton.centerYAnchor.constraint(equalTo: self.cardCvvView.centerYAnchor),
            
            self.cardHolderView.topAnchor.constraint(equalTo: self.rootView.centerYAnchor),
            self.cardHolderView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 30),
            self.cardHolderView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -20),
            self.cardBalanceView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 30),
            self.cardBalanceView.topAnchor.constraint(equalTo: self.cardHolderView.bottomAnchor, constant: 20),
            self.cardBalanceView.rightAnchor.constraint(equalTo: self.cardTypeIconView.leftAnchor, constant: -20),
            self.cardBankView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 30),
            self.cardBankView.topAnchor.constraint(equalTo: self.cardBalanceView.bottomAnchor, constant: 20),
            self.cardBankView.rightAnchor.constraint(equalTo: self.cardTypeIconView.leftAnchor, constant: -20),
            self.cardBankView.bottomAnchor.constraint(lessThanOrEqualTo: self.rootView.bottomAnchor, constant: -20),
            self.cardTypeIconView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -20),
            self.cardTypeIconView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -20),
            self.cardTypeIconView.heightAnchor.constraint(equalTo: self.rootView.heightAnchor, multiplier: 0.3),
            self.cardTypeIconView.widthAnchor.constraint(equalTo: self.cardTypeIconView.heightAnchor, multiplier: 1.4),
        ])
        self.numberButton.addTarget(self, action: #selector(self.copyInfo(_:)), for: .touchUpInside)
        self.expireButton.addTarget(self, action: #selector(self.copyInfo(_:)), for: .touchUpInside)
        self.cvvButton.addTarget(self, action: #selector(self.copyInfo(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func copyInfo(_ sender: UIButton) {
        if sender === self.numberButton {
            self.delegate?.copyInfo(cardView: self, number: true, date: false, cvv: false)
        } else if sender == self.expireButton {
            self.delegate?.copyInfo(cardView: self, number: false, date: true, cvv: false)
        } else if sender == self.cvvButton {
            self.delegate?.copyInfo(cardView: self, number: false, date: false, cvv: true)
        }
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
    
    func configure(card: AppStructs.CreditDebitCard, show: Bool, showCopy: Bool, selectedColor: (start: UIColor, end: UIColor)? = nil) {
        self.rootView.layer.borderColor = Theme.current.borderColor.withAlphaComponent(0.3).cgColor
        if let selectedColor {
            self.rootView.startColor = selectedColor.start
            self.rootView.endColor = selectedColor.end
        } else {
            if card.colorID <= 3 {
                let color = Constants.cardColors[card.colorID - 1]
                self.rootView.startColor = color.start
                self.rootView.endColor = color.end
            } else {
                self.rootView.startColor = Theme.current.mainGradientStartColor
                self.rootView.endColor = Theme.current.mainGradientEndColor
            }
        }
        self.cardNumberView.textColor = Theme.current.whiteColor
        self.cardExpireView.textColor = Theme.current.whiteColor
        self.cardCvvView.textColor = Theme.current.whiteColor
        self.cardHolderView.textColor = Theme.current.whiteColor
        self.cardBalanceView.textColor = Theme.current.whiteColor
        self.cardBankView.textColor = Theme.current.whiteColor
       
        if show {
            self.cardNumberView.text = CardTypes.formatNumber(creditCard: card.pan)
            self.cardExpireView.text = "\(card.validMonth)/\(card.validYear)"
            self.cardCvvView.text = "CVV \(card.cvv)"
            self.cardHolderView.text = card.cardHolder
            if card.showBalance {
                self.cardBalanceView.text = card.balance.balanceText
            } else {
                self.cardBalanceView.text = nil
            }
            self.cardBankView.text = card.bankName
            self.cardTypeIconView.loadImage(filePath: card.logo)
        } else {
            let last4 = String(card.pan.suffix(4))
            self.cardNumberView.text = "**** **** **** \(last4)"
            self.cardExpireView.text = "**/**"
            self.cardCvvView.text = "CVV ***"
            self.cardHolderView.text = card.cardHolder
            if card.showBalance {
                self.cardBalanceView.text = card.balance.balanceText
            } else {
                self.cardBalanceView.text = nil
            }
            self.cardBankView.text = card.bankName
            self.cardTypeIconView.loadImage(filePath: card.logo)
        }
        
        if showCopy {
            self.numberButton.isHidden = false
            self.expireButton.isHidden = false
            self.cvvButton.isHidden = false
        } else {
            self.numberButton.isHidden = true
            self.expireButton.isHidden = true
            self.cvvButton.isHidden = true
        }
    }
}
