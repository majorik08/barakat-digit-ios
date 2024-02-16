//
//  HistoryViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 05/10/23.
//

import Foundation
import UIKit

class HistoryViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, FilterViewDelegate, HistorySumPickViewControllerDelegate, HistoryFilterPickViewControllerDelegate {
    
    let filterView: HistoryFilterView = {
        return HistoryFilterView(frame: .zero)
    }()
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        view.backgroundColor = .clear
        view.register(HistoryItemCell.self, forCellReuseIdentifier: "cell")
        view.separatorStyle = .none
        return view
    }()
    var lastContentOffset: CGFloat = 0
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
        self.view.addSubview(self.filterView)
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.filterView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.filterView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.filterView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.filterView.heightAnchor.constraint(equalToConstant: 44),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.filterView.bottomAnchor, constant: 10),
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
        self.viewModel.didLoadError.subscribe { [weak self] _ in
            self?.tableView.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
        }.disposed(by: self.viewModel.disposeBag)
        self.filterView.delegate = self
        self.filterView.configure(items: [.income(set: false), .expenses(set: false), .sum(from: nil, to: nil), .period(from: nil, to: nil), .operation(type: nil), .payedBy(account: nil, card: nil)])
        self.viewModel.getHistory()
    }
    
    override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.filterView.collectionView.reloadData()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: nil)
    }
    
    func didSelectFilter(item: HistoryFilter) {
        switch item {
        case .income(let set):
            if let index = self.filterView.filters.firstIndex(where: { item in
                guard case HistoryFilter.income(_) = item else { return false }
                return true
            }) {
                self.filterView.filters[index] = .income(set: !set)
                self.viewModel.setFilters(filter: .income(set: !set))
            }
        case .expenses(let set):
            if let index = self.filterView.filters.firstIndex(where: { item in
                guard case HistoryFilter.expenses(_) = item else { return false }
                return true
            }) {
                self.filterView.filters[index] = .expenses(set: !set)
                self.viewModel.setFilters(filter: .expenses(set: !set))
            }
        case .sum(let from, let to):
            if from != nil && to != nil {
                if let index = self.filterView.filters.firstIndex(where: { item in
                    guard case HistoryFilter.sum(_, _) = item else { return false }
                    return true
                }) {
                    self.filterView.filters[index] = .sum(from: nil, to: nil)
                    self.viewModel.setFilters(filter: .sum(from: nil, to: nil))
                }
            } else {
                self.coordinator?.presentSumPicker(currency: .TJS, delegate: self)
                return
            }
        case .period(let from, let to):
            if from != nil && to != nil {
                if let index = self.filterView.filters.firstIndex(where: { item in
                    guard case HistoryFilter.period(_, _) = item else { return false }
                    return true
                }) {
                    self.filterView.filters[index] = .period(from: nil, to: nil)
                    self.viewModel.setFilters(filter: .period(from: nil, to: nil))
                }
            } else {
                self.selectDateRange()
                return
            }
        case .operation(let type):
            self.coordinator?.presentFilterPicker(filter: .operation(type: type), delegate: self)
            return
        case .payedBy(let account, let card):
            if account != nil || card != nil {
                if let index = self.filterView.filters.firstIndex(where: { item in
                    guard case HistoryFilter.payedBy(_, _) = item else { return false }
                    return true
                }) {
                    self.filterView.filters[index] = .payedBy(account: nil, card: nil)
                    self.viewModel.setFilters(filter: .payedBy(account: nil, card: nil))
                }
            } else {
                self.coordinator?.presentFilterPicker(filter: .payedBy(account: nil, card: nil), delegate: self)
                return
            }
        }
        self.filterView.collectionView.reloadData()
    }
    
    func selectDateRange() {
        var customConfig = FastisConfig()
        var calendar: Calendar = .current
        calendar.locale = Locale(identifier: Localize.currentLanguage.rawValue)
        customConfig.calendar = calendar
        let fastisController = FastisController(mode: .range, config: customConfig)
        fastisController.title = "SELECT_DATE".localized
        //fastisController.initialValue = self.currentValue as? FastisRange
        //fastisController.minimumDate = Calendar.current.date(byAdding: .month, value: -2, to: Date())
        fastisController.maximumDate = Date()
        fastisController.allowToChooseNilDate = true
        fastisController.shortcuts = [.today, .lastWeek, .lastMonth]
        fastisController.dismissHandler = { action in
            switch action {
            case .done(let newValue):
                guard let range = newValue else { return }
                if let index = self.filterView.filters.firstIndex(where: { item in
                    guard case HistoryFilter.period(_, _) = item else { return false }
                    return true
                }) {
                    self.filterView.filters[index] = .period(from: range.fromDate, to: range.toDate)
                    self.filterView.collectionView.reloadData()
                    self.viewModel.setFilters(filter: .period(from: range.fromDate, to: range.toDate))
                }
            case .cancel:break
            }
        }
        fastisController.present(above: self)
    }
    
    func historySumPicked(from: Double, to: Double) {
        if let index = self.filterView.filters.firstIndex(where: { item in
            guard case HistoryFilter.sum(_, _) = item else { return false }
            return true
        }) {
            self.filterView.filters[index] = .sum(from: from, to: to)
            self.filterView.collectionView.reloadData()
            self.viewModel.setFilters(filter: .sum(from: from, to: to))
        }
    }
    
    func historyFilterPicked(filter: HistoryFilter) {
        switch filter {
        case .payedBy(let account, let card):
            if let index = self.filterView.filters.firstIndex(where: { item in
                guard case HistoryFilter.payedBy(_, _) = item else { return false }
                return true
            }) {
                self.filterView.filters[index] = .payedBy(account: account, card: card)
                self.filterView.collectionView.reloadData()
                self.viewModel.setFilters(filter: .payedBy(account: account, card: card))
            }
        case .operation(let type):
            if let index = self.filterView.filters.firstIndex(where: { item in
                guard case HistoryFilter.operation(_) = item else { return false }
                return true
            }) {
                self.filterView.filters[index] = .operation(type: type)
                self.filterView.collectionView.reloadData()
                self.viewModel.setFilters(filter: .operation(type: type))
            }
        default:break
        }
    }
    
    @objc func reloadHistory() {
        self.viewModel.reloadHistory()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.viewModel.historySections[indexPath.section].items[indexPath.row]
        self.coordinator?.navigateToHistoryDetails(item: item)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HistoryItemCell
        let item = self.viewModel.historySections[indexPath.section].items[indexPath.row]
        let serviceId = Int(item.service) ?? 0
        let service = self.viewModel.accountInfo.getService(serviceID: serviceId)
        cell.configure(history: item, service: service)
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
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.beginBatchFetchingIfNeededWithContentOffset(scroll: scrollView, contentOffset: targetContentOffset.pointee, velocity: velocity)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !(scrollView.isDragging || scrollView.isTracking) {
            self.beginBatchFetchingIfNeededWithContentOffset(scroll: scrollView, contentOffset: scrollView.contentOffset, velocity: .zero)
        }
    }
    
    private func beginBatchFetchingIfNeededWithContentOffset(scroll: UIScrollView, contentOffset: CGPoint, velocity: CGPoint) {
        let screensForBatching: CGFloat = 0.3
        let scrollDirectionDown: Bool?
        if self.lastContentOffset > scroll.contentOffset.y {
            scrollDirectionDown = false
        } else if self.lastContentOffset < scroll.contentOffset.y {
            scrollDirectionDown = true
        } else {
            scrollDirectionDown = nil
        }
        self.lastContentOffset = scroll.contentOffset.y
        guard !self.viewModel.isLoading else { return }
        let bounds = scroll.bounds
        let leadingScreens = screensForBatching
        guard leadingScreens > 0.0, !bounds.isEmpty else { return }
        let contentSize = scroll.contentSize
        let visible = scroll.window != nil
        let viewLength = bounds.size.height
        let contentLength = contentSize.height
        let offset = contentOffset.y
        let hasSmallContent = contentLength < viewLength
        if hasSmallContent {
            if scrollDirectionDown ?? false {
                self.viewModel.getHistory()
            }
            return
        }
        if !visible {
            return
        }
        let maximumOffset = scroll.contentSize.height - scroll.frame.size.height
        if maximumOffset - offset <= 10 {
            self.viewModel.getHistory()
        }
    }
}
