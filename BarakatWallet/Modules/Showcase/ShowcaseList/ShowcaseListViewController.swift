//
//  ShowcaseListViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 08/11/23.
//

import Foundation
import UIKit

class ShowcaseListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, ShowCaseFilterViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {
   
    let searchController = UISearchController(searchResultsController: nil)
    let filterView: ShowCaseFilterView = {
        return ShowCaseFilterView(frame: .zero)
    }()
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        view.backgroundColor = .clear
        view.register(ShowcaseListCell.self, forCellReuseIdentifier: "cell")
        view.separatorStyle = .singleLine
        return view
    }()
    
    let viewModel: ShowcaseViewModel
    weak var coordinator: HomeCoordinator? = nil
    
    init(viewModel: ShowcaseViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "SHOWCASE".localized
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(name: .search), style: .plain, target: self, action: #selector(self.showSearchView))
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.barStyle = Theme.current.dark ? .black : .default
        self.searchController.searchBar.barTintColor = Theme.current.searchBarTint
        self.searchController.searchBar.placeholder = "SEARCH".localized
        self.searchController.hidesNavigationBarDuringPresentation = true
        self.view.addSubview(self.filterView)
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.filterView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.filterView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.filterView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.filterView.heightAnchor.constraint(equalToConstant: 34),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.filterView.bottomAnchor, constant: 10),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0
        }
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl!.tintColor = Theme.current.tintColor
        self.tableView.refreshControl!.addTarget(self, action: #selector(reloadShowcases), for: .valueChanged)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.filterView.delegate = self
        self.filterView.configure(items: [.city(name: nil), .category(name: nil), .sort(type: nil)])
        self.viewModel.didShowcaseUpdate.subscribe { [weak self] _ in
            self?.tableView.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
        }.disposed(by: self.viewModel.disposeBag)
        self.viewModel.loadShowcaseList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: nil)
    }
    
    @objc func showSearchView() {
        self.navigationItem.searchController = self.searchController
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.searchController.isActive = true
            self.searchController.searchBar.isHidden = false
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchController.isActive = false
        self.searchController.searchBar.resignFirstResponder()
        self.navigationItem.searchController = nil
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    @objc func reloadShowcases() {
        self.viewModel.loadShowcaseList()
    }
    
    func didSelectFilter(item: ShowcaseFilter) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.viewModel.showcaseList[indexPath.row]
        self.coordinator?.navigateToShowcaseView(showcase: item)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ShowcaseListCell
        let item = self.viewModel.showcaseList[indexPath.row]
        cell.configure(showcase: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.showcaseList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
