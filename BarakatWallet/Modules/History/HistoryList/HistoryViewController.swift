//
//  HistoryViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 05/10/23.
//

import Foundation
import UIKit

class HistoryViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        view.backgroundColor = .clear
        view.register(HistoryItemCell.self, forCellReuseIdentifier: "cell")
        view.separatorStyle = .none
        return view
    }()
    
    let viewModel: HistoryViewModel
    weak var coordinator: HistoryCoordinator? = nil
    
    init(viewModel: HistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "HISTORY".localized
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
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl!.tintColor = Theme.current.tintColor
        self.tableView.refreshControl!.addTarget(self, action: #selector(reloadHistory), for: .valueChanged)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.viewModel.didHistoryUpdate.subscribe { [weak self] _ in
            self?.tableView.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
        }.disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.getHistory()
    }
    
    @objc func reloadHistory() {
        self.viewModel.getHistory()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.viewModel.historySections[indexPath.section].items[indexPath.row]
        self.viewModel.selectedHistory = item
        self.coordinator?.navigateToHistoryDetails(item: item)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HistoryItemCell
        let item = self.viewModel.historySections[indexPath.section].items[indexPath.row]
        cell.configure(history: item)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.historySections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.historySections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = Theme.current.plainTableCellColor
            headerView.backgroundView?.backgroundColor = .clear
            headerView.textLabel?.textColor = Theme.current.primaryTextColor
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = self.viewModel.historySections[section].date
        return "  \(DateUtils.stringDateWithWeekName(date: date))"
    }
}
