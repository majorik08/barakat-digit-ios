//
//  GroupListViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 19/02/24.
//

import Foundation
import UIKit

class GroupListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
  
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        view.backgroundColor = .clear
        view.register(PaymentItemCell.self, forCellReuseIdentifier: "cell")
        view.separatorStyle = .none
        return view
    }()
    let selectedGroup: AppStructs.PaymentGroup
    let addFavoriteMode: Bool
    let viewModel: PaymentsViewModel
    weak var coordinator: PaymentsCoordinator? = nil
    
    init(viewModel: PaymentsViewModel, selectedGroup: AppStructs.PaymentGroup, addFavoriteMode: Bool) {
        self.viewModel = viewModel
        self.selectedGroup = selectedGroup
        self.addFavoriteMode = addFavoriteMode
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
        self.navigationItem.largeTitleDisplayMode = .never
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
    
    override func languageChanged() {
        super.languageChanged()
        self.tableView.reloadData()
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.selectedGroup.childGroups[indexPath.row]
        self.coordinator?.navigateToServicesList(selectedGroup: item, addFavoriteMode: self.addFavoriteMode)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PaymentItemCell
        let item = self.selectedGroup.childGroups[indexPath.row]
        cell.configure(paymentGroup: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedGroup.childGroups.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
}
