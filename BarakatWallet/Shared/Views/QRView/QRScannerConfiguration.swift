//
//  QRScannerView.swift
//  BarakatWallet
//
//  Created by km1tj on 28/10/23.
//

import Foundation
import UIKit
import PhotosUI

public struct QRScannerConfiguration {
    public var title: String
    public var hint: String?
    public var invalidQRCodeAlertTitle: String
    public var invalidQRCodeAlertActionTitle: String
    public var uploadFromPhotosTitle: String
    public var backButtonImage: UIImage?
    public var flashOnImage: UIImage?
    public var galleryImage: UIImage?
    public var length: CGFloat
    public var color: UIColor
    public var radius: CGFloat
    public var thickness: CGFloat
    public var readQRFromPhotos: Bool
    public var cancelButtonTitle: String
    public var cancelButtonTintColor: UIColor?
    
    public init(title: String = "Scan QR Code",
                hint: String = "Align QR code within frame to scan",
                uploadFromPhotosTitle: String = "Upload from photos",
                invalidQRCodeAlertTitle: String = "Invalid QR Code",
                invalidQRCodeAlertActionTitle: String = "OK",
                backButtonImage: UIImage? = nil,
                flashOnImage: UIImage? = nil,
                length: CGFloat = 20.0,
                color: UIColor = .green,
                radius: CGFloat = 10.0,
                thickness: CGFloat = 5.0,
                readQRFromPhotos: Bool = true,
                cancelButtonTitle: String = "Cancel",
                cancelButtonTintColor: UIColor? = nil) {
        self.title = title
        self.hint = hint
        self.uploadFromPhotosTitle = uploadFromPhotosTitle
        self.invalidQRCodeAlertTitle = invalidQRCodeAlertTitle
        self.invalidQRCodeAlertActionTitle = invalidQRCodeAlertActionTitle
        self.backButtonImage = backButtonImage
        self.flashOnImage = flashOnImage
        self.length = length
        self.color = color
        self.radius = radius
        self.thickness = thickness
        self.readQRFromPhotos = readQRFromPhotos
        self.cancelButtonTitle = cancelButtonTitle
        self.cancelButtonTintColor = cancelButtonTintColor
    }
}

extension QRScannerConfiguration {
    public static var `default`: QRScannerConfiguration {
        QRScannerConfiguration(title: "Scan QR Code",
                               hint: "Align QR code within frame to scan",
                               uploadFromPhotosTitle: "Upload from photos",
                               invalidQRCodeAlertTitle: "Invalid QR Code",
                               invalidQRCodeAlertActionTitle: "OK",
                               backButtonImage: UIImage(name: .camera_close),
                               flashOnImage: UIImage(name: .camera_flash),
                               length: 20.0,
                               color: .systemGreen,
                               radius: 10.0,
                               thickness: 5.0,
                               readQRFromPhotos: true,
                               cancelButtonTitle: "CANCEL".localized,
                               cancelButtonTintColor: nil)
    }
}

public enum QRCodeError: Error {
    case inputFailed
    case outoutFailed
    case emptyResult
}

extension QRCodeError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .inputFailed:
            return "Failed to add input."
        case .outoutFailed:
            return "Failed to add output."
        case .emptyResult:
            return "Empty string found."
        }
    }
}

extension QRCodeError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .inputFailed:
            return NSLocalizedString(
                "Failed to add input.",
                comment: "Failed to add input."
            )
        case .outoutFailed:
            return NSLocalizedString(
                "Failed to add output.",
                comment: "Failed to add output."
            )
        case .emptyResult:
            return NSLocalizedString(
                "Empty string found.",
                comment: "Empty string found."
            )
        }
    }
}
