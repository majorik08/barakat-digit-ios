//
//  ShowCaseFilter.swift
//  BarakatWallet
//
//  Created by km1tj on 28/11/23.
//

import Foundation
import UIKit

protocol ShowCaseFilterViewDelegate: AnyObject {
    func didSelectFilter(item: ShowcaseFilter)
}

class ShowCaseFilterView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 10
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(ShowCaseFilterCell.self, forCellWithReuseIdentifier: "cell")
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentInset = .init(top: 0, left: Theme.current.mainPaddings, bottom: 0, right: Theme.current.mainPaddings)
        return view
    }()
    weak var delegate: ShowCaseFilterViewDelegate? = nil
    var filters: [ShowcaseFilter] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.addSubview(self.collectionView)
        NSLayoutConstraint.activate([
            self.collectionView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.collectionView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(items: [ShowcaseFilter]) {
        self.filters = items
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.delegate?.didSelectFilter(item: self.filters[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ShowCaseFilterCell
        cell.configure(filter: self.filters[indexPath.item])
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let topBottomPadding: CGFloat = 0
        let height = collectionView.frame.height - topBottomPadding
        let item = self.filters[indexPath.item]
        let width = item.text.size(withAttributes: [NSAttributedString.Key.font : UIFont.medium(size: 12)]).width + 32 + 10
        if item.hasOptions || item.isInstaled {
            return CGSize(width: width + 10 + 4, height: height)
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}


class ShowCaseFilterCell: UICollectionViewCell {
    
    let rootView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 17
        view.layer.borderColor = Theme.current.borderColor.withAlphaComponent(0.8).cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = Theme.current.plainTableCellColor
        return view
    }()
    let titleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.whiteColor
        view.font = UIFont.medium(size: 12)
        view.numberOfLines = 1
        view.textAlignment = .center
        return view
    }()
    let iconView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.tintColor = Theme.current.primaryTextColor
        return view
    }()
    
    override var isHighlighted: Bool {
        didSet {
            self.rootView.alpha = self.isHighlighted ? 0.5 : 1
        }
    }
    var wiImageAnchor: NSLayoutConstraint!
    var withoutImageAnchor: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.addSubview(self.rootView)
        self.rootView.addSubview(self.titleView)
        self.rootView.addSubview(self.iconView)
        self.wiImageAnchor = self.titleView.rightAnchor.constraint(equalTo: self.iconView.leftAnchor, constant: -4)
        self.withoutImageAnchor = self.titleView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -16)
        NSLayoutConstraint.activate([
            self.rootView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0),
            self.rootView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            self.rootView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0),
            self.rootView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            self.titleView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 16),
            self.titleView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 4),
            self.withoutImageAnchor,
            self.titleView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -4),
            self.iconView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 12),
            self.iconView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -16),
            self.iconView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -10),
            self.iconView.widthAnchor.constraint(equalTo: self.iconView.heightAnchor, multiplier: 1),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(filter: ShowcaseFilter) {
        self.rootView.backgroundColor = filter.isInstaled ? Theme.current.tintColor : Theme.current.plainTableCellColor
        self.titleView.textColor = Theme.current.primaryTextColor
        self.iconView.tintColor = Theme.current.primaryTextColor
        if filter.isInstaled || filter.hasOptions {
            self.iconView.isHidden = false
            self.iconView.image = filter.isInstaled ? UIImage(name: .close_x) : UIImage(name: .down_arrow)
            self.withoutImageAnchor.isActive = false
            self.wiImageAnchor.isActive = true
        } else {
            self.iconView.isHidden = true
            self.withoutImageAnchor.isActive = true
            self.wiImageAnchor.isActive = false
        }
        self.titleView.text = filter.text
    }
}
