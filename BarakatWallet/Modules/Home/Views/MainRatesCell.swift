//
//  MainRatesCell.swift
//  BarakatWallet
//
//  Created by km1tj on 21/10/23.
//

import Foundation
import UIKit

class MainRatesCell: UICollectionViewCell {
    
    let titleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.medium(size: 16)
        view.text = "RATES_LIST".localized
        return view
    }()
    let allButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("CONVERTOR".localized, for: .normal)
        view.setTitleColor(Theme.current.tintColor, for: .normal)
        view.titleLabel?.font = UIFont.medium(size: 16)
        view.isHidden = true
        return view
    }()
    let emptyView: MainEmptyView = {
        let view = MainEmptyView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleView.text = "RATES_LOAD_ERROR_TRY".localized
        view.isHidden = true
        return view
    }()
    let rootView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = Theme.current.plainTableCellColor
        view.layer.borderColor = Theme.current.secondTintColor.withAlphaComponent(0.3).cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    let rateView: RateView = {
        let view = RateView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    weak var delegate: HomeViewControllerItemDelegate? = nil
    
    override var isHighlighted: Bool {
        didSet {
            self.rootView.alpha = self.isHighlighted ? 0.5 : 1
            self.emptyView.alpha = self.isHighlighted ? 0.5 : 1
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.addSubview(self.titleView)
        self.contentView.addSubview(self.rootView)
        self.contentView.addSubview(self.allButton)
        self.contentView.addSubview(self.emptyView)
        self.rootView.addSubview(self.rateView)
        NSLayoutConstraint.activate([
            self.titleView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Theme.current.mainPaddings),
            self.titleView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            self.titleView.rightAnchor.constraint(lessThanOrEqualTo: self.allButton.leftAnchor, constant: -10),
            self.titleView.heightAnchor.constraint(equalToConstant: 18),
            self.allButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            self.allButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.allButton.heightAnchor.constraint(equalToConstant: 18),
            self.emptyView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Theme.current.mainPaddings),
            self.emptyView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 8),
            self.emptyView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.emptyView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4),
            self.rootView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Theme.current.mainPaddings),
            self.rootView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 8),
            self.rootView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.rootView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4),
            self.rateView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 16),
            self.rateView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 10),
            self.rateView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -16),
            self.rateView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -10),
        ])
        self.allButton.addTarget(self, action: #selector(self.allTapped), for: .touchUpInside)
        self.emptyView.addTarget(self, action: #selector(self.reloadTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func allTapped() {
        self.delegate?.goToAllTapped(cell: self)
    }
    
    @objc func reloadTapped() {
        self.delegate?.reloadTapped(cell: self)
    }
    
    func configure(rates: [AppStructs.CurrencyRate]) {
        self.titleView.text = "RATES_LIST".localized
        self.allButton.setTitle("CONVERTOR".localized, for: .normal)
        self.emptyView.isHidden = !rates.isEmpty
        self.titleView.textColor = Theme.current.primaryTextColor
        self.rootView.backgroundColor = Theme.current.plainTableCellColor
        self.rateView.configure()
        self.rateView.stackView.arrangedSubviews.forEach { v in
            v.removeFromSuperview()
        }
        for rate in rates {
            let itemView = RateView.RateItemView(frame: .zero)
            itemView.currencyView.text = rate.name
            itemView.currencyBuyView.text = rate.purchase.description
            itemView.currencySellView.text = rate.sale.description
            if rate.name == CurrencyEnum.USD.rawValue {
                itemView.iconView.image = UIImage(name: .flag_usa)
            } else if rate.name == CurrencyEnum.RUB.rawValue {
                itemView.iconView.image = UIImage(name: .flag_ru)
            } else if rate.name == CurrencyEnum.EUR.rawValue {
                itemView.iconView.image = UIImage(name: .flag_eu)
            } else {
                continue
            }
            self.rateView.stackView.addArrangedSubview(itemView)
        }
    }
}

