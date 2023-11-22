//
//  ChooseTransferView.swift
//  BarakatWallet
//
//  Created by km1tj on 22/11/23.
//

import Foundation
import UIKit

class ChooseTransferViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
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
        view.text = "ALL_TRANSFER_TYPES".localized
        view.numberOfLines = 0
        return view
    }()
    let searchBar: UISearchBar = {
        let view = UISearchBar(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "SEARCH".localized
        view.searchBarStyle = .minimal
        return view
    }()
    let scrollView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        view.backgroundColor = .clear
        view.register(PaymentItemCell.self, forCellReuseIdentifier: "cell")
        view.separatorStyle = .none
        return view
    }()
    enum ShowType {
    case payments
    case transfers
    }
    let showType: ShowType
    let viewModel: PaymentsViewModel
    var paymentCreditCard: AppStructs.CreditDebitCard?
    weak var coordinator: PaymentsCoordinator?
    
    init(type: ShowType, viewModel: PaymentsViewModel, paymentCreditCard: AppStructs.CreditDebitCard?) {
        self.showType = type
        self.paymentCreditCard = paymentCreditCard
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
        switch self.showType {
        case .payments:
            self.rootView.addSubview(self.searchBar)
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
                self.rootView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6),
                self.topAnchorView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 16),
                self.topAnchorView.centerXAnchor.constraint(equalTo: self.rootView.centerXAnchor),
                self.topAnchorView.heightAnchor.constraint(equalToConstant: 6),
                self.topAnchorView.widthAnchor.constraint(equalToConstant: 48),
                self.searchBar.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings - 10),
                self.searchBar.topAnchor.constraint(equalTo: self.topAnchorView.bottomAnchor, constant: 20),
                self.searchBar.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -(Theme.current.mainPaddings - 10)),
                self.scrollView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 0),
                self.scrollView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
                self.scrollView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
                self.scrollView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -(self.view.safeAreaInsets.bottom + 30)),
            ])
        case .transfers:
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
                self.rootView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6),
                self.topAnchorView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 16),
                self.topAnchorView.centerXAnchor.constraint(equalTo: self.rootView.centerXAnchor),
                self.topAnchorView.heightAnchor.constraint(equalToConstant: 6),
                self.topAnchorView.widthAnchor.constraint(equalToConstant: 48),
                self.titleView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
                self.titleView.topAnchor.constraint(equalTo: self.topAnchorView.bottomAnchor, constant: 20),
                self.titleView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
                self.scrollView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 20),
                self.scrollView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
                self.scrollView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
                self.scrollView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -(self.view.safeAreaInsets.bottom + 30)),
            ])
        }
        self.bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismisIfCan)))
        self.scrollView.dataSource = self
        self.scrollView.delegate = self
        self.viewModel.didLoadPayments.subscribe { [weak self] _ in
            self?.scrollView.refreshControl?.endRefreshing()
            self?.scrollView.reloadData()
        }.disposed(by: self.viewModel.disposeBag)
        self.viewModel.didLoadPaymentsError.subscribe(onNext: { [weak self] message in
            self?.scrollView.refreshControl?.endRefreshing()
            self?.showErrorAlert(title: "ERROR".localized, message: message)
        }).disposed(by: self.viewModel.disposeBag)
        self.viewModel.loadPayments()
        self.rootView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
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
        switch self.showType {
        case .payments:
            let item = self.viewModel.paymentGroups[indexPath.row]
            self.dismisIfCan()
            self.coordinator?.navigateToServicesList(selectedGroup: item)
        case .transfers:
            let item = self.viewModel.transferTypes[indexPath.row]
            self.dismisIfCan()
            self.coordinator?.navigateToTransferView(transfer: item)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PaymentItemCell
        switch self.showType {
        case .payments:
            let item = self.viewModel.paymentGroups[indexPath.row]
            cell.configure(paymentGroup: item)
        case .transfers:
            let item = self.viewModel.transferTypes[indexPath.row]
            cell.configure(transferType: item)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.showType {
        case .payments:
            return self.viewModel.paymentGroups.count
        case .transfers:
            return self.viewModel.transferTypes.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}
