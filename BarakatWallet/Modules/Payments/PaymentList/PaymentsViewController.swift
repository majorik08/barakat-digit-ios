//
//  PaymentsViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 05/10/23.
//

import Foundation
import UIKit

protocol PaymentSearchItem {}
extension AppStructs.PaymentGroup.ServiceItem: PaymentSearchItem {}

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
        view.register(PaymentServiceCell.self, forCellReuseIdentifier: "service_cell")
        view.separatorStyle = .none
        return view
    }()
    let addFavoriteMode: Bool
    var searchMode: Bool
    let order: Order
    let viewModel: PaymentsViewModel
    weak var coordinator: PaymentsCoordinator? = nil
    var searchItems: [PaymentSearchItem] = []
    
    init(viewModel: PaymentsViewModel, order: Order = .firstPayments, addFavoriteMode: Bool, searchMode: Bool) {
        self.viewModel = viewModel
        self.order = order
        self.searchMode = searchMode
        self.addFavoriteMode = addFavoriteMode
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
        self.viewModel.didLoadPaymentsError.subscribe(onNext: { [weak self] error in
            self?.tableView.refreshControl?.endRefreshing()
            self?.showApiError(title: "ERROR".localized, error: error)
        }).disposed(by: self.viewModel.disposeBag)
        
        if self.viewModel.paymentGroups.isEmpty {
            self.tableView.refreshControl?.beginRefreshing()
            self.viewModel.loadPayments()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: nil)
        if self.searchMode {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.searchController.isActive = true
                self.searchController.searchBar.isHidden = false
                self.searchController.becomeFirstResponder()
                if #available(iOS 13.0, *) {
                    self.searchController.searchBar.searchTextField.becomeFirstResponder()
                } else {
                    self.searchController.searchBar.becomeFirstResponder()
                }
            }
        }
    }
    
    override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.tableView.reloadData()
    }
    
    override func languageChanged() {
        super.languageChanged()
        self.navigationItem.title = "PAYMENTS".localized
        self.searchController.searchBar.placeholder = "SEARCH".localized
        self.viewModel.loadPayments()
    }
    
    @objc private func reloadPaymentAndTransfers() {
        self.viewModel.loadPayments()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text?.lowercased(), text.count > 0 {
            self.searchMode = true
            self.searchItems.removeAll()
            let services = self.viewModel.paymentGroups.compactMap({ group in
                let services = group.services.filter { service in
                    let lower = service.name.lowercased()
                    if lower == text || lower.contains(text) {
                        return true
                    }
                    return false
                }
                return services
            }).flatMap({ $0 })
            self.searchItems.append(contentsOf: services)
            let transfers = self.viewModel.transferTypes.filter { transfer in
                let lower = transfer.name.lowercased()
                if lower == text || lower.contains(text) {
                    return true
                }
                return false
            }
            self.searchItems.append(contentsOf: transfers)
            self.tableView.reloadData()
        } else {
            self.searchItems.removeAll()
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchMode = false
        self.searchItems.removeAll()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.searchMode {
            let item = self.searchItems[indexPath.row]
            if let service = item as? AppStructs.PaymentGroup.ServiceItem {
                self.coordinator?.navigateToPaymentView(service: service, merchant: nil, favorite: nil, addFavoriteMode: self.addFavoriteMode, transferParam: nil)
            }
        } else {
            switch self.order {
            case .firstPayments:
                if indexPath.section == 0 {
                    let item = self.viewModel.paymentGroups[indexPath.row]
                    self.coordinator?.navigateToServicesList(selectedGroup: item, addFavoriteMode: self.addFavoriteMode)
                } else if indexPath.section == 1 {
                    let item = self.viewModel.transferTypes[indexPath.row]
                    self.coordinator?.navigateToPaymentView(service: item, merchant: nil, favorite: nil, addFavoriteMode: self.addFavoriteMode, transferParam: nil)
                }
            case .firstTransfers:
                if indexPath.section == 0 {
                    let item = self.viewModel.transferTypes[indexPath.row]
                    self.coordinator?.navigateToPaymentView(service: item, merchant: nil, favorite: nil, addFavoriteMode: self.addFavoriteMode, transferParam: nil)
                } else if indexPath.section == 1 {
                    let item = self.viewModel.paymentGroups[indexPath.row]
                    self.coordinator?.navigateToServicesList(selectedGroup: item, addFavoriteMode: self.addFavoriteMode)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.searchMode {
            let cell = tableView.dequeueReusableCell(withIdentifier: "service_cell", for: indexPath) as! PaymentServiceCell
            let item = self.searchItems[indexPath.row]
            cell.configure(item: item)
            return cell
        } else {
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchMode {
            return self.searchItems.count
        } else {
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
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.searchMode {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.searchMode {
            return 66
        }
        return 52
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !self.searchMode {
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
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = Theme.current.plainTableCellColor
            headerView.backgroundView?.backgroundColor = .clear
            headerView.textLabel?.textColor = Theme.current.primaryTextColor
            headerView.textLabel?.font = UIFont.medium(size: 16)
            headerView.textLabel?.sizeToFit()
        }
    }
}
