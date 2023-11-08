//
//  RatesViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 08/11/23.
//

import Foundation
import UIKit

class RatesViewController: BaseViewController {
    
    let viewModel: RatesViewModel
    weak var coordinator: HomeCoordinator? = nil
    
    init(viewModel: RatesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Convertor"
        self.view.backgroundColor = Theme.current.plainTableBackColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: nil)
    }
}
