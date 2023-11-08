//
//  ServiceList.swift
//  BarakatWallet
//
//  Created by km1tj on 08/11/23.
//

import Foundation
import UIKit

class ServiceListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {

    let searchController = UISearchController(searchResultsController: nil)
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        view.backgroundColor = .clear
        view.register(PaymentServiceCell.self, forCellReuseIdentifier: "cell")
        view.separatorStyle = .none
        return view
    }()
    let viewModel: PaymentsViewModel
    let selectedGroup: AppStructs.PaymentGroup
    weak var coordinator: PaymentsCoordinator? = nil
    
    init(viewModel: PaymentsViewModel, selectedGroup: AppStructs.PaymentGroup) {
        self.viewModel = viewModel
        self.selectedGroup = selectedGroup
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.selectedGroup.name
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0
        }
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.barStyle = Theme.current.dark ? .black : .default
        self.searchController.searchBar.barTintColor = Theme.current.searchBarTint
        self.searchController.searchBar.placeholder = "SEARCH".localized
        self.searchController.hidesNavigationBarDuringPresentation = true
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: nil)
    }
    
    override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let service = self.selectedGroup.services[indexPath.row]
        self.coordinator?.navigateToPaymentView(service: service)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PaymentServiceCell
        cell.configure(service: self.selectedGroup.services[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedGroup.services.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}
