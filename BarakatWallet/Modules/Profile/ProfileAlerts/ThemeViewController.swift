//
//  ThemeViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 31/10/23.
//

import Foundation
import UIKit

class ThemeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource  {
    
    let bgView: GradientView = {
        let view = GradientView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startColor = Theme.current.mainGradientStartColor
        view.endColor = Theme.current.mainGradientEndColor
        view.alpha = 0.5
        return view
    }()
    let rootView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.navigationColor
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
        view.font = UIFont.bold(size: 20)
        view.text = "THEME".localized
        view.textAlignment = .center
        view.textColor = Theme.current.navigationTextColor
        return view
    }()
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        view.backgroundColor = .clear
        view.separatorColor = Theme.current.plainTableSeparatorColor
        return view
    }()
    
    var themes: [String] = ["DEFAULT", "LIGHT", "DARK"]
    var changeIng: Bool = false
    let viewModel: ProfileViewModel
    weak var coordinator: ProfileCoordinator?
    weak var delegate: AlertViewControllerDelegate?
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
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
        self.rootView.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.bgView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.bgView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.bgView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.bgView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.rootView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.rootView.topAnchor.constraint(greaterThanOrEqualTo: self.view.topAnchor),
            self.rootView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.rootView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.topAnchorView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 16),
            self.topAnchorView.centerXAnchor.constraint(equalTo: self.rootView.centerXAnchor),
            self.topAnchorView.heightAnchor.constraint(equalToConstant: 6),
            self.topAnchorView.widthAnchor.constraint(equalToConstant: 42),
            self.titleView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 16),
            self.titleView.topAnchor.constraint(equalTo: self.topAnchorView.bottomAnchor, constant: 20),
            self.titleView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -16),
            self.tableView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 20),
            self.tableView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
            self.tableView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
            self.tableView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0),
            self.tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3),
        ])
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.rootView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
    }
    
    override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
        self.view.backgroundColor = .clear
        self.tableView.separatorColor = Theme.current.plainTableSeparatorColor
        self.rootView.backgroundColor = Theme.current.navigationColor
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.themes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.changeIng {
            return
        }
        self.changeIng = true
        let theme = self.themes[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        let tempView = UIActivityIndicatorView(style: .gray)
        tempView.startAnimating()
        cell?.accessoryView = tempView
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            Constants.Theme = theme
             if theme == "LIGHT" {
                 Theme.current = Theme.light(globalColor: Constants.LighGlobalColor)
            } else if theme == "DARK" {
                Theme.current = Theme.dark(globalColor: Constants.DarkGlobalColor)
             } else {
                if #available(iOS 12.0, *) {
                    if UIViewController().traitCollection.userInterfaceStyle == .dark {
                        Theme.current = Theme.dark(globalColor: Constants.DarkGlobalColor)
                        Theme.current.value = "DEFAULT"
                    } else {
                        Theme.current = Theme.light(globalColor: Constants.LighGlobalColor)
                        Theme.current.value = "DEFAULT"
                    }
                } else {
                    Theme.current = Theme.light(globalColor: Constants.LighGlobalColor)
                    Theme.current.value = "DEFAULT"
                }
            }
            if let main = self.coordinator?.parent?.parent {
                main.parent?.window.tintColor = Theme.current.tintColor
                main.tabBar.themeChanged(newTheme: Theme.current)
                self.themeChanged(newTheme: Theme.current)
            }
            tempView.stopAnimating()
            cell?.accessoryView = nil
            tableView.reloadData()
            self.changeIng = false
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? BaseTableCell(style: .default, reuseIdentifier: "cell", tableView: tableView)
        let view = UIView(backgroundColor: Theme.current.plainSelectedCellBackground)
        cell.selectedBackgroundView = view
        cell.backgroundView = UIView(backgroundColor: .clear)
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = Theme.current.primaryTextColor
        cell.textLabel?.font = UIFont.bold(size: 16)
        cell.imageView?.tintColor = Theme.current.secondTintColor
        let theme = self.themes[indexPath.row]
        cell.textLabel?.text = theme.localized
        if Constants.Theme == theme {
            cell.accessoryView = UIImageView(image: UIImage(name: .checked))
        } else {
            cell.accessoryView = UIImageView(image: UIImage(name: .unchecked))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.animateDismis()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.animateView()
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
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {() -> Void in
            self.rootView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        }, completion: {(finished: Bool) -> Void in
            self.dismiss(animated: true)
            self.delegate?.didDismisAlert()
        })
    }
}
