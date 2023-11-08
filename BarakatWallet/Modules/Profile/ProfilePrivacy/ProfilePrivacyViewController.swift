//
//  ProfilePrivacyViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 30/10/23.
//

import Foundation
import UIKit

class ProfilePrivacyViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
  
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInset = .init(top: 20, left: 0, bottom: 0, right: 0)
        view.backgroundColor = .clear
        view.separatorStyle = .none
        return view
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "PRIVACY_DOCS".localized
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.backgroundView = UIView(backgroundColor: .clear)
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = Theme.current.primaryTextColor
        cell.textLabel?.font = UIFont.regular(size: 16)
        cell.textLabel?.numberOfLines = 0
        cell.imageView?.image = UIImage(name: .doc)
        cell.imageView?.tintColor = Theme.current.tintColor
        cell.imageView?.contentMode = .scaleAspectFit
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Публичная оферта"
        case 1:
            cell.textLabel?.text = "Политика конфиденциальности"
        case 2:
            cell.textLabel?.text = "Barakat mobile лицензионное соглашение"
        case 3:
            cell.textLabel?.text = "Соглашение об осуществлении переводов дедежных средств без открытия счета"
        case 4:
            cell.textLabel?.text = "Публичная оферта"
        default:break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}
