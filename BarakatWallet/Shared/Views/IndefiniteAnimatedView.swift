//
//  IndefiniteAnimatedView.swift
//  BarakatWallet
//
//  Created by km1tj on 26/10/23.
//

import Foundation
import UIKit

class IndefiniteAnimatedView: UIView {
    var strokeThickness: CGFloat = 2
    var radius: CGFloat = 18
    var strokeColor: UIColor? = Theme.current.tintColor
    var indefiniteAnimatedLayer: CAShapeLayer? = nil
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if let _ = newSuperview {
            self.layoutAnimatedLayer()
        } else {
            self.indefiniteAnimatedLayer?.removeFromSuperlayer()
            self.indefiniteAnimatedLayer = nil
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutAnimatedLayer()
    }
    
    func startAnimating() {
        self.layoutAnimatedLayer()
    }
    
    func stopAnimating() {
        self.indefiniteAnimatedLayer?.removeFromSuperlayer()
        self.indefiniteAnimatedLayer = nil
    }
    
    func layoutAnimatedLayer() {
        let layer = self.indefiniteAnimatedLayerGet()
        if layer.superlayer == nil {
            self.layer.addSublayer(layer)
        }
        let widthDiff = self.bounds.width - layer.bounds.width
        let heightDiff = self.bounds.height - layer.bounds.height
        layer.position = .init(x: self.bounds.width - layer.bounds.width / 2 - widthDiff / 2, y: self.bounds.height - layer.bounds.height / 2 - heightDiff / 2)
    }
    
    func setFrame(frame: CGRect) {
        if !frame.equalTo(super.frame) {
            super.frame = frame
            if self.superview != nil {
                self.layoutAnimatedLayer()
            }
        }
    }
    
    func setRadius(radius: CGFloat) {
        if self.radius != radius {
            self.radius = radius
            self.indefiniteAnimatedLayer?.removeFromSuperlayer()
            self.indefiniteAnimatedLayer = nil
            if self.superview != nil {
                self.layoutAnimatedLayer()
            }
        }
    }
    
    func setStrokeColor(strokeColor: UIColor?) {
        self.strokeColor = strokeColor
        self.indefiniteAnimatedLayer?.strokeColor = strokeColor?.cgColor
    }
    
    func setStrokeThickness(strokeThickness: CGFloat) {
        self.strokeThickness = strokeThickness
        self.indefiniteAnimatedLayer?.lineWidth = strokeThickness
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return .init(width: (self.radius + self.strokeThickness / 2 + 5) * 2, height: (self.radius + self.strokeThickness / 2 + 5) * 2)
    }
    
    func indefiniteAnimatedLayerGet() -> CAShapeLayer {
        if self.indefiniteAnimatedLayer == nil {
            let arcCenter = CGPoint(x: self.radius + self.strokeThickness / 2 + 5, y: self.radius + self.strokeThickness / 2 + 5)
            let smoothedPath = UIBezierPath(arcCenter: arcCenter, radius: self.radius, startAngle: Double.pi * 3 / 2, endAngle: Double.pi / 2 + Double.pi * 5, clockwise: true)
            self.indefiniteAnimatedLayer = CAShapeLayer(layer: self.layer)
            self.indefiniteAnimatedLayer?.contentsScale = UIScreen.main.scale
            self.indefiniteAnimatedLayer?.frame = .init(x: 0, y: 0, width: arcCenter.x * 2, height: arcCenter.y * 2)
            self.indefiniteAnimatedLayer?.fillColor = UIColor.clear.cgColor
            self.indefiniteAnimatedLayer?.strokeColor = self.strokeColor?.cgColor
            self.indefiniteAnimatedLayer?.lineWidth = self.strokeThickness
            self.indefiniteAnimatedLayer?.lineCap = CAShapeLayerLineCap.round
            self.indefiniteAnimatedLayer?.lineJoin = CAShapeLayerLineJoin.bevel
            self.indefiniteAnimatedLayer?.path = smoothedPath.cgPath
            
            let maskLayer = CALayer(layer: self.layer)
            let image = UIImage(named: "angle-mask", in: .main, compatibleWith: nil)!
            maskLayer.contents = image.cgImage
            maskLayer.frame = self.indefiniteAnimatedLayer!.bounds
            self.indefiniteAnimatedLayer?.mask = maskLayer
            
            let linearCurve = CAMediaTimingFunction(name: .linear)
            let animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.fromValue = 0
            animation.toValue = Double.pi * 2
            animation.duration = 1
            animation.timingFunction = linearCurve
            animation.isRemovedOnCompletion = false
            animation.repeatCount = .infinity
            animation.fillMode = .forwards
            animation.autoreverses = false
            self.indefiniteAnimatedLayer?.mask?.add(animation, forKey: "rotate")
            
            let animationGroup = CAAnimationGroup()
            animationGroup.duration = 1
            animationGroup.repeatCount = .infinity
            animationGroup.isRemovedOnCompletion = false
            animationGroup.timingFunction = linearCurve
            
            let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
            strokeStartAnimation.fromValue = 0.015
            strokeStartAnimation.toValue = 0.515
            
            let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
            strokeStartAnimation.fromValue = 0.485
            strokeStartAnimation.toValue = 0.985
            
            animationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
            self.indefiniteAnimatedLayer?.add(animationGroup, forKey: "progress")
        }
        return self.indefiniteAnimatedLayer!
    }
}

class InfoProgress: UIView {
    
    let progressBar: IndefiniteAnimatedView = {
        let view = IndefiniteAnimatedView(frame: CGRect.init(x: 0, y: 0, width: 32, height: 32))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.medium(size: 17)
        view.textColor = Theme.current.primaryTextColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let infoLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.regular(size: 16)
        view.textColor = Theme.current.primaryTextColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var stackView: UIStackView!
    
    init(text: String, info: String?) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.addSubview(self.progressBar)
        self.addSubview(self.titleLabel)
        self.addSubview(self.infoLabel)
        self.stackView = UIStackView(arrangedSubviews: [self.titleLabel, self.infoLabel])
        self.stackView.axis = .vertical
        self.stackView.alignment = .fill
        self.stackView.distribution = .fill
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.progressBar.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.progressBar.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.progressBar.heightAnchor.constraint(equalToConstant: 32),
            self.progressBar.widthAnchor.constraint(equalToConstant: 32),
            self.stackView.leftAnchor.constraint(equalTo: self.progressBar.rightAnchor, constant: 16),
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
        self.titleLabel.text = text
        self.infoLabel.text = info
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: self.stackView.intrinsicContentSize.width + self.progressBar.intrinsicContentSize.width + 16, height: self.stackView.intrinsicContentSize.height)
    }
}
