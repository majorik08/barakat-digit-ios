//
//  HistoryFilterPickView.swift
//  BarakatWallet
//
//  Created by km1tj on 23/11/23.
//

import Foundation
import UIKit

protocol HistoryFilterPickViewControllerDelegate: AnyObject {
    func historyFilterPicked(filter: HistoryFilter)
}

class HistoryFilterPickViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let bgView: GradientView = {
        let view = GradientView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startColor = Theme.current.mainGradientStartColor
        view.endColor = Theme.current.mainGradientEndColor
        view.alpha = 0.5
        view.isUserInteractionEnabled = true
        return view
    }()
    let rootView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.plainTableBackColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        return view
    }()
    let topAnchorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red:0.73, green:0.74, blue:0.75, alpha:1.0)
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
        return view
    }()
    let titleView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.medium(size: 17)
        view.numberOfLines = 0
        return view
    }()
    let scrollView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        view.backgroundColor = .clear
        view.register(HistoryFilterSelectCell.self, forCellReuseIdentifier: "cell")
        view.separatorStyle = .none
        return view
    }()
    var filter: HistoryFilter
    let viewModel: HistoryViewModel
    weak var coordinator: HistoryCoordinator?
    weak var delegate: HistoryFilterPickViewControllerDelegate?
    
    init(filter: HistoryFilter, viewModel: HistoryViewModel) {
        self.filter = filter
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
        self.modalPresentationCapturesStatusBarAppearance = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.view.addSubview(self.bgView)
        self.view.addSubview(self.rootView)
        self.rootView.addSubview(self.topAnchorView)
        self.rootView.addSubview(self.titleView)
        self.rootView.addSubview(self.scrollView)
        NSLayoutConstraint.activate([
            self.bgView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.bgView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.bgView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.bgView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.rootView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.rootView.topAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.rootView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.rootView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.rootView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4),
            self.topAnchorView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 16),
            self.topAnchorView.centerXAnchor.constraint(equalTo: self.rootView.centerXAnchor),
            self.topAnchorView.heightAnchor.constraint(equalToConstant: 6),
            self.topAnchorView.widthAnchor.constraint(equalToConstant: 48),
            self.titleView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.titleView.topAnchor.constraint(equalTo: self.topAnchorView.bottomAnchor, constant: 20),
            self.titleView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.scrollView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 0),
            self.scrollView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.scrollView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.scrollView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -(self.view.safeAreaInsets.bottom + 30)),
        ])
        self.bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismisIfCan)))
        self.scrollView.dataSource = self
        self.scrollView.delegate = self
        self.scrollView.refreshControl = UIRefreshControl()
        self.scrollView.refreshControl!.tintColor = Theme.current.tintColor
        self.scrollView.refreshControl!.addTarget(self, action: #selector(reloadEntries), for: .valueChanged)
        self.rootView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        self.viewModel.didLoadEntries.subscribe { [weak self] _ in
            self?.scrollView.refreshControl?.endRefreshing()
            self?.scrollView.reloadData()
        }.disposed(by: self.viewModel.disposeBag)
        self.reloadEntries()
    }
    
    @objc func reloadEntries() {
        switch self.filter {
        case .operation(_):
            self.viewModel.loadEntries()
        default:
            self.scrollView.refreshControl?.endRefreshing()
        }
    }
    
    override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
        self.scrollView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            return .default
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.animateView()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    func animateView() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.rootView.transform = .identity
        }, completion: {(finished: Bool) -> Void in })
    }
    
    func animateDismis() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {() -> Void in
            self.rootView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        }, completion: {(finished: Bool) -> Void in
            self.dismiss(animated: true)
        })
    }
    
    @objc func dismisIfCan() {
        self.animateDismis()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch self.filter {
        case .income(_):return
        case .expenses(_):return
        case .sum(_, _):return
        case .period(_, _):return
        case .operation(_):
            let filter = self.viewModel.entries[indexPath.row]
            self.delegate?.historyFilterPicked(filter: .operation(type: filter))
            self.dismisIfCan()
        case .payedBy(_, _):
            let account = self.viewModel.accountInfo.clientBalances[indexPath.row]
            switch account {
            case .wallet(account: let account):
                self.delegate?.historyFilterPicked(filter: .payedBy(account: account, card: nil))
            case .card(card: let card):
                self.delegate?.historyFilterPicked(filter: .payedBy(account: nil, card: card))
            }
            self.dismisIfCan()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HistoryFilterSelectCell
        cell.configure()
        switch self.filter {
        case .income(_):return cell
        case .expenses(_):return cell
        case .sum(_, _):return cell
        case .period(_, _):return cell
        case .operation(let type):
            let filter = self.viewModel.entries[indexPath.row]
            cell.titleView.text = filter.name
            if type?.id == filter.id || (type == nil && filter.id == -1) {
                cell.iconView.image = UIImage(name: .checkmark)
            } else {
                cell.iconView.image = nil
            }
            return cell
        case .payedBy(_, _):
            let account = self.viewModel.accountInfo.clientBalances[indexPath.row]
            cell.titleView.text = account.name
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.filter {
        case .income(_):return 0
        case .expenses(_):return 0
        case .sum(_, _):return 0
        case .period(_, _):return 0
        case .operation(_):return self.viewModel.entries.count
        case .payedBy(_, _):return self.viewModel.accountInfo.clientBalances.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }
}
