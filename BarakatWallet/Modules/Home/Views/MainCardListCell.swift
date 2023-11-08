//
//  MainCardListCell.swift
//  BarakatWallet
//
//  Created by km1tj on 21/10/23.
//

import Foundation
import UIKit

class MainCardListCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(MainCardCell.self, forCellWithReuseIdentifier: "cell")
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentInset = .init(top: 0, left: 11, bottom: 0, right: 11)
        return view
    }()
    let titleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.medium(size: 16)
        view.text = "CARDS".localized
        return view
    }()
    let controlView: AdvancedPageControlView = {
        let view = AdvancedPageControlView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var cards: [AppStructs.CreditDebitCard] = []
    weak var delegate: HomeViewControllerItemDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.addSubview(self.titleView)
        self.contentView.addSubview(self.collectionView)
        self.contentView.addSubview(self.controlView)
        NSLayoutConstraint.activate([
            self.titleView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.titleView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            self.titleView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            self.titleView.heightAnchor.constraint(equalToConstant: 18),
            self.collectionView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0),
            self.collectionView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 8),
            self.collectionView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0),
            self.controlView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.controlView.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: 8),
            self.controlView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            self.controlView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -2),
            self.controlView.heightAnchor.constraint(equalToConstant: 12)
        ])
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.controlView.drawer = ExtendedDotDrawer(numberOfPages: 1, space: 8, indicatorColor: Theme.current.tintColor, dotsColor: Theme.current.secondTintColor, isBordered: false, borderWidth: 0.0, indicatorBorderColor: .clear, indicatorBorderWidth: 0.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(cards: [AppStructs.CreditDebitCard]) {
        self.titleView.textColor = Theme.current.primaryTextColor
        self.cards = cards
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cards.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.item < self.cards.count {
            let card = self.cards[indexPath.item]
            self.delegate?.cardTapped(card: card)
        } else {
            self.delegate?.cardTapped(card: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainCardCell
        if indexPath.item < self.cards.count {
            let card = self.cards[indexPath.item]
            cell.configure(card: card)
        } else {
            cell.configure(card: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.frame.width
        guard width > 0 else {
            return .init(width: 1, height: 1)
        }
        let itemWidth = ((width - 22) / 2.5)
        let height = (itemWidth - 10) * 0.63
        return .init(width: itemWidth, height: height)
    }
}

class MainCardCell: UICollectionViewCell {
    
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
        view.font = UIFont.medium(size: 14)
        view.textColor = .white
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.8
        return view
    }()
    let cardBalanceView: UILabel = {
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
        return view
    }()
    let addCardLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 16)
        view.text = "ADD_CARD".localized
        view.textColor = Theme.current.tintColor
        view.numberOfLines = 0
        view.textAlignment = .center
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
        self.rootView.addSubview(self.cardBalanceView)
        self.rootView.addSubview(self.cardNumberView)
        self.rootView.addSubview(self.cardTypeIconView)
        self.rootView.addSubview(self.addCardLabel)
        NSLayoutConstraint.activate([
            self.rootView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 5),
            self.rootView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            self.rootView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5),
            self.rootView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            self.mainImage.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
            self.mainImage.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 0),
            self.mainImage.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
            self.mainImage.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0),
            self.addCardLabel.leftAnchor.constraint(equalTo: self.rootView.leftAnchor),
            self.addCardLabel.topAnchor.constraint(equalTo: self.rootView.topAnchor),
            self.addCardLabel.rightAnchor.constraint(equalTo: self.rootView.rightAnchor),
            self.addCardLabel.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor),
            self.cardBalanceView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 12),
            self.cardBalanceView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 12),
            self.cardBalanceView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -12),
            self.cardNumberView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 12),
            self.cardNumberView.topAnchor.constraint(greaterThanOrEqualTo: self.cardBalanceView.bottomAnchor, constant: 12),
            self.cardNumberView.rightAnchor.constraint(equalTo: self.cardTypeIconView.leftAnchor, constant: -12),
            self.cardNumberView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -12),
            self.cardTypeIconView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -12),
            self.cardTypeIconView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -8),
            self.cardTypeIconView.heightAnchor.constraint(equalTo: self.rootView.heightAnchor, multiplier: 0.3),
            self.cardTypeIconView.widthAnchor.constraint(equalTo: self.cardTypeIconView.heightAnchor, multiplier: 1.4),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(card: AppStructs.CreditDebitCard?) {
        if let _ = card {
            self.cardNumberView.isHidden = false
            self.cardBalanceView.isHidden = false
            self.cardTypeIconView.isHidden = false
            self.addCardLabel.isHidden = true
            self.cardTypeIconView.image = UIImage(name: .card_visa)
            self.cardBalanceView.text = "7777 c."
            self.cardNumberView.text = "•• 4242"
            self.rootView.endColor = Theme.current.cardGradientEndColor
            self.rootView.startColor = Theme.current.cardGradientStartColor
            self.rootView.backgroundColor = .clear
        } else {
            self.cardNumberView.isHidden = true
            self.cardBalanceView.isHidden = true
            self.cardTypeIconView.isHidden = true
            self.addCardLabel.isHidden = false
            self.rootView.endColor = .clear
            self.rootView.startColor = .clear
            self.rootView.backgroundColor = Theme.current.plainTableCellColor
        }
    }
}
