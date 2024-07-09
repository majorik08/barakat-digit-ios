//
//  CardReleaseViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 18/11/23.
//

import Foundation
import UIKit

class CardReleaseViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CardReleaseTypeCellDelegate {
   
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.keyboardDismissMode = .interactive
        view.register(CardReleaseTypeCell.self, forCellWithReuseIdentifier: "card_types_cell")
        view.register(CardReleaseItemCell.self, forCellWithReuseIdentifier: "card_item_cell")
        view.backgroundColor = .clear
        view.contentInset = .init(top: 0, left: Theme.current.mainPaddings, bottom: 10, right: Theme.current.mainPaddings)
        return view
    }()
    weak var coordinator: CardsCoordinator? = nil
    let viewModel: CardsViewModel
    var categoryId: Int?
    
    init(viewModel: CardsViewModel, categoryId: Int?) {
        self.viewModel = viewModel
        self.categoryId = categoryId
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "BANK_CARDS".localized
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.collectionView)
        NSLayoutConstraint.activate([
            self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.contentInsetAdjustmentBehavior = .never
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.viewModel.didLoadError.subscribe(onNext: { [weak self] error in
            self?.hideProgressView()
            self?.showApiError(title: "ERROR".localized, error: error)
        }).disposed(by: self.viewModel.disposeBag)
        self.viewModel.didLoadCategories.subscribe { [weak self] _ in
            self?.collectionView.reloadData()
            if let first = self?.viewModel.availableCardCategories.first {
                let id = self?.categoryId ?? first.id
                self?.categoryId = id
                self?.viewModel.loadCardTypes(categoryId: id)
            } else {
                self?.hideProgressView()
            }
        }.disposed(by: self.viewModel.disposeBag)
        self.viewModel.didLoadCardTypes.subscribe { [weak self] _ in
            self?.hideProgressView()
            self?.collectionView.reloadData()
        }.disposed(by: self.viewModel.disposeBag)
        self.showProgressView()
        self.viewModel.loadCardCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: nil)
    }
    
    override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.collectionView.reloadData()
    }
    
    func didSelectCardType(item: AppStructs.CreditDebitCardCategory) {
        self.categoryId = item.id
        self.showProgressView()
        self.viewModel.loadCardTypes(categoryId: item.id)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let item = self.viewModel.availableCardItems[indexPath.item]
            self.coordinator?.navigateToReleaseCardItem(cardItem: item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "card_types_cell", for: indexPath) as! CardReleaseTypeCell
            cell.categoryId = self.categoryId
            cell.delegate = self
            cell.configure(items: self.viewModel.availableCardCategories)
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "card_item_cell", for: indexPath) as! CardReleaseItemCell
            let item = self.viewModel.availableCardItems[indexPath.item]
            cell.configure(item: item)
            return cell
        }
        return UICollectionViewCell(frame: .zero)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return self.viewModel.availableCardItems.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let topBottomPadding: CGFloat = 20
            let height: CGFloat = 36
            return .init(width: collectionView.frame.width, height: height + topBottomPadding)
        } else if indexPath.section == 1 {
            return .init(width: collectionView.frame.width, height: 104)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1 {
            return .init(top: 10, left: 0, bottom: 0, right: 0)
        }
        return .zero
    }
}
