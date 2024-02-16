//
//  TransferViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 08/11/23.
//

import Foundation
import UIKit

class TransferViewController: BaseViewController {
    
    let viewModel: PaymentsViewModel
    let transfer: AppStructs.PaymentGroup.ServiceItem
    weak var coordinator: PaymentsCoordinator? = nil
    
    init(viewModel: PaymentsViewModel, transfer: AppStructs.PaymentGroup.ServiceItem) {
        self.viewModel = viewModel
        self.transfer = transfer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.navigationItem.title = self.transfer.name
    }
}
