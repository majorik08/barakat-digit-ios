//
//  StoriesView.swift
//  BarakatWallet
//
//  Created by km1tj on 22/10/23.
//

import Foundation
import UIKit

protocol StoriesViewDelegate: AnyObject {
    func didTapStoriesItem(stories: [AppStructs.Stories], index: Int)
    func didScrolledBar(scrollView: UIScrollView)
}

class StoriesView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(StoriesCell.self, forCellWithReuseIdentifier: "cell")
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        //view.setContentCompressionResistancePriority(.required, for: .vertical)
        //view.setContentHuggingPriority(.required, for: .vertical)
        view.showsHorizontalScrollIndicator = false
        view.contentInset = .init(top: 0, left: Theme.current.mainPaddings - 5, bottom: 0, right: Theme.current.mainPaddings - 5)
        return view
    }()
    var stories: [AppStructs.Stories] = []
    weak var delegate: StoriesViewDelegate? = nil
    
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
        NSLayoutConstraint.activate([
            self.collectionView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.collectionView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func configure(stories: [AppStructs.Stories]) {
        self.stories = stories
        self.collectionView.reloadData()
    }
    
    func themeChanged(newTheme: Theme) {
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StoriesCell
        cell.configure(stories: self.stories[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.delegate?.didTapStoriesItem(stories: self.stories, index: indexPath.item)
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
        self.delegate?.didScrolledBar(scrollView: scrollView)
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

class StoriesCell: UICollectionViewCell {
    
    let rootView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        //view.layer.borderColor = UIColor.white.cgColor
        //view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 2
        view.layer.cornerRadius = 16
        view.layer.shadowOffset = CGSize(width: 0.1, height: 1)
        return view
    }()
    let mainImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.backgroundColor = Theme.current.secondTintColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
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
        NSLayoutConstraint.activate([
            self.rootView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 5),
            self.rootView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            self.rootView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5),
            self.rootView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -1),
            self.mainImage.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
            self.mainImage.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 0),
            self.mainImage.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
            self.mainImage.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(stories: AppStructs.Stories) {
        self.mainImage.loadImage(filePath: stories.mainImage)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.mainImage.image = nil
    }
}
