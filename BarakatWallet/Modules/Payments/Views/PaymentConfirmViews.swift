//
//  PaymentConfirmViews.swift
//  BarakatWallet
//
//  Created by km1tj on 11/11/23.
//

import Foundation
import UIKit

class PaymentConfirmView: UIView {
    
    let sumView: GradientLabel = {
        let view = GradientLabel(shadowEnabled: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 30)
        view.text = "1111.11 TJS"
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.4
        return view
    }()
    let stackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.addSubview(self.sumView)
        self.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.sumView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.sumView.topAnchor.constraint(equalTo: self.topAnchor),
            self.sumView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.stackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.sumView.bottomAnchor, constant: 20),
            self.stackView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        for i in 0...3 {
            let infoView = PaymentResultItemView(frame: .zero)
            infoView.titleLabel.text = "Title #\(i)"
            infoView.infoLabel.text = "Detail #\(i)"
            self.stackView.addArrangedSubview(infoView)
        }
    }
}

class PaymentResultView: UIView {
    
    let sumView: GradientLabel = {
        let view = GradientLabel(shadowEnabled: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 30)
        view.text = "1111.11 TJS"
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.4
        view.textAlignment = .center
        return view
    }()
    let serviceView: HorizontalImageText = {
        let view = HorizontalImageText(frame: .zero)
        return view
    }()
    lazy var saveFavButton: VerticalButtonView = {
        let view = VerticalButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.nameView.text = "TO_FAVORITES".localized
        view.iconView.image = UIImage(name: .fav_icon).tintedWithLinearGradientColors()
        view.iconView.layer.borderWidth = 1
        view.iconView.layer.borderColor = Theme.current.borderColor.cgColor
        return view
    }()
    lazy var retryButton: VerticalButtonView = {
        let view = VerticalButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.nameView.text = "REPEAT".localized
        view.iconView.image = UIImage(name: .repeat_icon).tintedWithLinearGradientColors()
        view.iconView.layer.borderWidth = 1
        view.iconView.layer.borderColor = Theme.current.borderColor.cgColor
        return view
    }()
    lazy var recipeButton: VerticalButtonView = {
        let view = VerticalButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.nameView.text = "SHOW_CHECK".localized
        view.iconView.image = UIImage(name: .recipe).tintedWithLinearGradientColors()
        view.iconView.layer.borderWidth = 1
        view.iconView.layer.borderColor = Theme.current.borderColor.cgColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.addSubview(self.sumView)
        self.addSubview(self.serviceView)
        self.addSubview(self.saveFavButton)
        self.addSubview(self.retryButton)
        self.addSubview(self.recipeButton)
        NSLayoutConstraint.activate([
            self.sumView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.sumView.topAnchor.constraint(equalTo: self.topAnchor),
            self.sumView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.serviceView.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor),
            self.serviceView.topAnchor.constraint(equalTo: self.sumView.bottomAnchor, constant: 30),
            self.serviceView.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor),
            self.serviceView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.serviceView.heightAnchor.constraint(equalToConstant: 38),
            self.retryButton.topAnchor.constraint(equalTo: self.serviceView.bottomAnchor, constant: 30),
            self.retryButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.retryButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
            self.retryButton.heightAnchor.constraint(equalToConstant: 76),
            self.saveFavButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Theme.current.mainPaddings),
            self.saveFavButton.topAnchor.constraint(equalTo: self.serviceView.bottomAnchor, constant: 30),
            self.saveFavButton.rightAnchor.constraint(equalTo: self.retryButton.leftAnchor, constant: -30),
            self.saveFavButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
            self.saveFavButton.heightAnchor.constraint(equalToConstant: 76),
            self.recipeButton.leftAnchor.constraint(equalTo: self.retryButton.rightAnchor, constant: 30),
            self.recipeButton.topAnchor.constraint(equalTo: self.serviceView.bottomAnchor, constant: 30),
            self.recipeButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Theme.current.mainPaddings),
            self.recipeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
            self.recipeButton.heightAnchor.constraint(equalToConstant: 76),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PaymentResultItemView: UIView {
    
    let titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 14)
        view.textColor = Theme.current.tintColor
        view.numberOfLines = 0
        return view
    }()
    let infoLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 18)
        view.textColor = Theme.current.primaryTextColor
        view.numberOfLines = 0
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.addSubview(self.titleLabel)
        self.addSubview(self.infoLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.infoLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.infoLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 2),
            self.infoLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
