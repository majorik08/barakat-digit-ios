//
//  NotifyListViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 06/11/23.
//

import Foundation
import UIKit

class NotifyListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        view.backgroundColor = .clear
        view.register(NotifyListImageCell.self, forCellReuseIdentifier: "cell_news")
        view.register(NotifyListCell.self, forCellReuseIdentifier: "cell_notify")
        view.separatorStyle = .none
        return view
    }()
    var lastContentOffset: CGFloat = 0
    var selectedIndex: Int = 0
    let viewModel: NotifyViewModel
    weak var coordinator: NotifyCoordinator?
    
    init(viewModel: NotifyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "NOTIFICATION".localized
        let sectionView = UISegmentedControl(items: ["NEWS".localized, "NOTIFICATION".localized])
        sectionView.selectedSegmentIndex = 0
        sectionView.addTarget(self, action: #selector(self.selected(_:)), for: .valueChanged)
        self.navigationItem.titleView = sectionView
        self.navigationItem.largeTitleDisplayMode = .never
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
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl!.tintColor = Theme.current.tintColor
        self.tableView.refreshControl!.addTarget(self, action: #selector(reloadItems), for: .valueChanged)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.viewModel.didListUpdate.subscribe(onNext: { [weak self] _ in
            self?.tableView.refreshControl?.endRefreshing()
            self?.tableView.reloadDataAndKeepOffset()
        }).disposed(by: self.viewModel.disposeBag)
        self.viewModel.didLoadError.subscribe(onNext: { [weak self] _ in
            self?.tableView.refreshControl?.endRefreshing()
        }).disposed(by: self.viewModel.disposeBag)
        self.tableView.refreshControl?.beginRefreshing()
        self.viewModel.loadNews(reload: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: nil)
    }
    
    @objc func reloadItems() {
        self.viewModel.loadNews(reload: true)
    }
    
    @objc func selected(_ sender: UISegmentedControl) {
        self.selectedIndex = sender.selectedSegmentIndex
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.selectedIndex == 0 {
            let item = self.viewModel.newsList[indexPath.row]
            if !item.image.isEmpty {
                guard let cell = tableView.cellForRow(at: indexPath) as? NotifyListImageCell else { return }
                cell.setFullText(item: item, showText: cell.subTitleView.text == nil ? true : false)
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        } else if self.selectedIndex == 1 {
            let item = self.viewModel.notifyList[indexPath.row]
            if !item.image.isEmpty {
                guard let cell = tableView.cellForRow(at: indexPath) as? NotifyListImageCell else { return }
                cell.setFullText(item: item, showText: cell.subTitleView.text == nil ? true : false)
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.selectedIndex == 0 {
            let item = self.viewModel.newsList[indexPath.row]
            if item.image.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell_notify", for: indexPath) as! NotifyListCell
                cell.configure(item: item)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell_news", for: indexPath) as! NotifyListImageCell
                cell.configure(item: item)
                return cell
            }
        } else if self.selectedIndex == 1 {
            let item = self.viewModel.notifyList[indexPath.row]
            if item.image.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell_notify", for: indexPath) as! NotifyListCell
                cell.configure(item: item)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell_news", for: indexPath) as! NotifyListImageCell
                cell.configure(item: item)
                return cell
            }
        }
        return UITableViewCell(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectedIndex == 0 {
            return self.viewModel.newsList.count
        } else if self.selectedIndex == 1 {
            return self.viewModel.notifyList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
                self.viewModel.loadNews(reload: false)
            }
            return
        }
        if !visible {
            return
        }
        let maximumOffset = scroll.contentSize.height - scroll.frame.size.height
        if maximumOffset - offset <= 10 {
            self.viewModel.loadNews(reload: false)
        }
    }
}
