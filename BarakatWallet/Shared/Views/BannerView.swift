//
//  BannerView.swift
//  BarakatWallet
//
//  Created by km1tj on 22/11/23.
//

import Foundation
import UIKit

class BannerView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(BannerCell.self, forCellWithReuseIdentifier: "cell")
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        return view
    }()
    let pageControl: AdvancedPageControlView = {
        let view = AdvancedPageControlView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var banners: [AppStructs.Banner] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        self.backgroundColor = .clear
        self.addSubview(self.collectionView)
        self.addSubview(self.pageControl)
        NSLayoutConstraint.activate([
            self.collectionView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.collectionView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.collectionView.heightAnchor.constraint(equalToConstant: 108),
            self.pageControl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.pageControl.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: 10),
            self.pageControl.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            self.pageControl.heightAnchor.constraint(equalToConstant: 12)
        ])
        self.pageControl.drawer = ExtendedDotDrawer(numberOfPages: 1, space: 8, indicatorColor: Theme.current.tintColor, dotsColor: Theme.current.secondTintColor, isBordered: false, borderWidth: 0.0, indicatorBorderColor: .clear, indicatorBorderWidth: 0.0)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func configure(banners: [AppStructs.Banner]) {
        self.banners = banners
        self.collectionView.reloadData()
        var count: Int = 0
        if banners.count > 0 {
            let resutl: Double = Double(banners.count)
            count = Int(resutl.rounded(.up))
        } else {
            count = 1
        }
        self.pageControl.numberOfPages = count
    }
    
    func themeChanged(newTheme: Theme) {
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.banners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BannerCell
        cell.configure(banner: self.banners[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: self.frame.width, height: min(collectionView.frame.height, 108))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width - (scrollView.contentInset.left + scrollView.contentInset.right)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = index.rounded(.up)
        if self.pageControl.numberOfPages > Int(roundedIndex) {
            self.pageControl.setPage(Int(roundedIndex))
        } else {
            self.pageControl.setPage(self.pageControl.numberOfPages - 1)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.collectionView.frame.height < 50 {
            self.collectionView.alpha = 0
        } else {
            self.collectionView.alpha = 1
        }
    }
}

class BannerCell: UICollectionViewCell {
    
    let rootView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = Theme.current.borderColor.cgColor
        view.layer.cornerRadius = 14
        view.layer.shadowColor = Theme.current.shadowColor.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.backgroundColor = Theme.current.plainTableBackColor
        return view
    }()
    let imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = nil
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 14
        return view
    }()
    let titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 18)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    let subTitleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 14)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.addSubview(self.rootView)
        self.rootView.addSubview(self.imageView)
        self.rootView.addSubview(self.titleLabel)
        self.rootView.addSubview(self.subTitleLabel)
        NSLayoutConstraint.activate([
            self.rootView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Theme.current.mainPaddings),
            self.rootView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            self.rootView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.rootView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4),
            self.imageView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
            self.imageView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 0),
            self.imageView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
            self.imageView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0),
            self.titleLabel.leftAnchor.constraint(equalTo: self.rootView.centerXAnchor, constant: -20),
            self.titleLabel.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 20),
            self.titleLabel.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -16),
            self.subTitleLabel.leftAnchor.constraint(equalTo: self.rootView.centerXAnchor, constant: -20),
            self.subTitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            self.subTitleLabel.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -16),
            self.subTitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.rootView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(banner: AppStructs.Banner) {
        self.rootView.backgroundColor = Theme.current.plainTableBackColor
        self.titleLabel.textColor = Theme.current.tintColor
        self.subTitleLabel.textColor = Theme.current.primaryTextColor
        self.imageView.loadImage(filePath: banner.image)
        self.titleLabel.text = banner.title
        self.subTitleLabel.text = banner.text
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.titleLabel.text = nil
        self.subTitleLabel.text = nil
    }
}
