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

//class QrViewController: BaseViewController, AVCaptureMetadataOutputObjectsDelegate {
//
//    var captureSession: AVCaptureSession!
//    var previewLayer: AVCaptureVideoPreviewLayer!
//
//    init(show: Bool) {
//        super.init(nibName: nil, bundle: nil)
//        //self.modalTransitionStyle = .crossDissolve
//        //self.modalPresentationStyle = .overFullScreen
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = Theme.current.plainTableBackColor
//        self.captureSession = AVCaptureSession()
//
//        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
//        let videoInput: AVCaptureDeviceInput
//
//        do {
//            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
//        } catch {
//            return
//        }
//        if (self.captureSession.canAddInput(videoInput)) {
//            self.captureSession.addInput(videoInput)
//        } else {
//            failed()
//            return
//        }
//        let metadataOutput = AVCaptureMetadataOutput()
//        if (self.captureSession.canAddOutput(metadataOutput)) {
//            self.captureSession.addOutput(metadataOutput)
//            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//            metadataOutput.metadataObjectTypes = [.qr]
//        } else {
//            failed()
//            return
//        }
//        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        self.previewLayer.frame = view.layer.bounds
//        self.previewLayer.videoGravity = .resizeAspectFill
//        self.view.layer.addSublayer(previewLayer)
//        DispatchQueue.global(priority: .default).async {
//            self.captureSession.startRunning()
//        }
//    }
//
//    func failed() {
//        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        self.present(ac, animated: true)
//        self.captureSession = nil
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if (self.captureSession?.isRunning == false) {
//            self.captureSession.startRunning()
//        }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        if (self.captureSession?.isRunning == true) {
//            self.captureSession.stopRunning()
//        }
//    }
//
//    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//        self.captureSession.stopRunning()
//        if let metadataObject = metadataObjects.first {
//            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
//            guard let stringValue = readableObject.stringValue else { return }
//            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//            self.found(code: stringValue)
//        }
//        self.dismiss(animated: true)
//    }
//
//    func found(code: String) {
//        print(code)
//    }
//
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .portrait
//    }
//}
