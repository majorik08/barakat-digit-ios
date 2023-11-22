//
//  CardsViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 05/10/23.
//

import Foundation
import UIKit

class CardsViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CardTypesCellDelegate {
  
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.keyboardDismissMode = .interactive
        view.register(CardTypesCell.self, forCellWithReuseIdentifier: "card_types_cell")
        view.register(CardItemCell.self, forCellWithReuseIdentifier: "card_item_cell")
        view.register(CardActionCell.self, forCellWithReuseIdentifier: "card_action_cell")
        view.backgroundColor = .clear
        view.contentInset = .init(top: 0, left: 0, bottom: 10, right: 0)
        return view
    }()
    weak var coordinator: CardsCoordinator? = nil
    let viewModel: CardsViewModel
    
    init(viewModel: CardsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "MY_CARDS".localized
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.collectionView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(name: .hide_eyes), style: .plain, target: self, action: #selector(self.showHideCardTapped))
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
    }
    
    override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.collectionView.reloadData()
    }
    
    @objc func showHideCardTapped() {
        self.viewModel.showCardInfo = !self.viewModel.showCardInfo
        self.collectionView.reloadData()
    }
    
    func cardTypeTapped(item: AppStructs.CreditDebitCardTypes) {
        self.coordinator?.navigateToReleaseCardView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.section == 1 {
            let card = self.viewModel.userCards[indexPath.item]
            self.coordinator?.navigateToCardView(userCards: self.viewModel.userCards, selectedCard: card)
        } else if indexPath.section == 2 {
            if indexPath.item == 0 {
                self.coordinator?.navigateToAddCardView()
            } else if indexPath.item == 1 {
                self.coordinator?.navigateToReleaseCardView()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "card_types_cell", for: indexPath) as! CardTypesCell
            cell.delegate = self
            cell.configure(items: self.viewModel.availableCardTypes)
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "card_item_cell", for: indexPath) as! CardItemCell
            let card = self.viewModel.userCards[indexPath.item]
            cell.configure(card: card, show: self.viewModel.showCardInfo)
            return cell
        } else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "card_action_cell", for: indexPath) as! CardActionCell
            if indexPath.item == 0 {
                cell.configure(title: "ADD_CARD".localized)
            } else {
                cell.configure(title: "ORDER_CARD".localized)
            }
            return cell
        }
        return UICollectionViewCell(frame: .zero)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return self.viewModel.userCards.count
        } else if section == 2 {
            return 2
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //  the size of credit cards is 85.60 × 53.98 mm ratio is 1.5858
        if indexPath.section == 0 {
            let topBottomPadding: CGFloat = 20
            let aspect: CGFloat = 2.36
            let spacing: Int = Int(10 * aspect)
            let width = (collectionView.frame.width - Theme.current.mainPaddings - CGFloat(spacing)) / aspect
            let height = width / 1.78
            return .init(width: collectionView.frame.width, height: height + topBottomPadding)
        } else if indexPath.section == 1 {
            let width = collectionView.frame.width - (Theme.current.mainPaddings * 2)
            let height = width / 1.68
            return .init(width: collectionView.frame.width, height: height + 20)
        } else if indexPath.section == 2 {
            let width = (collectionView.frame.width - Theme.current.mainPaddings) / 2
            let height = width / 1.88
            return .init(width: width, height: height)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 2 {
            return .init(top: 0, left: 8, bottom: 0, right: 8)
        }
        return .zero
    }
}
