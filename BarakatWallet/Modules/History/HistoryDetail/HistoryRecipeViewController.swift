//
//  HistoryRecipeViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 05/12/23.
//

import Foundation
import UIKit
import RxSwift

class HistoryRecipeViewController: BaseViewController {
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alwaysBounceVertical = true
        view.keyboardDismissMode = .interactive
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        return view
    }()
    private let rootView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let shareButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.radius = 14
        view.setTitle("SEND".localized, for: .normal)
        view.isEnabled = true
        view.setImage(UIImage(name: .profile_share), for: .normal)
        view.imageView?.tintColor = .white
        return view
    }()
    private let checkView: UIView = {
        let view = UIView(backgroundColor: .clear)
        view.backgroundColor = Theme.current.plainTableBackColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let stackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let stampView: StampView = {
        let view = StampView(frame: .zero)
        view.backgroundColor = Theme.current.plainTableCellColor
        return view
    }()
    
    let viewModel: HistoryViewModel
    var item: AppStructs.HistoryItem
    weak var coordinator: HistoryCoordinator? = nil
     
    init(viewModel: HistoryViewModel, item: AppStructs.HistoryItem) {
        self.viewModel = viewModel
        self.item = item
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "SHOW_CHECK".localized
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.rootView)
        self.rootView.addSubview(self.checkView)
        self.rootView.addSubview(self.shareButton)
        self.checkView.addSubview(self.stackView)
        self.checkView.addSubview(self.stampView)
        let rootHeight = self.rootView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        rootHeight.priority = UILayoutPriority(rawValue: 250)
        NSLayoutConstraint.activate([
            self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.rootView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.rootView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.rootView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            self.rootView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            rootView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            rootHeight,
            self.checkView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor),
            self.checkView.topAnchor.constraint(equalTo: self.rootView.topAnchor),
            self.checkView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor),
            self.shareButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.shareButton.topAnchor.constraint(greaterThanOrEqualTo: self.checkView.bottomAnchor, constant: Theme.current.mainPaddings),
            self.shareButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.shareButton.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -30),
            self.shareButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
            self.stackView.leftAnchor.constraint(equalTo: self.checkView.leftAnchor, constant: Theme.current.mainPaddings),
            self.stackView.topAnchor.constraint(equalTo: self.checkView.topAnchor, constant: Theme.current.mainPaddings),
            self.stackView.rightAnchor.constraint(equalTo: self.checkView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.stampView.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 30),
            self.stampView.centerXAnchor.constraint(equalTo: self.checkView.centerXAnchor),
            self.stampView.widthAnchor.constraint(equalTo: self.checkView.widthAnchor, multiplier: 0.8),
            self.stampView.bottomAnchor.constraint(equalTo: self.checkView.bottomAnchor, constant: -30),
        ])
        self.shareButton.addTarget(self, action: #selector(self.asImage), for: .touchUpInside)
        transactionUpdate
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] info in
                guard let self = self else { return }
                if self.item.tran_id == info.0, self.item.status < info.1 {
                    self.item.status = info.1
                    self.setStatus()
                }
            }).disposed(by: self.viewModel.disposeBag)
        self.configure()
    }
    
    func setStatus() {
        self.stampView.payStatusLabel.textColor = self.item.statusType.color
        self.stampView.payStatusLabel.text = self.item.statusType.name.uppercased()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: nil)
    }
    
    func configure() {
        self.stampView.payStatusLabel.textColor = self.item.statusType.color
        self.stampView.payStatusLabel.text = self.item.statusType.name.uppercased()
        if let serviceId = Int(self.item.service), let service = self.viewModel.accountInfo.getService(serviceID: serviceId) {
            let infoView = HistoryInfoItemView(frame: .zero)
            infoView.titleLabel.text = "HISTORY_TITLE".localized
            infoView.infoLabel.text = service.name
            self.stackView.addArrangedSubview(infoView)
        }
        let tranView = HistoryInfoItemView(frame: .zero)
        tranView.titleLabel.text = "HISTORY_TRANSACTIONS".localized
        tranView.infoLabel.text = self.item.tran_id
        self.stackView.addArrangedSubview(tranView)
        let toBillView = HistoryInfoItemView(frame: .zero)
        toBillView.titleLabel.text = "HISTORY_TO_BILL".localized
        toBillView.infoLabel.text = self.item.accountTo
        self.stackView.addArrangedSubview(toBillView)
        let dateView = HistoryInfoItemView(frame: .zero)
        dateView.titleLabel.text = "HISTORY_DATE".localized
        dateView.infoLabel.text = self.item.datetime
        self.stackView.addArrangedSubview(dateView)
        let sumView = HistoryInfoItemView(frame: .zero)
        sumView.titleLabel.text = "HISTORY_SUM".localized
        sumView.infoLabel.text = self.item.amount.balanceText
        self.stackView.addArrangedSubview(sumView)
        let feeView = HistoryInfoItemView(frame: .zero)
        feeView.titleLabel.text = "HISTORY_FEE".localized
        feeView.infoLabel.text = self.item.commission.balanceText
        self.stackView.addArrangedSubview(feeView)
        let totalView = HistoryInfoItemView(frame: .zero)
        totalView.titleLabel.text = "HISTORY_TOTAL".localized
        totalView.infoLabel.text = self.item.amount.balanceText
        self.stackView.addArrangedSubview(totalView)
        let fromBill = HistoryInfoItemView(frame: .zero)
        fromBill.titleLabel.text = "HISTORY_FROM_BILL".localized
        if let balance = self.viewModel.accountInfo.accounts.first(where: { $0.account == self.item.accountFrom }) {
            fromBill.infoLabel.text = "\(balance.title)\n\(self.item.accountFrom)"
        } else {
            fromBill.infoLabel.text = self.item.accountFrom
        }
        self.stackView.addArrangedSubview(fromBill)
    }
    
    @objc func asImage() {
        let renderer = UIGraphicsImageRenderer(bounds: self.checkView.bounds)
        let image = renderer.image { rendererContext in
            self.checkView.layer.render(in: rendererContext.cgContext)
        }
        let imagesToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imagesToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.shareButton
        self.present(activityViewController, animated: true, completion: nil)
    }
}
