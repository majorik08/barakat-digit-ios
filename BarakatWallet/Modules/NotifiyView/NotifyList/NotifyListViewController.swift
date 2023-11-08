//
//  NotifyListViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 06/11/23.
//

import Foundation
import UIKit

class NotifyListViewController: BaseViewController {
    
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
        let sectionView = UISegmentedControl(items: ["NEWS".localized, "NOTIFICATION".localized])
        sectionView.selectedSegmentIndex = 0
        self.navigationItem.titleView = sectionView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: true)
    }
}
