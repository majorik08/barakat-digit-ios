//
//  ProfilePrivacyViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 30/10/23.
//

import Foundation
import UIKit
import RxSwift

class ProfilePrivacyViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
  
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInset = .init(top: 20, left: 0, bottom: 0, right: 0)
        view.backgroundColor = .clear
        view.separatorStyle = .none
        return view
    }()
    let viewModel: ProfileViewModel
    var docs: [AppMethods.App.GetDocs.GetDocsResult.Document] = []
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
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
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl!.tintColor = Theme.current.tintColor
        self.tableView.refreshControl!.addTarget(self, action: #selector(loadDocs), for: .valueChanged)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadDocs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: nil)
    }
    
    @objc func loadDocs() {
        self.showProgressView()
        self.viewModel.profileService.getDocs()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] item in
                guard let self = self else { return }
                self.hideProgressView()
                self.docs = item.documents
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            } onFailure: { [weak self] error in
                guard let self = self else { return }
                self.tableView.refreshControl?.endRefreshing()
                self.hideProgressView()
                self.showApiError(title: "ERROR".localized, error: error)
            }.disposed(by: self.viewModel.disposeBag)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.docs.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let doc = self.docs[indexPath.row]
        guard let url = URL(string: "\(Constants.ApiUrl)\(doc.fileAddress)") else { return }
        UIApplication.shared.open(url)
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
        let doc = self.docs[indexPath.row]
        cell.textLabel?.text = doc.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}
