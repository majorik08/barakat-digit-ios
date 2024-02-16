//
//  MainViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 05/10/23.
//

import Foundation
import UIKit

protocol HomeViewControllerItemDelegate: AnyObject {
    func goToAllTapped(cell: UICollectionViewCell)
    func reloadTapped(cell: UICollectionViewCell)
    func cardTapped(card: AppStructs.CreditDebitCard?)
    func serviceGroupTapped(group: AppStructs.PaymentGroup)
    func transferTapped(transfer: AppStructs.PaymentGroup.ServiceItem)
    func showcaseTapped(showcase: AppStructs.Showcase)
    func favouriteTapped(favouite: (AppStructs.Favourite, AppStructs.PaymentGroup.ServiceItem)?)
    func favouriteDelete(favouite: AppStructs.Favourite)
}

class HomeViewController: BaseViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HomeViewControllerItemDelegate, StoriesViewDelegate {
  
    let topBar: MainTopBarView = {
        return MainTopBarView()
    }()
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.keyboardDismissMode = .interactive
        view.register(MainCardListCell.self, forCellWithReuseIdentifier: "card_list_cell")
        view.register(MainServiceListCell.self, forCellWithReuseIdentifier: "service_list_cell")
        view.register(PayWithNumberCell.self, forCellWithReuseIdentifier: "number_cell")
        view.register(MainVitrinaListCell.self, forCellWithReuseIdentifier: "vitrina_list_cell")
        view.register(MainFavouriteListCell.self, forCellWithReuseIdentifier: "favourite_list_cell")
        view.register(MainRatesCell.self, forCellWithReuseIdentifier: "rates_cell")
        view.backgroundColor = .clear
        view.contentInset = .init(top: 20, left: 0, bottom: 20, right: 0)
        return view
    }()
    lazy var topViewMinHeight: CGFloat = {
        let topBar: CGFloat = 146
        return UIApplication.statusBarHeight + topBar
    }()
    lazy var topViewMaxHeight: CGFloat = {
        let width = (UIScreen.main.bounds.width - (2 * Theme.current.mainPaddings)) / 4
        let topBar: CGFloat = 146 + width
        return UIApplication.statusBarHeight + topBar
    }()
    private var heightAnchor: NSLayoutConstraint!
    
    let viewModel: HomeViewModel
    weak var coordinator: HomeCoordinator? = nil
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.topBar)
        self.heightAnchor = self.topBar.heightAnchor.constraint(equalToConstant: self.topViewMaxHeight)
        self.topBar.setup()
        NSLayoutConstraint.activate([
            self.topBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.topBar.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.topBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.heightAnchor,
            self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            self.collectionView.topAnchor.constraint(equalTo: self.topBar.bottomAnchor, constant: -10),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.contentInsetAdjustmentBehavior = .never
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.topBar.storiesView.delegate = self
        self.topBar.headerView.avatarView.isUserInteractionEnabled = true
        self.topBar.headerView.avatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.profileTapped)))
        self.topBar.headerView.menuView.addTarget(self, action: #selector(self.profileTapped), for: .touchUpInside)
        self.topBar.headerView.notifyView.addTarget(self, action: #selector(self.notifyTapped), for: .touchUpInside)
        self.topBar.headerView.searchView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.searchBarTapped)))
        self.topBar.accountInfoView.hideButton.addTarget(self, action: #selector(self.hideShowBalance), for: .touchUpInside)
        self.topBar.accountInfoView.plusButton.addTarget(self, action: #selector(self.plusButtonTapped), for: .touchUpInside)
        self.collectionView.refreshControl = UIRefreshControl()
        self.collectionView.refreshControl?.tintColor = Theme.current.tintColor
        self.collectionView.refreshControl!.addTarget(self, action: #selector(reloadMainView), for: .valueChanged)
        self.topBar.configure(viewModel: self.viewModel)
        
        self.viewModel.didLoadError.subscribe(onNext: { [weak self] message in
            self?.collectionView.refreshControl?.endRefreshing()
            self?.showErrorAlert(title: "ERROR".localized, message: message)
        }).disposed(by: self.viewModel.disposeBag)
        self.viewModel.didLoadServices.subscribe(onNext: { [weak self] _ in
            self?.viewModel.loadFavorites()
            self?.collectionView.reloadSections(IndexSet([2,3]))
        }).disposed(by: self.viewModel.disposeBag)
        self.viewModel.didLoadStories.subscribe { [weak self] _ in
            self?.topBar.storiesView.configure(stories: self?.viewModel.storiesList ?? [])
        }.disposed(by: self.viewModel.disposeBag)
        self.viewModel.didLoadShowcase.subscribe { [weak self] _ in
            self?.collectionView.reloadSections(IndexSet([4]))
        }.disposed(by: self.viewModel.disposeBag)
        
        
        self.viewModel.didLoadFavorites.subscribe { [weak self] _ in
            self?.collectionView.reloadSections(IndexSet([5]))
        }.disposed(by: self.viewModel.disposeBag)
        self.viewModel.didLoadCards.subscribe { [weak self] _ in
            self?.collectionView.reloadSections(IndexSet([0]))
        }.disposed(by: self.viewModel.disposeBag)
        self.viewModel.didLoadAccountInfo.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.collectionView.refreshControl?.endRefreshing()
            self.topBar.configure(viewModel: self.viewModel)
        }.disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.loadServices()
        self.viewModel.loadStoriesList()
        self.viewModel.loadCardList()
        self.viewModel.loadShowcaseList()
        self.viewModel.loadRates()
    }
    
    @objc func hideShowBalance() {
        Constants.HideBalanceInMain = !Constants.HideBalanceInMain
        self.topBar.configure(viewModel: self.viewModel)
    }
    
    @objc func plusButtonTapped() {
        
    }
    
    @objc func searchBarTapped() {
        self.coordinator?.navigateToSearchView(paymentGroups: self.viewModel.serviceGroups, transferTypes: self.viewModel.transfers)
    }
    
    @objc func reloadMainView() {
        self.viewModel.loadAccountInfo()
    }
    
    @objc func profileTapped() {
        self.coordinator?.navigateToProfile()
    }
    
    @objc func notifyTapped() {
        self.coordinator?.navigateToNotify()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.setStatusBarStyle(dark: false)
    }
    
    override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.collectionView.reloadData()
        self.topBar.themeChanged(newTheme: newTheme)
    }
    
    func didTapStoriesItem(stories: [AppStructs.Stories], index: Int) {
        self.coordinator?.presentStoriesPreView(stories: stories, handPickedStoryIndex: index)
    }
    
    func didScrolledBar(scrollView: UIScrollView) {}
    
    func goToAllTapped(cell: UICollectionViewCell) {
        guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
        if indexPath.section == 2 {
            self.coordinator?.navigateToPayments(fromTransfers: false, paymentGroups: self.viewModel.serviceGroups, transferTypes: self.viewModel.transfers, addFavoriteMode: false)
        } else if indexPath.section == 3 {
            self.coordinator?.navigateToPayments(fromTransfers: true, paymentGroups: self.viewModel.serviceGroups, transferTypes: self.viewModel.transfers, addFavoriteMode: false)
        } else if indexPath.section == 4 {
            self.coordinator?.navigateToShowcaseList()
        } else if indexPath.section == 5 {
            self.coordinator?.navigateToFavouriteList()
        } else if indexPath.section == 6 {
            self.coordinator?.navigateToRates(openConvertor: true)
        }
    }
    
    func reloadTapped(cell: UICollectionViewCell) {
        guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
        if indexPath.section == 2 {
            self.viewModel.loadServices()
        } else if indexPath.section == 3 {
            self.viewModel.loadServices()
        } else if indexPath.section == 4 {
            self.viewModel.loadShowcaseList()
        } else if indexPath.section == 5 {
            self.viewModel.loadFavorites()
        } else if indexPath.section == 6 {
            self.viewModel.loadRates()
        }
    }
    
    func serviceGroupTapped(group: AppStructs.PaymentGroup) {
        self.coordinator?.navigateToServicesList(selectedGroup: group)
    }
    
    func transferTapped(transfer: AppStructs.PaymentGroup.ServiceItem) {
        self.coordinator?.navigateToPaymentView(service: transfer, merchant: nil, transferParam: nil)
    }
    
    func showcaseTapped(showcase: AppStructs.Showcase) {
        self.coordinator?.navigateToShowcaseView(showcase: showcase)
    }
    
    func favouriteTapped(favouite: (AppStructs.Favourite, AppStructs.PaymentGroup.ServiceItem)?) {
        if let favouite {
            self.coordinator?.navigateToServiceByFavourite(favourite: favouite.0, service: favouite.1)
        } else {
            self.coordinator?.navigateToPayments(fromTransfers: false, paymentGroups:  self.viewModel.serviceGroups, transferTypes: self.viewModel.transfers, addFavoriteMode: true)
        }
    }
    
    func favouriteDelete(favouite: AppStructs.Favourite) {
        self.viewModel.deleteFavorite(id: favouite.id)
    }
    
    func cardTapped(card: AppStructs.CreditDebitCard?) {
        self.coordinator?.navigateToCardView(userCards: self.viewModel.cardList, selectedCard: card)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.section == 1 {
            self.coordinator?.navigateToTransferByNumberView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "card_list_cell", for: indexPath) as! MainCardListCell
            cell.delegate = self
            cell.configure(cards: self.viewModel.cardList)
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "number_cell", for: indexPath) as! PayWithNumberCell
            cell.delegate = self
            cell.configure()
            return cell
        } else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "service_list_cell", for: indexPath) as! MainServiceListCell
            cell.delegate = self
            cell.configure(services: self.viewModel.serviceGroups)
            return cell
        } else if indexPath.section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "service_list_cell", for: indexPath) as! MainServiceListCell
            cell.delegate = self
            cell.configure(transfers: self.viewModel.transfers)
            return cell
        } else if indexPath.section == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "vitrina_list_cell", for: indexPath) as! MainVitrinaListCell
            cell.delegate = self
            cell.configure(items: self.viewModel.showcaseList)
            return cell
        } else if indexPath.section == 5 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favourite_list_cell", for: indexPath) as! MainFavouriteListCell
            cell.delegate = self
            cell.configure(items: self.viewModel.favoritesList, viewModel: self.viewModel)
            return cell
        } else if indexPath.section == 6 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rates_cell", for: indexPath) as! MainRatesCell
            cell.delegate = self
            cell.configure(rates: self.viewModel.ratesList)
            return cell
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 1
        } else if section == 3 {
            return 1
        } else if section == 4 {
            return 1
        } else if section == 5 {
            return 1
        } else if section == 6 {
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = 2 * (Theme.current.mainPaddings - 5)
        if indexPath.section == 0 {
            // the size of credit cards is 85.60 × 53.98 mm ratio is 1.5858
            let itemWidth = (self.view.frame.width - insets) / 2.5
            let height = (itemWidth - 10) * 0.63
            return .init(width: collectionView.frame.width, height: height + 48)
        } else if indexPath.section == 1 {
            return .init(width: collectionView.frame.width, height: 80)
        } else if indexPath.section == 2 || indexPath.section == 3 {
            let itemWidth = ((self.view.frame.width - insets) / 4)
            let height = (itemWidth - 10) - 2
            return .init(width: collectionView.frame.width, height: height + 54)
        } else if indexPath.section == 4 {
            let itemWidth = ((self.view.frame.width - insets) / 2.6)
            let height = (itemWidth - 10) * 0.6
            return .init(width: collectionView.frame.width, height: height + 54)
        } else if indexPath.section == 5 {
            let itemWidth = ((self.view.frame.width - insets) / 4)
            let height = (itemWidth - 10) - 2
            return .init(width: collectionView.frame.width, height: height + 54)
        } else if indexPath.section == 6 {
            return .init(width: collectionView.frame.width, height: collectionView.frame.width * 0.4)
        }
        return .zero
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging || scrollView.isDecelerating {
            let yOffset = scrollView.contentOffset.y
            //print(yOffset)
            if yOffset > 0 {
                let now = self.topViewMaxHeight - yOffset
                let set = min(max(now, self.topViewMinHeight), self.topViewMaxHeight)
                if self.topViewMinHeight >= self.heightAnchor.constant && now < self.topViewMinHeight {
                    return
                }
                if self.heightAnchor.constant - set > 2 || set - self.heightAnchor.constant > 2 {
                    //print("setting: \(set) for \(self.heightAnchor.constant)")
                    self.heightAnchor.constant = set
                }
            } else {
                self.heightAnchor.constant = self.topViewMaxHeight
            }
//            if yOffset < -self.topViewMaxHeight {
//                if self.collectionView.contentInset.top < floor(self.topViewMaxHeight) {
//                    self.heightAnchor.constant = self.topViewMaxHeight
//                    //self.collectionView.contentInset.top = self.topViewMaxHeight
//                    //self.collectionView.scrollIndicatorInsets.top = self.topViewMaxHeight
//                }
//            } else if yOffset < -self.topViewMinHeight {
//                self.heightAnchor.constant = yOffset * -1
//                //self.collectionView.contentInset.top = yOffset * -1
//                //self.collectionView.scrollIndicatorInsets.top = yOffset * -1
//            } else {
//                self.heightAnchor.constant = self.topViewMinHeight
//                //self.collectionView.contentInset.top = self.topViewMinHeight
//                //self.collectionView.scrollIndicatorInsets.top = self.topViewMinHeight
//            }
        }
    }
}