class RateView: UIView {
    
    let rateTitle: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 14)
        view.textColor = Theme.current.primaryTextColor
        view.text = "RATE_CURRENCY".localized
        return view
    }()
    let rateBuy: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 14)
        view.textColor = Theme.current.primaryTextColor
        view.text = "RATE_CURRENCY_BUY".localized
        view.textAlignment = .right
        return view
    }()
    let rateSell: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 14)
        view.textColor = Theme.current.primaryTextColor
        view.text = "RATE_CURRENCY_SELL".localized
        view.textAlignment = .right
        return view
    }()
    let stackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.rateTitle)
        self.addSubview(self.rateBuy)
        self.addSubview(self.rateSell)
        self.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.rateTitle.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.rateTitle.topAnchor.constraint(equalTo: self.topAnchor),
            self.rateTitle.heightAnchor.constraint(equalToConstant: 20),
            self.rateTitle.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            self.rateBuy.leftAnchor.constraint(equalTo: self.rateTitle.rightAnchor),
            self.rateBuy.topAnchor.constraint(equalTo: self.topAnchor),
            self.rateBuy.heightAnchor.constraint(equalToConstant: 20),
            self.rateBuy.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25),
            self.rateSell.leftAnchor.constraint(equalTo: self.rateBuy.rightAnchor),
            self.rateSell.topAnchor.constraint(equalTo: self.topAnchor),
            self.rateSell.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.rateSell.heightAnchor.constraint(equalToConstant: 20),
            self.rateSell.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25),
            self.stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.stackView.topAnchor.constraint(equalTo: self.rateTitle.bottomAnchor, constant: 0),
            self.stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.rateTitle.textColor = Theme.current.primaryTextColor
        self.rateBuy.textColor = Theme.current.primaryTextColor
        self.rateSell.textColor = Theme.current.primaryTextColor
        self.rateTitle.text = "RATE_CURRENCY".localized
        self.rateBuy.text = "RATE_CURRENCY_BUY".localized
        self.rateSell.text = "RATE_CURRENCY_SELL".localized
    }
    
    class RateItemView: UIView {
        
        let iconView: UIImageView = {
            let view = UIImageView(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.contentMode = .scaleAspectFit
            return view
        }()
        let currencyView: UILabel = {
            let view = UILabel(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.font = UIFont.medium(size: 14)
            view.textColor = Theme.current.primaryTextColor
            view.textAlignment = .left
            return view
        }()
        let currencyBuyView: UILabel = {
            let view = UILabel(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.font = UIFont.medium(size: 14)
            view.textColor = Theme.current.primaryTextColor
            view.textAlignment = .right
            return view
        }()
        let currencySellView: UILabel = {
            let view = UILabel(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.font = UIFont.medium(size: 14)
            view.textColor = Theme.current.primaryTextColor
            view.textAlignment = .right
            return view
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(self.iconView)
            self.addSubview(self.currencyView)
            self.addSubview(self.currencyBuyView)
            self.addSubview(self.currencySellView)
            NSLayoutConstraint.activate([
                self.iconView.leftAnchor.constraint(equalTo: self.leftAnchor),
                self.iconView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
                self.iconView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
                self.iconView.widthAnchor.constraint(equalTo: self.iconView.heightAnchor, multiplier: 1),
                self.currencyView.leftAnchor.constraint(equalTo: self.iconView.rightAnchor, constant: 8),
                self.currencyView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
                self.currencyView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
                self.currencyBuyView.leftAnchor.constraint(equalTo: self.currencyView.rightAnchor),
                self.currencyBuyView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
                self.currencyBuyView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
                self.currencyBuyView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25),
                self.currencySellView.leftAnchor.constraint(equalTo: self.currencyBuyView.rightAnchor),
                self.currencySellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
                self.currencySellView.rightAnchor.constraint(equalTo: self.rightAnchor),
                self.currencySellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
                self.currencySellView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25),
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
