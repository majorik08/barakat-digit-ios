//
//  KeyPadView.swift
//  BarakatWallet
//
//  Created by km1tj on 22/10/23.
//

import Foundation
import UIKit

public protocol KeyPadViewDelegate: NSObjectProtocol {
    func keyTapped(digit: String)
}

class KeyPadView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "0", "<"]
    let collection: UICollectionView = {
        let lay = UICollectionViewFlowLayout()
        lay.minimumLineSpacing = 0.1
        lay.sectionInset = .zero
        lay.minimumInteritemSpacing = 0
        lay.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: lay)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(CurrencyCell.self, forCellWithReuseIdentifier: "cellId")
        view.backgroundColor = .clear
        return view
    }()
    weak var delegate: KeyPadViewDelegate?
    
    var starButtonText: String? = nil
    var hashButtonImage: UIImage? = nil
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.collection)
        NSLayoutConstraint.activate([
            self.collection.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.collection.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.collection.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.collection.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
        self.collection.delegate = self
        self.collection.dataSource = self
        self.collection.contentInset = .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let number = self.numbers[indexPath.item]
        self.delegate?.keyTapped(digit: number)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numbers.count
    }
    
    func updateHashButtonImage(image: UIImage?) {
        self.hashButtonImage = image
        guard let index = self.numbers.firstIndex(of: "<") else { return }
        guard let cell = self.collection.cellForItem(at: IndexPath.init(item: index, section: 0)) as? CurrencyCell else { return }
        if let image {
            cell.iconView.image = image
        } else {
            cell.iconView.image = UIImage(name: .delete)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CurrencyCell
        let number = self.numbers[indexPath.item]
        cell.root.backgroundColor = .clear//Theme.current.keyPadBackColor
        if number == "<" {
            if let hashButtonImage {
                cell.digitLabel.text = nil
                cell.iconView.image = hashButtonImage
            } else {
                cell.digitLabel.text = nil
                cell.iconView.image = UIImage(name: .delete)
            }
        } else if number == "." {
            if let starButtonText {
                cell.digitLabel.font = UIFont.bold(size: 12)
                cell.digitLabel.text = starButtonText
                cell.iconView.image = nil
            } else {
                cell.digitLabel.text = nil
                cell.iconView.image = nil
            }
        } else {
            cell.digitLabel.font = UIFont.bold(size: 24)
            cell.digitLabel.text = number
            cell.iconView.image = nil
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let ipad = (UI_USER_INTERFACE_IDIOM() == .pad || UIScreen.main.bounds.width >= 736)
//        let width: CGFloat
//        if ipad {
//            width = 390
//        } else {
//            width = UIScreen.main.bounds.width - 32
//        }
//        let height = width * 0.7
//        let itemWidth = width / 3
//        let itemHeight = (height / 4) - 6
//        return .init(width: itemWidth, height: itemHeight)
        let width = self.frame.width
        let height = self.frame.height
        guard width > 0 && height > 0 else {
            return .init(width: 1, height: 1)
        }
        let sizeWidth = (width - 4) / 3
        let sizeHeight = (height - 6) / 4
        return .init(width: sizeWidth, height: sizeHeight)
    }
}

class CurrencyCell: UICollectionViewCell {
    
    let digitLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.textAlignment = .center
        view.font = UIFont.bold(size: 24)
        view.adjustsFontSizeToFitWidth = true
        view.contentScaleFactor = 0.4
        view.numberOfLines = 0
        return view
    }()
    let iconView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = Theme.current.primaryTextColor
        view.contentMode = .scaleAspectFit
        return view
    }()
    let root: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        return view
    }()
    
    override var isHighlighted: Bool {
        didSet {
            self.root.alpha = isHighlighted ? 0.5 : 1
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.root)
        self.root.addSubview(self.digitLabel)
        self.root.addSubview(self.iconView)
        NSLayoutConstraint.activate([
            self.root.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 4),
            self.root.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            self.root.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -4),
            self.root.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4),
            
            self.digitLabel.leftAnchor.constraint(equalTo: self.root.leftAnchor, constant: 0),
            self.digitLabel.topAnchor.constraint(equalTo: self.root.topAnchor, constant: 0),
            self.digitLabel.rightAnchor.constraint(equalTo: self.root.rightAnchor, constant: 0),
            self.digitLabel.bottomAnchor.constraint(equalTo: self.root.bottomAnchor, constant: 0),
            
            self.iconView.centerYAnchor.constraint(equalTo: self.root.centerYAnchor),
            self.iconView.centerXAnchor.constraint(equalTo: self.root.centerXAnchor),
            self.iconView.heightAnchor.constraint(equalTo: self.root.heightAnchor, multiplier: 0.5),
            self.iconView.widthAnchor.constraint(equalTo: self.iconView.heightAnchor, multiplier: 1),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
