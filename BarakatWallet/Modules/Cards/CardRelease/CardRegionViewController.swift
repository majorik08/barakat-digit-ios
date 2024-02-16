//
//  CardRegionViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 28/01/24.
//

import Foundation
import UIKit

protocol CardRegionViewControllerDelegate: AnyObject {
    func regionSelected(region: AppStructs.Region?, point: AppStructs.Region.Points?)
}

class CardRegionViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum SelectType {
        case region(regions: [AppStructs.Region])
        case point(points: [AppStructs.Region.Points])
    }
    
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
        view.separatorStyle = .none
        return view
    }()
    let selectType: SelectType
    weak var delegate: CardRegionViewControllerDelegate?
    
    init(selectType: SelectType) {
        self.selectType = selectType
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
        switch self.selectType {
        case .region(regions: let regions):
            let item = regions[indexPath.row]
            self.delegate?.regionSelected(region: item, point: item.points.first)
        case .point(points: let points):
            let item = points[indexPath.row]
            self.delegate?.regionSelected(region: nil, point: item)
        }
        self.dismisIfCan()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.selectType {
        case .region(regions: let regions):
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? BaseTableCell
            if cell == nil {
                cell = BaseTableCell(style: .default, reuseIdentifier: "cell", tableView: tableView)
            }
            cell?.backgroundColor = Theme.current.groupedTableCellColor
            let item = regions[indexPath.row]
            cell?.textLabel?.text = item.name
            return cell!
        case .point(points: let points):
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell_d") as? BaseTableCell
            if cell == nil {
                cell = BaseTableCell(style: .subtitle, reuseIdentifier: "cell_d", tableView: tableView)
            }
            cell?.backgroundColor = Theme.current.groupedTableCellColor
            let item = points[indexPath.row]
            cell?.textLabel?.text = item.name
            cell?.detailTextLabel?.text = item.address
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.selectType {
        case .region(regions: let regions):
            return regions.count
        case .point(points: let points):
            return points.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}
