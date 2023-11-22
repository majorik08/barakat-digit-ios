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
    weak var delegate: HomeViewControllerItemDelegate? = nil
    var rates: [AppStructs.CurrencyRate] = []
    
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
        NSLayoutConstraint.activate([
            self.titleView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.titleView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            self.titleView.rightAnchor.constraint(lessThanOrEqualTo: self.allButton.leftAnchor, constant: -10),
            self.titleView.heightAnchor.constraint(equalToConstant: 18),
            self.allButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            self.allButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            self.allButton.heightAnchor.constraint(equalToConstant: 18),
            self.emptyView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.emptyView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 8),
            self.emptyView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            self.emptyView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4),
            self.rootView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.rootView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 8),
            self.rootView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            self.rootView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4),
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
        self.emptyView.isHidden = !rates.isEmpty
        self.rates = rates
        self.titleView.textColor = Theme.current.primaryTextColor
        self.rootView.backgroundColor = Theme.current.plainTableCellColor
    }
}
