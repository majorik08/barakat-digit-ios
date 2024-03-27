//
//  PaymentServiceSelectView.swift
//  BarakatWallet
//
//  Created by km1tj on 04/02/24.
//

import Foundation
import UIKit

protocol PaymentServiceSelectViewDelegate: AnyObject {
    func serviceSelected()
}

class PaymentServiceSelectView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(PaymentServiceSelectCell.self, forCellWithReuseIdentifier: "cell")
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        //view.allowsSelection = true
        view.contentInset = .init(top: 0, left: Theme.current.mainPaddings - 5, bottom: 0, right: Theme.current.mainPaddings - 5)
        return view
    }()
    let titleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.tintColor
        view.font = UIFont.medium(size: 16)
        view.textAlignment = .center
        view.text = "SELECT_WALLET_OR_BANK".localized
        return view
    }()
    let controlView: AdvancedPageControlView = {
        let view = AdvancedPageControlView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let emptyView: MainEmptyView = {
        let view = MainEmptyView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleView.text = "LOADING".localized
        view.layer.borderWidth = 0
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        view.backgroundColor = Theme.current.plainTableCellColor
        view.isHidden = false
        return view
    }()
    weak var delegate: PaymentServiceSelectViewDelegate? = nil
    var services: [PaymentsViewModel.NumberServiceInfo] = []
    var selectedService: PaymentsViewModel.NumberServiceInfo? = nil
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(self.titleView)
        self.addSubview(self.emptyView)
        self.addSubview(self.collectionView)
        self.addSubview(self.controlView)
        NSLayoutConstraint.activate([
            self.titleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.titleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.titleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.emptyView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Theme.current.mainPaddings),
            self.emptyView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 10),
            self.emptyView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Theme.current.mainPaddings),
            self.emptyView.bottomAnchor.constraint(equalTo: self.controlView.topAnchor, constant: -8),
            self.collectionView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.collectionView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 10),
            self.collectionView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.controlView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.controlView.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: 8),
            self.controlView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.controlView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            self.controlView.heightAnchor.constraint(equalToConstant: 12)
        ])
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.controlView.drawer = ExtendedDotDrawer(numberOfPages: 1, space: 8, indicatorColor: Theme.current.tintColor, dotsColor: Theme.current.secondTintColor, isBordered: false, borderWidth: 0.0, indicatorBorderColor: .clear, indicatorBorderWidth: 0.0)
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.services[indexPath.item]
        if item.service.id == self.selectedService?.service.id {
            self.selectedService = nil
            collectionView.deselectItem(at: indexPath, animated: true)
        } else {
            self.selectedService = item
        }
        self.delegate?.serviceSelected()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.services.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PaymentServiceSelectCell
        let item = self.services[indexPath.item]
        cell.configure(service: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.frame.width
        guard width > 0 else {
            return .init(width: 1, height: 1)
        }
        let itemWidth = ((width - ((Theme.current.mainPaddings - 5) * 2)) / 4)
        let size = CGSize(width: itemWidth, height: min(collectionView.frame.height, itemWidth - 10))
        return size
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
    
    func configure(services: [PaymentsViewModel.NumberServiceInfo]) {
        if services.isEmpty {
            self.emptyView.isHidden = false
            self.titleView.isHidden = false
            self.controlView.isHidden = true
        } else {
            self.emptyView.isHidden = true
            self.titleView.isHidden = false
            self.controlView.isHidden = false
        }
        self.selectedService = nil
        self.services = services
        self.collectionView.reloadData()
        var count: Int = 0
        if services.count > 0 {
            let resutl: Double = Double(services.count) / 4
            count = Int(resutl.rounded(.up))
        } else {
            count = 1
        }
        self.controlView.numberOfPages = count
    }
}

class PaymentServiceSelectCell: UICollectionViewCell {
    
    let rootView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        view.layer.borderColor = Theme.current.secondTintColor.withAlphaComponent(0.3).cgColor
        view.layer.borderWidth = 0.5
        view.backgroundColor = Theme.current.plainTableCellColor
        return view
    }()
    let iconContainer: CircleView = {
        let view = CircleView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.current.plainTableBackColor
        view.layer.borderWidth = 0.5
        view.clipsToBounds = true
        view.layer.borderColor = Theme.current.secondTintColor.cgColor
        return view
    }()
    let iconView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    let titleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.medium(size: 12)
        view.numberOfLines = 1
        return view
    }()
    let subTitleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.whiteColor
        view.font = UIFont.medium(size: 12)
        view.numberOfLines = 1
        return view
    }()
    override var isHighlighted: Bool {
        didSet {
            self.rootView.alpha = self.isHighlighted ? 0.5 : 1
        }
    }
    override var isSelected: Bool {
        didSet {
            self.iconView.image = isSelected ? Theme.current.dark ? UIImage(name: .check_dark) : UIImage(name: .check_light) : nil
            self.iconContainer.isHidden = isSelected
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.addSubview(self.rootView)
        self.rootView.addSubview(self.iconContainer)
        self.rootView.addSubview(self.titleView)
        self.rootView.addSubview(self.subTitleView)
        self.rootView.addSubview(self.iconView)
        NSLayoutConstraint.activate([
            self.rootView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 5),
            self.rootView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            self.rootView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5),
            self.rootView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            self.iconContainer.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 8),
            self.iconContainer.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 8),
            self.iconContainer.heightAnchor.constraint(equalTo: self.rootView.heightAnchor, multiplier: 0.45),
            self.iconContainer.widthAnchor.constraint(equalTo: self.iconContainer.heightAnchor, multiplier: 1),
            self.titleView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 8),
            self.titleView.topAnchor.constraint(equalTo: self.iconContainer.bottomAnchor, constant: 2),
            self.titleView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -4),
            self.subTitleView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 8),
            self.subTitleView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 0),
            self.subTitleView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -4),
            self.subTitleView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -8),
            self.iconView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 8),
            self.iconView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 4),
            self.iconView.rightAnchor.constraint(equalTo: self.iconContainer.rightAnchor, constant: 8),
            self.iconView.bottomAnchor.constraint(equalTo: self.iconContainer.bottomAnchor, constant: 0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.iconView.image = nil
        self.titleView.text = nil
        self.subTitleView.text = nil
    }
    
    func configure(service: PaymentsViewModel.NumberServiceInfo) {
        self.rootView.backgroundColor = Theme.current.plainTableCellColor
        self.rootView.layer.borderColor = Theme.current.secondTintColor.withAlphaComponent(0.3).cgColor
        self.iconContainer.backgroundColor = Theme.current.plainTableBackColor
        self.iconContainer.layer.borderColor = Theme.current.borderColor.cgColor
        self.titleView.textColor = Theme.current.primaryTextColor
        self.titleView.textColor = Theme.current.whiteColor
        self.titleView.text = service.service.name
        self.subTitleView.text = service.accountInfo.info
        self.rootView.backgroundColor = service.color
    }
}
