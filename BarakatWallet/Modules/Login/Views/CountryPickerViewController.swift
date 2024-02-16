//
//  CountryPickerViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 22/01/24.
//

import Foundation
import UIKit

class CountrySection {
    var headerView: UIView?
    var title: String = ""
    var items: [CountryPicker.Country] = []
}

public protocol CountryPickerDelegate: AnyObject {
    func onSelected(type: CountryPicker.Country)
}

public class CountryPickerViewController: BaseTableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var searchController = UISearchController(searchResultsController:  nil)
    var sections = [CountrySection]()
    var countries = [CountryPicker.Country]()
    var searchResults = [CountryPicker.Country]()
    var sectionIndexTitles = [String]()
    public weak var delegate: CountryPickerDelegate?
    var isSearchMode = false
    let transparentChange: Bool
    
    public init(transparentChange: Bool = false) {
        self.transparentChange = transparentChange
        super.init(style: .plain)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = .top
        self.navigationItem.title = "SELECT_COUNTRY".localized
        self.view.backgroundColor = Theme.current.groupedTableBackColor
        self.countries = CountryPicker.getAllCountry(language: Constants.Language ?? "en")
        var sectionsDic = [String:CountrySection]()
        for country in self.countries {
            let startIndex = country.countryName.index(country.countryName.startIndex, offsetBy: 1)
            let sectionTitle = String(country.countryName[..<startIndex])
            if let cs = sectionsDic[sectionTitle] {
                cs.items.append(country)
            } else {
                let sec = CountrySection()
                sec.title = sectionTitle
                sec.items.append(country)
                sectionsDic[sectionTitle] = sec
                self.sectionIndexTitles.append(sectionTitle)
                self.sections.append(sec)
            }
        }
        self.searchController.searchResultsUpdater = self
        //searchController?.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.delegate = self
        self.tableView.backgroundColor = Theme.current.groupedTableBackColor
        self.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tableView.rowHeight = 44
        if #available(iOS 11.0, *) {
            //tableView.contentInsetAdjustmentBehavior = .never
            #if os(iOS)
            self.navigationItem.searchController = searchController
            self.navigationItem.hidesSearchBarWhenScrolling = true
            #endif
            self.searchController.hidesNavigationBarDuringPresentation = false
        } else {
            self.tableView.tableHeaderView = searchController.searchBar
            self.searchController.hidesNavigationBarDuringPresentation = true
        }
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        self.isSearchMode = false
        if let text = searchController.searchBar.text, text.count > 0 {
            self.isSearchMode = true
            self.searchResults.removeAll()
            self.searchResults.append(contentsOf: self.countries.filter({ $0.countryName.hasPrefix(text.prefix(1).uppercased() +  text.dropFirst()) }))
        }
        self.tableView.reloadData()
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCountry = self.isSearchMode ? searchResults[indexPath.row]
            : self.sections[indexPath.section].items[indexPath.row]
        self.searchController.dismiss(animated: false) {
            self.delegate?.onSelected(type: selectedCountry)
            if self.navigationController?.viewControllers.count == 1 {
                self.navigationController?.dismiss(animated: true)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    public override func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tableView {
            return self.isSearchMode ? 1 : self.sections.count
        }
        return 0
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return self.isSearchMode ? searchResults.count : self.sections[section].items.count
        }
        return 0
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        if cell == nil {
            cell = BaseTableCell(style: .value1, reuseIdentifier: "reuseIdentifier", tableView: tableView)
        }
        let country = self.isSearchMode ? self.searchResults[indexPath.row] : self.sections[indexPath.section].items[indexPath.row]
        cell?.textLabel?.textColor = Theme.current.primaryTextColor
        cell?.detailTextLabel?.textColor = Theme.current.secondaryTextColor
        cell?.textLabel?.font = UIFont.regular(size: 17)
        cell?.detailTextLabel?.font = UIFont.regular(size: 17)
        cell?.textLabel?.text = country.countryName
        cell?.detailTextLabel?.text = country.countryPhoneCode
        return cell!
    }
    
    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headrview = tableView.dequeueReusableHeaderFooterView(withIdentifier: "aaa")
        if headrview == nil {
            headrview = UITableViewHeaderFooterView(reuseIdentifier: "aaa")
        }
        let bview = UIView()
        bview.backgroundColor = Theme.current.navigationColor
        headrview?.backgroundView = bview
        headrview?.textLabel?.textColor = Theme.current.primaryTextColor
        return headrview
    }
    
    public override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if tableView == self.tableView {
            return self.isSearchMode ? nil : self.sectionIndexTitles
        }
        return nil
    }
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.isSearchMode ? nil : self.sections[section].title
    }
}
