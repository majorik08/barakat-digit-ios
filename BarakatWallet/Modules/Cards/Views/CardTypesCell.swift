//
//  CardTypesCell.swift
//  BarakatWallet
//
//  Created by km1tj on 06/11/23.
//

import Foundation
import UIKit

protocol CardTypesCellDelegate: AnyObject {
    func cardTypeTapped(item: AppStructs.CreditDebitCardTypes)
}

class CardTypesCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(CardTypeItemCell.self, forCellWithReuseIdentifier: "cell")
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentInset = .init(top: 0, left: Theme.current.mainPaddings, bottom: 0, right: Theme.current.mainPaddings)
        return view
    }()
    var items: [AppStructs.CreditDebitCardTypes] = []
    weak var delegate: CardTypesCellDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.addSubview(self.collectionView)
        NSLayoutConstraint.activate([
            self.collectionView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0),
            self.collectionView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            self.collectionView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0),
            self.collectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
        ])
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.items = []
        self.collectionView.reloadData()
    }
    
    func configure(items: [AppStructs.CreditDebitCardTypes]) {
        self.items = items
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CardTypeItemCell
        let item = self.items[indexPath.item]
        cell.configure(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let item = self.items[indexPath.item]
        self.delegate?.cardTypeTapped(item: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let topBottomPadding: CGFloat = 20
        let height = collectionView.frame.height - topBottomPadding
        let width = height * 1.74
        return .init(width: width, height: height + topBottomPadding)
    }
}

class CardTypeItemCell: UICollectionViewCell {
    
    let rootView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.backgroundColor = Theme.current.plainTableCellColor
        return view
    }()
    let mainImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.backgroundColor = .clear
        return view
    }()
    let titleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.text = "КЕШБЕК НА ВСЕ ПЛАТИ БОЛЬШЕ"
        view.font = UIFont.medium(size: 12)
        view.textAlignment = .left
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
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
        self.rootView.addSubview(self.titleView)
        NSLayoutConstraint.activate([
            self.rootView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0),
            self.rootView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.rootView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0),
            self.rootView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            self.mainImage.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
            self.mainImage.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 0),
            self.mainImage.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
            self.mainImage.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0),
            self.titleView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 10),
            self.titleView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 10),
            self.titleView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -10),
            self.titleView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(item: AppStructs.CreditDebitCardTypes) {
        self.rootView.backgroundColor = Theme.current.plainTableCellColor
        self.titleView.textColor = Theme.current.primaryTextColor
        self.titleView.text = item.name
    }
}
