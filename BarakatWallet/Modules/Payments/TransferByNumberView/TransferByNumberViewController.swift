//
//  TransferByNumberViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 08/11/23.
//

import Foundation
import UIKit

class TransferByNumberViewController: BaseViewController {
    
    let viewModel: PaymentsViewModel
    weak var coordinator: PaymentsCoordinator? = nil
    
    init(viewModel: PaymentsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.current.plainTableBackColor
    }
}
