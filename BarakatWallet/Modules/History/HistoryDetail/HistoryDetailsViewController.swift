//
//  HistoryDetails.swift
//  BarakatWallet
//
//  Created by km1tj on 06/11/23.
//

import Foundation
import UIKit

class HistoryDetailsViewController: BaseViewController {
    
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
    }
}
