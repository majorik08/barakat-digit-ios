//
//  ShowcaseViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 08/11/23.
//

import Foundation
import UIKit

class ShowcaseViewController: BaseViewController {
    
    let viewModel: ShowcaseViewModel
    let showcase: AppStructs.Showcase
    weak var coordinator: HomeCoordinator? = nil
    
    init(viewModel: ShowcaseViewModel, showcase: AppStructs.Showcase) {
        self.viewModel = viewModel
        self.showcase = showcase
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
