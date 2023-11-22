//
//  UIImageViewExt.swift
//  BarakatWallet
//
//  Created by km1tj on 09/11/23.
//

import Foundation
import UIKit

extension UIImageView: ImageSet {
    public func setImage(image: UIImage?) {
        DispatchQueue.main.async { self.image = image }
    }
    
    public func loadFailed() {
        DispatchQueue.main.async { self.image = nil }
    }
    
    public func loadImage(filePath: String) {
        guard !filePath.isEmpty else { return }
        APIManager.instance.loadImage(into: self, filePath: filePath)
    }
}
