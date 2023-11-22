//
//  BaseButtonView.swift
//  BarakatWallet
//
//  Created by km1tj on 22/10/23.
//

import Foundation
import UIKit
class BaseButtonView: UIButton {
    
    public override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                self.gradientLayer?.shadowOpacity = 0.2
                self.shadowLayer?.shadowOpacity = 0.6
            } else {
                self.shadowLayer?.shadowOpacity = 1
                self.gradientLayer?.shadowOpacity = 0
            }
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            if self.isEnabled {
                self.alpha = 1
                self.shadowLayer?.shadowOpacity = 1
            } else {
                self.alpha = 0.6
                self.shadowLayer?.shadowOpacity = 0.6
            }
        }
    }
    
    var startColor: UIColor = Theme.current.mainGradientStartColor {
        didSet {
            updateGradient()
        }
    }
    var endColor: UIColor = Theme.current.mainGradientEndColor {
        didSet {
            updateGradient()
        }
    }
    var radius: CGFloat = 0 {
        didSet {
            updateGradient()
            updateShadow()
        }
    }
    var circle: Bool = false
   
    private var gradientLayer: CAGradientLayer?
    private var shadowLayer: CALayer?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        installLayers()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        installLayers()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer?.frame = self.bounds
        self.shadowLayer?.frame = self.bounds
        if self.circle {
            self.radius = self.bounds.width / 2
        }
        self.updateGradient()
        self.updateShadow()
    }
    
    override var frame: CGRect {
        didSet {
            self.gradientLayer?.frame = self.bounds
            self.shadowLayer?.frame = self.bounds
            if self.circle {
                self.radius = self.bounds.width / 2
            }
            self.updateGradient()
            self.updateShadow()
        }
    }

    private func installLayers() {
        self.backgroundColor = .clear
        self.clipsToBounds = false
        if self.circle {
            self.radius = self.bounds.width / 2
        }
        if let gradient = self.gradientLayer {
            gradient.removeFromSuperlayer()
        }
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
        self.gradientLayer = gradient
        if let shadowLayer = self.shadowLayer {
            shadowLayer.removeFromSuperlayer()
        }
        let shadowPath0 = UIBezierPath(roundedRect: self.bounds, cornerRadius: 14)
        let layer0 = CALayer()
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = Theme.current.shadowColor.cgColor
        layer0.shadowOpacity = 0.6
        layer0.shadowRadius = 3
        layer0.shadowOffset = CGSize(width: 1, height: 3)
        layer0.bounds = self.bounds
        layer0.position = self.center
        self.layer.insertSublayer(layer0, at: 0)
        self.shadowLayer = layer0
        guard let imageView else { return }
        self.bringSubviewToFront(imageView)
    }
    
    func updateShadow() {
        if let shadow = self.shadowLayer {
            shadow.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.radius).cgPath
        }
    }

    func updateGradient() {
        if let gradient = self.gradientLayer {
            let startColor = self.startColor
            let endColor = self.endColor
            gradient.cornerRadius = self.radius
            gradient.colors = [startColor.cgColor, endColor.cgColor]
            gradient.startPoint = .init(x: 0, y: 1)
            gradient.endPoint = .init(x: 1, y: 0)
            gradient.shadowOffset = CGSize(width: 1, height: 2)
        }
    }
}
