//
//  CardReleaseTypeCell.swift
//  BarakatWallet
//
//  Created by km1tj on 19/11/23.
//

import Foundation
import UIKit

protocol CardReleaseTypeCellDelegate: AnyObject {
    func didSelectCardType(item: AppStructs.CreditDebitCardTypes)
}

class CardReleaseTypeCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 10
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(CardReleaseTypeItemCell.self, forCellWithReuseIdentifier: "cell")
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentInset = .init(top: 10, left: Theme.current.mainPaddings, bottom: 10, right: Theme.current.mainPaddings)
        return view
    }()
    var items: [AppStructs.CreditDebitCardTypes] = []
    weak var delegate: CardReleaseTypeCellDelegate? = nil
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let item = self.items[indexPath.item]
        self.delegate?.didSelectCardType(item: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CardReleaseTypeItemCell
        let item = self.items[indexPath.item]
        cell.configure(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let topBottomPadding: CGFloat = 20
        let height = collectionView.frame.height - topBottomPadding
        let item = self.items[indexPath.item].name as NSString
        return CGSize(width: item.size(withAttributes: [NSAttributedString.Key.font : UIFont.medium(size: 10)]).width + 32 + 10, height: height)
    }
}

class CardReleaseTypeItemCell: UICollectionViewCell {
    
    let rootView: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.startColor = Theme.current.mainGradientStartColor
        view.endColor = Theme.current.mainGradientEndColor
        return view
    }()
    let titleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.whiteColor
        view.font = UIFont.medium(size: 10)
        view.numberOfLines = 1
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
        self.rootView.addSubview(self.titleView)
        NSLayoutConstraint.activate([
            self.rootView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0),
            self.rootView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            self.rootView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0),
            self.rootView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            self.titleView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 16),
            self.titleView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 6),
            self.titleView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -16),
            self.titleView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -6),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(item: AppStructs.CreditDebitCardTypes) {
        self.rootView.startColor = Theme.current.mainGradientStartColor
        self.rootView.endColor = Theme.current.mainGradientEndColor
        self.titleView.textColor = Theme.current.whiteColor
        self.titleView.text = item.name
    }
}
