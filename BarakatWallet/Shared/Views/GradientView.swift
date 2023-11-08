//
//  GradientView.swift
//  BarakatWallet
//
//  Created by km1tj on 21/10/23.
//

import Foundation
import UIKit

public class GradientView: UIView {

    var startColor: UIColor? {
        didSet {
            updateGradient()
        }
    }
    var endColor: UIColor? {
        didSet {
            updateGradient()
        }
    }
    var radius: CGFloat = 0 {
        didSet {
            updateGradient()
        }
    }
    var startPoint: CGPoint = .init(x: 0, y: 1)
    var endPoint: CGPoint = .init(x: 1, y: 0)
   
    private var gradient: CAGradientLayer?
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        installGradient()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        installGradient()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.gradient?.frame = self.bounds
        self.updateGradient()
    }
    
    public override var frame: CGRect {
        didSet {
            self.gradient?.frame = self.bounds
            self.updateGradient()
        }
    }

    private func installGradient() {
        self.backgroundColor = .clear
        if let gradient = self.gradient {
            gradient.removeFromSuperlayer()
        }
        let gradient = self.createGradient()
        self.layer.addSublayer(gradient)
        self.gradient = gradient
    }

    func updateGradient() {
        if let gradient = self.gradient {
            let startColor = self.startColor ?? UIColor.clear
            let endColor = self.endColor ?? UIColor.clear
            gradient.cornerRadius = self.radius
            gradient.colors = [startColor.cgColor, endColor.cgColor]
            gradient.startPoint = self.startPoint
            gradient.endPoint = self.endPoint
        }
    }

    private func createGradient() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        return gradient
    }
}
