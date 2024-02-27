//
//  QrCoordinator.swift
//  BarakatWallet
//
//  Created by km1tj on 28/10/23.
//

import Foundation
import UIKit

class QrCoordinator: Coordinator, QRScannerCodeDelegate {
   
    weak var parent: RootTabCoordinator? = nil
    var children: [Coordinator] = []
    let nav: BaseNavigationController
    
    let accountInfo: AppStructs.AccountInfo
    
    init(nav: BaseNavigationController, accountInfo: AppStructs.AccountInfo) {
        self.accountInfo = accountInfo
        self.nav = nav
    }
    
    func start() {
        let vc = QrViewController(config: QRScannerConfiguration.default)
        vc.delegate = self
        self.nav.present(vc, animated: true)
    }
    
    func qrScannerShowMyQr(_ controller: UIViewController) {
        controller.present(ProfileQrViewController(client: self.accountInfo.client), animated: true)
    }
    
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        print("result:\(result)")
        self.parent?.checkQr(qr: result.replacingOccurrences(of: "TEL:", with: ""))
    }
    
    func qrScannerDidFail(_ controller: UIViewController, error: QRCodeError) {
        print("error:\(error.localizedDescription)")
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        print("SwiftQRScanner did cancel")
    }
}
