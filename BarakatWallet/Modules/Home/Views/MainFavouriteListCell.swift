//
//  MainFavouriteListCell.swift
//  BarakatWallet
//
//  Created by km1tj on 21/10/23.
//

import Foundation
import UIKit

class MainFavouriteListCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(MainFavouriteCell.self, forCellWithReuseIdentifier: "cell")
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
        view.text = "FAVOURITE_SERVICES".localized
        return view
    }()
    let allButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("ALL".localized, for: .normal)
        view.titleLabel?.font = UIFont.medium(size: 16)
        view.setTitleColor(Theme.current.tintColor, for: .normal)
        return view
    }()
    let controlView: AdvancedPageControlView = {
        let view = AdvancedPageControlView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    weak var delegate: HomeViewControllerItemDelegate? = nil
    var favorites: [AppStructs.Favourite] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.addSubview(self.titleView)
        self.contentView.addSubview(self.allButton)
        self.contentView.addSubview(self.collectionView)
        self.contentView.addSubview(self.controlView)
        NSLayoutConstraint.activate([
            self.titleView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.titleView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            self.titleView.rightAnchor.constraint(lessThanOrEqualTo: self.allButton.leftAnchor, constant: -10),
            self.titleView.heightAnchor.constraint(equalToConstant: 18),
            self.allButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            self.allButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            self.allButton.heightAnchor.constraint(equalToConstant: 18),
            self.collectionView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0),
            self.collectionView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 8),
            self.collectionView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0),
            self.controlView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.controlView.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: 8),
            self.controlView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            self.controlView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4),
            self.controlView.heightAnchor.constraint(equalToConstant: 12)
        ])
        self.allButton.addTarget(self, action: #selector(self.allTapped), for: .touchUpInside)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.controlView.drawer = ExtendedDotDrawer(numberOfPages: 1, space: 8, indicatorColor: Theme.current.tintColor, dotsColor: Theme.current.secondTintColor, isBordered: false, borderWidth: 0.0, indicatorBorderColor: .clear, indicatorBorderWidth: 0.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func allTapped() {
        self.delegate?.goToAllTapped(cell: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.item < self.favorites.count {
            self.delegate?.favouriteTapped(favouite: self.favorites[indexPath.item])
        } else {
            self.delegate?.favouriteTapped(favouite: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.favorites.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainFavouriteCell
        if indexPath.item < self.favorites.count {
            cell.configure(item: self.favorites[indexPath.item])
        } else {
            cell.configure(item: nil)
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width - (scrollView.contentInset.left + scrollView.contentInset.right)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = index.rounded(.up)
        if self.controlView.numberOfPages > Int(roundedIndex) {
            self.controlView.setPage(Int(roundedIndex))
        } else {
            self.controlView.setPage(self.controlView.numberOfPages - 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.frame.width
        guard width > 0 else {
            return .init(width: 1, height: 1)
        }
        let itemWidth = ((width - 22) / 4)
        let height = (itemWidth - 10) - 2
        return .init(width: itemWidth, height: height)
    }
    
    func configure(items: [AppStructs.Favourite]) {
        self.favorites = items
        self.titleView.textColor = Theme.current.primaryTextColor
        self.collectionView.reloadData()
        
        let allCount = items.count + 1
        var count: Int = 0
        if allCount > 0 {
            let resutl: Double = Double(allCount) / 4
            count = Int(resutl.rounded(.up))
        } else {
            count = 1
        }
        self.controlView.numberOfPages = count
    }
}

class MainFavouriteCell: UICollectionViewCell {
    
    let rootView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        view.backgroundColor = Theme.current.plainTableCellColor
        view.layer.borderColor = Theme.current.secondTintColor.withAlphaComponent(0.3).cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    let iconView: CircleImageView = {
        let view = CircleImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.current.plainTableBackColor
        view.isUserInteractionEnabled = false
        return view
    }()
    let titleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.regular(size: 12)
        view.text = "МегаФон"
        return view
    }()
    let subTitleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.secondaryTextColor
        view.font = UIFont.regular(size: 12)
        view.text = "905005050"
        return view
    }()
    let addLabelView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "ADD_FAV".localized
        view.font = UIFont.regular(size: 12)
        view.minimumScaleFactor = 0.8
        view.adjustsFontSizeToFitWidth = true
        view.textColor = Theme.current.primaryTextColor
        view.isHidden = true
        view.textAlignment = .center
        return view
    }()
    let addImageView: CircleImageView = {
        let view = CircleImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = Theme.current.whiteColor
        view.contentMode = .scaleAspectFit
        view.image = UIImage(name: .add_bold)
        view.backgroundColor = Theme.current.tintColor
        view.isHidden = true
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
        self.rootView.addSubview(self.addImageView)
        self.rootView.addSubview(self.addLabelView)
        self.rootView.addSubview(self.iconView)
        self.rootView.addSubview(self.titleView)
        self.rootView.addSubview(self.subTitleView)
        NSLayoutConstraint.activate([
            self.rootView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 5),
            self.rootView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            self.rootView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5),
            self.rootView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            
            self.addLabelView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 8),
            self.addLabelView.topAnchor.constraint(greaterThanOrEqualTo: self.rootView.topAnchor, constant: 8),
            self.addLabelView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -8),
            self.addLabelView.bottomAnchor.constraint(equalTo: self.addImageView.topAnchor, constant: -4),
            self.addImageView.topAnchor.constraint(equalTo: self.rootView.centerYAnchor, constant: -8),
            self.addImageView.centerXAnchor.constraint(equalTo: self.rootView.centerXAnchor),
            self.addImageView.heightAnchor.constraint(equalTo: self.rootView.heightAnchor, multiplier: 0.35),
            self.addImageView.widthAnchor.constraint(equalTo: self.addImageView.heightAnchor, multiplier: 1),
            
            self.iconView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 8),
            self.iconView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 8),
            self.iconView.heightAnchor.constraint(equalTo: self.rootView.heightAnchor, multiplier: 0.45),
            self.iconView.widthAnchor.constraint(equalTo: self.iconView.heightAnchor, multiplier: 1),
            self.titleView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 8),
            self.titleView.topAnchor.constraint(equalTo: self.iconView.bottomAnchor, constant: 4),
            self.titleView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -8),
            self.subTitleView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 8),
            self.subTitleView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 0),
            self.subTitleView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -8),
            self.subTitleView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(item: AppStructs.Favourite?) {
        self.rootView.backgroundColor = Theme.current.plainTableCellColor
        self.iconView.backgroundColor = Theme.current.plainTableBackColor
        self.titleView.textColor = Theme.current.primaryTextColor
        self.subTitleView.textColor = Theme.current.secondaryTextColor
        if let _ = item {
            self.addLabelView.isHidden = true
            self.addImageView.isHidden = true
            self.titleView.isHidden = false
            self.iconView.isHidden = false
            self.subTitleView.isHidden = false
        } else {
            self.addLabelView.isHidden = false
            self.addImageView.isHidden = false
            self.titleView.isHidden = true
            self.iconView.isHidden = true
            self.subTitleView.isHidden = true
        }
    }
}
