//
//  GradientLabel.swift
//  BarakatWallet
//
//  Created by km1tj on 22/10/23.
//

import Foundation
import UIKit

class GradientLabel: UILabel {
    
    private var shadowLayer: CALayer?
    var shadowEnabled: Bool = true
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        installLayers()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        installLayers()
    }
    
    init(shadowEnabled: Bool) {
        self.shadowEnabled = shadowEnabled
        super.init(frame: .zero)
        installLayers()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.shadowLayer?.frame = self.bounds
        self.updateShadow()
        if !self.bounds.isEmpty {
            self.setGradientColor()
        }
    }
    
    override var frame: CGRect {
        didSet {
            self.shadowLayer?.frame = self.bounds
            self.updateShadow()
            if !self.bounds.isEmpty {
                self.setGradientColor()
            }
        }
    }
    
    private func installLayers() {
        self.backgroundColor = .clear
        self.clipsToBounds = false
        if let shadowLayer = self.shadowLayer {
            shadowLayer.removeFromSuperlayer()
        }
        if self.shadowEnabled {
            let shadowPath0 = UIBezierPath(roundedRect: self.bounds, cornerRadius: 0)
            let layer0 = CALayer()
            layer0.shadowPath = shadowPath0.cgPath
            layer0.shadowColor = Theme.current.shadowColor.cgColor
            layer0.shadowOpacity = 1
            layer0.shadowRadius = 28
            layer0.shadowOffset = CGSize(width: 2, height: 5)
            layer0.bounds = self.bounds
            layer0.position = self.center
            self.layer.insertSublayer(layer0, at: 0)
            self.shadowLayer = layer0
        }
    }
    
    func updateShadow() {
        if let shadow = self.shadowLayer {
            shadow.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 0).cgPath
        }
    }
    
    func setGradientColor() {
        let gr = getGradientLayer(bounds: self.bounds)
        self.textColor = gradientColor(bounds: self.bounds, gradientLayer: gr)
    }
    
    func getGradientLayer(bounds : CGRect) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.cornerRadius = 5
        gradient.colors = [Theme.current.mainGradientStartColor.cgColor, Theme.current.mainGradientEndColor.cgColor]
        gradient.startPoint = .init(x: 0, y: 1)
        gradient.endPoint = .init(x: 1, y: 0)
        gradient.shadowOffset = CGSize(width: 1, height: 2)
        return gradient
    }
    
    func gradientColor(bounds: CGRect, gradientLayer: CAGradientLayer) -> UIColor? {
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image!)
    }
}
