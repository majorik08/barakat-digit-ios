//
//  QrViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 05/10/23.
//

import AVFoundation
import Foundation
import UIKit

class QrViewController: QRCodeScannerController {
    
    init(config: QRScannerConfiguration) {
        super.init(qrScannerConfiguration: config)
        //self.modalTransitionStyle = .crossDissolve
        //self.modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
