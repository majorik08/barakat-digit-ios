//
//  StoriesView.swift
//  BarakatWallet
//
//  Created by km1tj on 22/10/23.
//

import Foundation
import UIKit

class StoriesView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(StoriesCell.self, forCellWithReuseIdentifier: "cell")
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        view.setContentHuggingPriority(.required, for: .vertical)
        view.showsHorizontalScrollIndicator = false
        view.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    func setup() {
        self.clipsToBounds = true
        self.backgroundColor = .clear
        self.addSubview(self.collectionView)
        NSLayoutConstraint.activate([
            self.collectionView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.collectionView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            self.collectionView.heightAnchor.constraint(equalToConstant: 78),
        ])
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func themeChanged(newTheme: Theme) {
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StoriesCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 78, height: min(collectionView.frame.height, 78))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.collectionView.frame.height < 64 {
            self.collectionView.alpha = 0
        } else {
            self.collectionView.alpha = 1
        }
    }
}

