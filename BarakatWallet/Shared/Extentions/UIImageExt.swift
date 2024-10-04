//
//  UIImageExt.swift
//  BarakatWallet
//
//  Created by km1tj on 21/10/23.
//

import Foundation
import UIKit
import QRCode

internal extension UIImage {
    
    enum ImageName: String {
        case menu_icon
        case notify
        case plus_icon
        case tab_cards
        case tab_history
        case tab_home
        case tab_payments
        case tab_menu
        case tab_qr
        case wallet_icon
        case bonus_icon
        case wallet_inset
        case main_logo
        case main_logo_in
        case search
        case add_number
        case app_logo
        case delete
        case unchecked
        case checked
        case checked_fill
        case check_x
        case down_arrow
        case back_arrow
        case camera_close
        case camera_flash
        case camera_pick
        case arrow_right
        case copy_value
        
        case close_x
        case transfer_help
        case transfer_card
        case transfer_number
        
        case status_one
        case status_two
        case status_three
        
        case plus_inset
        case repeat_icon
        case fav_icon
        case add_bold
        
        case card_american
        case card_diners
        case card_discover
        case card_jcb
        case card_master
        case card_milli
        case card_mir
        case card_paypal
        case card_union
        case card_visa
        
        case card_action_history
        case card_action_pay
        case card_action_topup
        case card_action_transfer
        
        case per_icon
        case rubl_icon
        case card_icon
        case recipe
        case share
        case success
        
        case face_icon
        case touch_icon
        
        case logout
        case doc
        case hide_eyes
        case download
        case qr_button
        
        case profile_add
        case profile_chat
        case profile_icon
        case profile_save
        case profile_settings
        case profile_share
        
        case check_dark
        case check_light
        case checkmark_v
        case arrow_up
        case flag_eu
        case flag_ru
        case flag_usa
    }
    
    convenience init(name: ImageName) {
        self.init(named: name.rawValue, in: .main, compatibleWith: nil)!
    }
}



extension UIImage {
    
    static func generateAppQRCode(from string: String) -> UIImage? {
        let doc = QRCode.Document(message: QRCode.Message.Phone(string))
        doc.errorCorrection = .high
//        doc.design.style.backgroundFractionalCornerRadius = 1
//        doc.design.style.background = QRCode.FillStyle.Solid(UIColor.white.cgColor)
//        doc.design.shape.eye = QRCode.EyeShape.Leaf()
//        doc.design.style.eye = QRCode.FillStyle.Solid(UIColor(red: 0.28, green: 0.74, blue: 0.70, alpha: 1.00).cgColor)
//        doc.design.shape.pupil = QRCode.PupilShape.Leaf()
//        doc.design.style.pupil = QRCode.FillStyle.Solid(UIColor(red: 0.28, green: 0.74, blue: 0.70, alpha: 1.00).cgColor)
//        doc.design.shape.onPixels = QRCode.PixelShape.Vertical(insetFraction: 0.1, cornerRadiusFraction: 0.75)
//        doc.design.style.onPixels = QRCode.FillStyle.Solid(UIColor(red: 0.28, green: 0.74, blue: 0.70, alpha: 1.00).cgColor)
        doc.logoTemplate = QRCode.LogoTemplate (
            image: UIImage(name: .main_logo_in).cgImage!,
            path: CGPath(rect: CGRect(x: 0.35, y: 0.35, width: 0.30, height: 0.30), transform: nil),
            inset: 3
        )
        let generated = doc.cgImage(CGSize(width: 800, height: 800))
        if let g = generated {
            return UIImage(cgImage: g)
        }
        return nil
    }
    
    static func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 12, y: 12)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }

    func tintedWithLinearGradientColors() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1, y: -1)
        context.setBlendMode(.normal)
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        let colorsArr: [CGColor] = [Theme.light(globalColor: Constants.LighGlobalColor).mainGradientStartColor.cgColor, Theme.light(globalColor: Constants.LighGlobalColor).mainGradientEndColor.cgColor]
        let colors = colorsArr as CFArray
        let space = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: space, colors: colors, locations: nil)
        context.clip(to: rect, mask: self.cgImage!)
        context.drawLinearGradient(gradient!, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: self.size.height), options: .drawsAfterEndLocation)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return gradientImage!
    }
    
    func parseQR() -> String? {
        guard let image = CIImage(image: self) else { return nil }
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        let features = detector?.features(in: image) ?? []
        return features.compactMap { feature in
            return (feature as? CIQRCodeFeature)?.messageString
        }.joined()
    }
    
    func compressImage() -> Data? {
        return self.jpegData(compressionQuality: 0.52)
    }
    
    func scaleImage() -> UIImage {
        let nativeImageSize = CGSize(width: self.size.width * self.scale, height: self.size.height * self.scale)
        let dimensions = nativeImageSize.fitted(CGSize(width: 1920.0, height: 1920.0))
        return UIImage.scalePhotoImage(self, dimensions: dimensions) ?? self
    }
    
    static func scalePhotoImage(_ image: UIImage, dimensions: CGSize) -> UIImage? {
        if #available(iOSApplicationExtension 10.0, *) {
            let format = UIGraphicsImageRendererFormat()
            format.scale = 1.0
            let renderer = UIGraphicsImageRenderer(size: dimensions, format: format)
            return renderer.image { _ in
                image.draw(in: CGRect(origin: .zero, size: dimensions))
            }
        } else {
            return scaleImageToPixelSize(image: image, size: dimensions)
        }
    }
    
    static func scaleImageToPixelSize(image: UIImage, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, true, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height), blendMode: CGBlendMode.copy, alpha: 1.0)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result ?? image
    }
}

public extension CGSize {
    func fitted(_ size: CGSize) -> CGSize {
        var fittedSize = self
        if fittedSize.width > size.width {
            fittedSize = CGSize(width: size.width, height: floor((fittedSize.height * size.width / max(fittedSize.width, 1.0))))
        }
        if fittedSize.height > size.height {
            fittedSize = CGSize(width: floor((fittedSize.width * size.height / max(fittedSize.height, 1.0))), height: size.height)
        }
        return fittedSize
    }
}
