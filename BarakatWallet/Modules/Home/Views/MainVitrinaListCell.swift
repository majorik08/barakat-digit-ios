//
//  MainVitrinaListCell.swift
//  BarakatWallet
//
//  Created by km1tj on 21/10/23.
//

import Foundation
import UIKit

class MainVitrinaListCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(MainVitrinaCell.self, forCellWithReuseIdentifier: "cell")
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentInset = .init(top: 0, left: 11, bottom: 0, right: 11)
        //view.isPagingEnabled = true
        return view
    }()
    let titleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.medium(size: 16)
        view.text = "SHOWCASE".localized
        return view
    }()
    let allButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("ALL".localized, for: .normal)
        view.setTitleColor(Theme.current.tintColor, for: .normal)
        view.titleLabel?.font = UIFont.medium(size: 16)
        return view
    }()
    let controlView: AdvancedPageControlView = {
        let view = AdvancedPageControlView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    weak var delegate: HomeViewControllerItemDelegate? = nil
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.delegate?.showcaseTapped(showcase: .init())
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainVitrinaCell
        cell.configure()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.frame.width
        guard width > 0 else {
            return .init(width: 1, height: 1)
        }
        let itemWidth = ((width - 22) / 2.6)
        let height = (itemWidth - 10) * 0.6
        return .init(width: itemWidth, height: height)
    }
    
    func configure() {
        self.titleView.textColor = Theme.current.primaryTextColor
        self.collectionView.reloadData()
    }
}


class MainVitrinaCell: UICollectionViewCell {
    
    let rootView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.backgroundColor = Theme.current.plainTableCellColor
        view.layer.borderColor = Theme.current.secondTintColor.withAlphaComponent(0.3).cgColor
        view.layer.borderWidth = 0.5
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
        view.font = UIFont.medium(size: 10)
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
            self.rootView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 5),
            self.rootView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            self.rootView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5),
            self.rootView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            self.mainImage.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
            self.mainImage.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 0),
            self.mainImage.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
            self.mainImage.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0),
            self.titleView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 10),
            self.titleView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 10),
            self.titleView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -10),
            self.titleView.bottomAnchor.constraint(lessThanOrEqualTo: self.rootView.bottomAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.titleView.textColor = Theme.current.primaryTextColor
        self.rootView.backgroundColor = Theme.current.plainTableCellColor
    }
}
