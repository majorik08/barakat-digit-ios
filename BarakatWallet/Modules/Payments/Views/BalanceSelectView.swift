//
//  BalanceSelectView.swift
//  BarakatWallet
//
//  Created by km1tj on 08/11/23.
//

import Foundation
import UIKit

class BalanceSelectView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let titleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.medium(size: 16)
        view.text = "CARDS".localized
        return view
    }()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(BalanceCell.self, forCellWithReuseIdentifier: "cell")
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        view.isPagingEnabled = true
        return view
    }()
    let controlView: AdvancedPageControlView = {
        let view = AdvancedPageControlView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var accounts: [AppStructs.Account] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(self.titleView)
        self.addSubview(self.collectionView)
        self.addSubview(self.controlView)
        NSLayoutConstraint.activate([
            self.titleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.titleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.titleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.titleView.heightAnchor.constraint(equalToConstant: 18),
            self.collectionView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.collectionView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 8),
            self.collectionView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.controlView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.controlView.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: 8),
            self.controlView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.controlView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2),
            self.controlView.heightAnchor.constraint(equalToConstant: 12)
        ])
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.controlView.drawer = ExtendedDotDrawer(numberOfPages: 3, space: 8, indicatorColor: Theme.current.tintColor, dotsColor: Theme.current.secondTintColor, isBordered: false, borderWidth: 0.0, indicatorBorderColor: .clear, indicatorBorderWidth: 0.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(accounts: [AppStructs.Account]) {
        self.accounts = accounts
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.accounts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BalanceCell
        cell.configure(account: self.accounts[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.frame.width
        guard width > 0 else {
            return .init(width: 1, height: 1)
        }
        return .init(width: width, height: width * 0.4)
    }
}

class BalanceCell: UICollectionViewCell {
    
    func configure(account: AppStructs.Account) {
        
    }
}
