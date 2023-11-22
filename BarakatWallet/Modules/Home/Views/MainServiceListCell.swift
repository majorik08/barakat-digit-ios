//
//  MainServiceListCell.swift
//  BarakatWallet
//
//  Created by km1tj on 21/10/23.
//

import Foundation
import UIKit

class MainServiceListCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(MainServiceCell.self, forCellWithReuseIdentifier: "cell")
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
        view.text = "PAY_SERVICES".localized
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
    let emptyView: MainEmptyView = {
        let view = MainEmptyView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleView.text = "SERVICES_LOAD_ERROR_TRY".localized
        view.isHidden = true
        return view
    }()
    weak var delegate: HomeViewControllerItemDelegate? = nil
    var services: [AppStructs.PaymentGroup]? = nil
    var transfers: [AppStructs.TransferTypes]? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.addSubview(self.titleView)
        self.contentView.addSubview(self.allButton)
        self.contentView.addSubview(self.emptyView)
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
            self.emptyView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.emptyView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 8),
            self.emptyView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            self.emptyView.bottomAnchor.constraint(equalTo: self.controlView.topAnchor, constant: -8),
            self.collectionView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0),
            self.collectionView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 8),
            self.collectionView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0),
            self.controlView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.controlView.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: 8),
            self.controlView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            self.controlView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4),
            self.controlView.heightAnchor.constraint(equalToConstant: 12)
        ])
        self.emptyView.addTarget(self, action: #selector(self.reloadTapped), for: .touchUpInside)
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
    
    @objc func reloadTapped() {
        self.delegate?.reloadTapped(cell: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let services = self.services {
            self.delegate?.serviceGroupTapped(group: services[indexPath.item])
        } else if let transfers = self.transfers {
            self.delegate?.transferTapped(transfer: transfers[indexPath.item])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let services = self.services {
            return services.count
        } else if let transfers = self.transfers {
            return transfers.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainServiceCell
        if let services = self.services {
            cell.configure(service: services[indexPath.item])
        } else if let transfers = self.transfers {
            cell.configure(transfer: transfers[indexPath.item])
        }
        return cell
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        let offSet = scrollView.contentOffset.x
        //        let width = scrollView.frame.width
        //        let horizontalCenter = width / 4
        //        self.controlView.setPage(Int(offSet + horizontalCenter) / Int(width))
        let witdh = scrollView.frame.width - (scrollView.contentInset.left + scrollView.contentInset.right)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = index.rounded(.up)
        if self.controlView.numberOfPages > Int(roundedIndex) {
            self.controlView.setPage(Int(roundedIndex))
        } else {
            self.controlView.setPage(self.controlView.numberOfPages - 1)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.emptyView.isHidden = true
        self.titleView.text = nil
        self.services = nil
        self.transfers = nil
        self.collectionView.reloadData()
    }
    
    func configure(services: [AppStructs.PaymentGroup]) {
        self.emptyView.backgroundColor = Theme.current.plainTableCellColor
        self.titleView.textColor = Theme.current.primaryTextColor
        self.titleView.text = "PAY_SERVICES".localized
        self.services = services
        self.emptyView.isHidden = !services.isEmpty
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
    
    func configure(transfers: [AppStructs.TransferTypes]) {
        self.emptyView.backgroundColor = Theme.current.plainTableCellColor
        self.titleView.textColor = Theme.current.primaryTextColor
        self.titleView.text = "PAY_SENDERS".localized
        self.transfers = transfers
        self.emptyView.isHidden = !transfers.isEmpty
        self.collectionView.reloadData()
        
        
        var count: Int = 0
        if transfers.count > 0 {
            let resutl: Double = Double(transfers.count) / 4
            count = Int(resutl.rounded(.up))
        } else {
            count = 1
        }
        self.controlView.numberOfPages = count
    }
}

class MainServiceCell: UICollectionViewCell {
    
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
    let iconView: CircleImageView = {
        let view = CircleImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.current.plainTableBackColor
        view.layer.borderWidth = 0.5
        view.layer.borderColor = Theme.current.secondTintColor.cgColor
        view.contentMode = .scaleAspectFit
        view.image = UIImage(name: .wallet_inset).tintedWithLinearGradientColors()
        return view
    }()
    let titleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.text = "Service name"
        view.font = UIFont.medium(size: 12)
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
        self.rootView.addSubview(self.iconView)
        self.rootView.addSubview(self.titleView)
        NSLayoutConstraint.activate([
            self.rootView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 5),
            self.rootView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            self.rootView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5),
            self.rootView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            self.iconView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 8),
            self.iconView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 8),
            self.iconView.heightAnchor.constraint(equalTo: self.rootView.heightAnchor, multiplier: 0.45),
            self.iconView.widthAnchor.constraint(equalTo: self.iconView.heightAnchor, multiplier: 1),
            self.titleView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 8),
            self.titleView.topAnchor.constraint(equalTo: self.iconView.bottomAnchor, constant: 4),
            self.titleView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -8),
            self.titleView.bottomAnchor.constraint(lessThanOrEqualTo: self.rootView.bottomAnchor, constant: -8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(service: AppStructs.PaymentGroup) {
        self.rootView.backgroundColor = Theme.current.plainTableCellColor
        self.rootView.layer.borderColor = Theme.current.secondTintColor.withAlphaComponent(0.3).cgColor
        self.iconView.backgroundColor = Theme.current.plainTableBackColor
        self.iconView.layer.borderColor = Theme.current.secondTintColor.cgColor
        self.titleView.textColor = Theme.current.primaryTextColor
        
        self.iconView.image = UIImage(name: .wallet_inset).tintedWithLinearGradientColors()
        self.titleView.text = service.name
    }
    
    func configure(transfer: AppStructs.TransferTypes) {
        self.rootView.backgroundColor = Theme.current.plainTableCellColor
        self.rootView.layer.borderColor = Theme.current.secondTintColor.withAlphaComponent(0.3).cgColor
        self.iconView.backgroundColor = Theme.current.plainTableBackColor
        self.iconView.layer.borderColor = Theme.current.secondTintColor.cgColor
        self.titleView.textColor = Theme.current.primaryTextColor
        
        self.iconView.image = UIImage(name: .wallet_inset).tintedWithLinearGradientColors()
        self.titleView.text = transfer.name
    }
}
