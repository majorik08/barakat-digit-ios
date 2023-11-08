//
//  PaymentsViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 05/10/23.
//

import Foundation
import UIKit

class PaymentsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
  
    enum Order {
    case firstPayments
    case firstTransfers
    }
    let searchController = UISearchController(searchResultsController: nil)
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        view.backgroundColor = .clear
        view.register(PaymentItemCell.self, forCellReuseIdentifier: "cell")
        view.separatorStyle = .none
        return view
    }()
    
    let order: Order
    let viewModel: PaymentsViewModel
    weak var coordinator: PaymentsCoordinator? = nil
    
    init(viewModel: PaymentsViewModel, order: Order = .firstPayments) {
        self.viewModel = viewModel
        self.order = order
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "PAYMENTS".localized
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
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl!.tintColor = Theme.current.tintColor
        self.tableView.refreshControl!.addTarget(self, action: #selector(reloadPaymentAndTransfers), for: .valueChanged)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.viewModel.didLoadPayments.subscribe { [weak self] _ in
            self?.tableView.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
        }.disposed(by: self.viewModel.disposeBag)
        self.viewModel.didLoadPaymentsError.subscribe(onNext: { [weak self] message in
            self?.tableView.refreshControl?.endRefreshing()
            self?.showErrorAlert(title: "ERROR".localized, message: message)
        }).disposed(by: self.viewModel.disposeBag)
        
        self.tableView.refreshControl?.beginRefreshing()
        self.viewModel.loadPayments()
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
    
    override func languageChanged() {
        super.languageChanged()
        self.navigationItem.title = "PAYMENTS".localized
        self.tableView.reloadData()
    }
    
    @objc private func reloadPaymentAndTransfers() {
        self.viewModel.loadPayments()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch self.order {
        case .firstPayments:
            if indexPath.section == 0 {
                let item = self.viewModel.paymentGroups[indexPath.row]
                self.coordinator?.navigateToServicesList(selectedGroup: item)
            } else if indexPath.section == 1 {
                let item = self.viewModel.transferTypes[indexPath.row]
                self.coordinator?.navigateToTransferView(transfer: item)
            }
        case .firstTransfers:
            if indexPath.section == 0 {
                let item = self.viewModel.transferTypes[indexPath.row]
                self.coordinator?.navigateToTransferView(transfer: item)
            } else if indexPath.section == 1 {
                let item = self.viewModel.paymentGroups[indexPath.row]
                self.coordinator?.navigateToServicesList(selectedGroup: item)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PaymentItemCell
        switch self.order {
        case .firstPayments:
            if indexPath.section == 0 {
                let item = self.viewModel.paymentGroups[indexPath.row]
                cell.configure(paymentGroup: item)
            } else if indexPath.section == 1 {
                let item = self.viewModel.transferTypes[indexPath.row]
                cell.configure(transferType: item)
            }
        case .firstTransfers:
            if indexPath.section == 0 {
                let item = self.viewModel.transferTypes[indexPath.row]
                cell.configure(transferType: item)
            } else if indexPath.section == 1 {
                let item = self.viewModel.paymentGroups[indexPath.row]
                cell.configure(paymentGroup: item)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.order {
        case .firstPayments:
            if section == 0 {
                return self.viewModel.paymentGroups.count
            } else if section == 1 {
                return self.viewModel.transferTypes.count
            }
        case .firstTransfers:
            if section == 0 {
                return self.viewModel.transferTypes.count
            } else if section == 1 {
                return self.viewModel.paymentGroups.count
            }
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch self.order {
        case .firstPayments:
            if section == 0 && self.viewModel.paymentGroups.count > 0 {
                return "PAY_SERVICES".localized
            } else if section == 1 && self.viewModel.transferTypes.count > 0 {
                return "PAY_SENDERS".localized
            }
        case .firstTransfers:
            if section == 0 && self.viewModel.transferTypes.count > 0 {
                return "PAY_SENDERS".localized
            } else if section == 1 && self.viewModel.paymentGroups.count > 0 {
                return "PAY_SERVICES".localized
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = Theme.current.plainTableCellColor
            headerView.backgroundView?.backgroundColor = .clear
            headerView.textLabel?.textColor = Theme.current.primaryTextColor
        }
    }
}
