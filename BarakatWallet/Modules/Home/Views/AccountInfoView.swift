//
//  AccountInfoView-.swift
//  BarakatWallet
//
//  Created by km1tj on 21/10/23.
//

import Foundation
import UIKit

class AccountInfoView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    private let balanceHintLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 20)
        view.textColor = .white
        view.text = "WALLET_BALANCE_HINT".localized
        return view
    }()
    private let balanceLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 25)
        view.textColor = .white
        view.text = "00.00 s."
        return view
    }()
    private let bonusLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 16)
        view.textColor = .white
        view.text = "00.00 som. bonus"
        return view
    }()
    private let plusButton: CircleButtonView = {
        let view = CircleButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .white
        view.setImage(UIImage(name: .plus_icon), for: .normal)
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.19)
        view.imageView?.contentMode = .scaleAspectFit
        view.imageEdgeInsets = .init(top: 4, left: 4, bottom: 4, right: 4)
        return view
    }()
    private let hideButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .white
        view.setImage(UIImage(name: .hide_eyes), for: .normal)
        view.imageView?.contentMode = .scaleAspectFit
        return view
    }()
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
        self.addSubview(self.balanceHintLabel)
        self.addSubview(self.balanceLabel)
        self.addSubview(self.bonusLabel)
        self.addSubview(self.plusButton)
        self.addSubview(self.hideButton)
        self.addSubview(self.collectionView)
        NSLayoutConstraint.activate([
            self.balanceHintLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.balanceHintLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.balanceHintLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            self.balanceHintLabel.heightAnchor.constraint(equalToConstant: 20),
            self.balanceLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.balanceLabel.topAnchor.constraint(equalTo: self.balanceHintLabel.bottomAnchor, constant: 6),
            self.balanceLabel.heightAnchor.constraint(equalToConstant: 24),
            self.bonusLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.bonusLabel.topAnchor.constraint(equalTo: self.balanceLabel.bottomAnchor, constant: 6),
            self.bonusLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            self.bonusLabel.heightAnchor.constraint(equalToConstant: 16),
            self.plusButton.leftAnchor.constraint(equalTo: self.balanceLabel.rightAnchor, constant: 10),
            self.plusButton.topAnchor.constraint(equalTo: self.balanceHintLabel.bottomAnchor, constant: 4),
            self.plusButton.heightAnchor.constraint(equalToConstant: 26),
            self.plusButton.widthAnchor.constraint(equalToConstant: 26),
            self.hideButton.leftAnchor.constraint(equalTo: self.plusButton.rightAnchor, constant: 10),
            self.hideButton.topAnchor.constraint(equalTo: self.balanceHintLabel.bottomAnchor, constant: 4),
            self.hideButton.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -10),
            self.hideButton.heightAnchor.constraint(equalToConstant: 26),
            self.hideButton.widthAnchor.constraint(equalToConstant: 26),
            self.collectionView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.collectionView.topAnchor.constraint(greaterThanOrEqualTo: self.bonusLabel.bottomAnchor, constant: 10),
            self.collectionView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            self.collectionView.heightAnchor.constraint(equalToConstant: 78),
        ])
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func themeChanged(newTheme: Theme) {
        self.collectionView.reloadData()
//        self.balanceHintLabel.textColor = Theme.current.primaryTextColor
//        self.balanceLabel.textColor = Theme.current.primaryTextColor
//        self.bonusLabel.textColor = Theme.current.primaryTextColor
//        self.walletIcon.tintColor = Theme.current.secondTintColor
//        self.plusButton.tintColor = Theme.current.primaryTextColor
//        self.menuButton.tintColor = Theme.current.primaryTextColor
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
