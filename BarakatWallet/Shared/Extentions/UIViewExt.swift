//
//  UIViewExt.swift
//  BarakatWallet
//
//  Created by km1tj on 05/10/23.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIView {
    convenience init(backgroundColor: UIColor) {
        self.init()
        self.backgroundColor = backgroundColor
    }
    
    func slideInFromLeft(duration: TimeInterval = 0.3) {
        let slideInFromLeftTransition = CATransition()
        slideInFromLeftTransition.type = CATransitionType.push
        slideInFromLeftTransition.subtype = CATransitionSubtype.fromRight
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        slideInFromLeftTransition.fillMode = CAMediaTimingFillMode.removed
        self.layer.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
    }
    
    func shakeAnimate() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat, thickness: CGFloat, color: UIColor) {
        let bounds = self.bounds
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSizeMake(radius, radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
        let frameLayer = CAShapeLayer()
        frameLayer.frame = bounds
        frameLayer.path = maskPath.cgPath
        frameLayer.strokeColor = color.cgColor
        frameLayer.lineWidth = thickness
        frameLayer.fillColor = nil
        self.layer.addSublayer(frameLayer)
    }
    
    func showProgressAddedTo(view: UIView, title: String? = nil, info: String? = nil) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .customView
        let alert = InfoProgress(text: title ?? "LOADING".localized, info: info)
        hud.customView = alert
        hud.backgroundView.style = .solidColor
        hud.backgroundView.blurEffectStyle = .extraLight
        hud.animationType = .zoomIn
        if view is UITableView || view is UICollectionView {
            hud.backgroundView.color = UIColor(white: 0.0, alpha: 0.2)
        } else {
            hud.backgroundView.color = UIColor(white: 0.0, alpha: 0.7)
        }
        hud.bezelView.style = .solidColor
        hud.bezelView.color = Theme.current.navigationColor
    }
    
    func hideProgressFrom(view: UIView) {
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    func successProgress(text: String = "") {
        let hud = MBProgressHUD.forView(self)
        hud?.customView = UIImageView(image: UIImage(named: "checkmark", in: .main, compatibleWith: nil))
        hud?.mode = .customView
        hud?.label.text = text
        hud?.hide(animated: true, afterDelay: 1)
    }
    
    func hideProgressView() {
        self.hideProgressFrom(view: self)
    }
    
    func showProgressView(title: String? = nil, info: String? = nil) {
        self.showProgressAddedTo(view: self, title: title, info: info)
    }
}


extension CALayer {
    
    enum BorderSide {
        case top
        case right
        case bottom
        case left
        case notRight
        case notLeft
        case topAndBottom
        case all
    }
    
    enum Corner {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }
    
    func addBorder(side: BorderSide, thickness: CGFloat, color: CGColor, maskedCorners: CACornerMask? = nil) {
        var topWidth = frame.size.width; var bottomWidth = topWidth
        var leftHeight = frame.size.height; var rightHeight = leftHeight
        
        var topXOffset: CGFloat = 0; var bottomXOffset: CGFloat = 0
        var leftYOffset: CGFloat = 0; var rightYOffset: CGFloat = 0
        
        // Draw the corners and set side offsets
        switch maskedCorners {
        case [.layerMinXMinYCorner, .layerMaxXMinYCorner]: // Top only
            addCorner(.topLeft, thickness: thickness, color: color)
            addCorner(.topRight, thickness: thickness, color: color)
            topWidth -= cornerRadius*2
            leftHeight -= cornerRadius; rightHeight -= cornerRadius
            topXOffset = cornerRadius; leftYOffset = cornerRadius; rightYOffset = cornerRadius
            
        case [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]: // Bottom only
            addCorner(.bottomLeft, thickness: thickness, color: color)
            addCorner(.bottomRight, thickness: thickness, color: color)
            bottomWidth -= cornerRadius*2
            leftHeight -= cornerRadius; rightHeight -= cornerRadius
            bottomXOffset = cornerRadius
            
        case [.layerMinXMinYCorner, .layerMinXMaxYCorner]: // Left only
            addCorner(.topLeft, thickness: thickness, color: color)
            addCorner(.bottomLeft, thickness: thickness, color: color)
            topWidth -= cornerRadius; bottomWidth -= cornerRadius
            leftHeight -= cornerRadius*2
            leftYOffset = cornerRadius; topXOffset = cornerRadius; bottomXOffset = cornerRadius;
            
        case [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]: // Right only
            addCorner(.topRight, thickness: thickness, color: color)
            addCorner(.bottomRight, thickness: thickness, color: color)
            topWidth -= cornerRadius; bottomWidth -= cornerRadius
            rightHeight -= cornerRadius*2
            rightYOffset = cornerRadius
            
        case [.layerMaxXMinYCorner, .layerMaxXMaxYCorner,  // All
              .layerMinXMaxYCorner, .layerMinXMinYCorner]:
            addCorner(.topLeft, thickness: thickness, color: color)
            addCorner(.topRight, thickness: thickness, color: color)
            addCorner(.bottomLeft, thickness: thickness, color: color)
            addCorner(.bottomRight, thickness: thickness, color: color)
            topWidth -= cornerRadius*2; bottomWidth -= cornerRadius*2
            topXOffset = cornerRadius; bottomXOffset = cornerRadius
            leftHeight -= cornerRadius*2; rightHeight -= cornerRadius*2
            leftYOffset = cornerRadius; rightYOffset = cornerRadius
            
        default: break
        }
        
        // Draw the sides
        switch side {
        case .top:
            addLine(x: topXOffset, y: 0, width: topWidth, height: thickness, color: color)
            
        case .right:
            addLine(x: frame.size.width - thickness, y: rightYOffset, width: thickness, height: rightHeight, color: color)
            
        case .bottom:
            addLine(x: bottomXOffset, y: frame.size.height - thickness, width: bottomWidth, height: thickness, color: color)
            
        case .left:
            addLine(x: 0, y: leftYOffset, width: thickness, height: leftHeight, color: color)

        // Multiple Sides
        case .notRight:
            addLine(x: topXOffset, y: 0, width: topWidth, height: thickness, color: color)
            addLine(x: 0, y: leftYOffset, width: thickness, height: leftHeight, color: color)
            addLine(x: bottomXOffset, y: frame.size.height - thickness, width: bottomWidth, height: thickness, color: color)

        case .notLeft:
            addLine(x: topXOffset, y: 0, width: topWidth, height: thickness, color: color)
            addLine(x: frame.size.width - thickness, y: rightYOffset, width: thickness, height: rightHeight, color: color)
            addLine(x: bottomXOffset, y: frame.size.height - thickness, width: bottomWidth, height: thickness, color: color)

        case .topAndBottom:
            addLine(x: topXOffset, y: 0, width: topWidth, height: thickness, color: color)
            addLine(x: bottomXOffset, y: frame.size.height - thickness, width: bottomWidth, height: thickness, color: color)

        case .all:
            addLine(x: topXOffset, y: 0, width: topWidth, height: thickness, color: color)
            addLine(x: frame.size.width - thickness, y: rightYOffset, width: thickness, height: rightHeight, color: color)
            addLine(x: bottomXOffset, y: frame.size.height - thickness, width: bottomWidth, height: thickness, color: color)
            addLine(x: 0, y: leftYOffset, width: thickness, height: leftHeight, color: color)
        }
    }
    
    private func addLine(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: CGColor) {
        let border = CALayer()
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        border.backgroundColor = color
        addSublayer(border)
    }
    
    private func addCorner(_ corner: Corner, thickness: CGFloat, color: CGColor) {
        // Set default to top left
        let width = frame.size.width; let height = frame.size.height
        var x = cornerRadius
        var y = cornerRadius
        var startAngle: CGFloat = .pi; var endAngle: CGFloat = .pi*3/2
        
        switch corner {
        case .bottomLeft:
            y = height - cornerRadius
            startAngle = .pi/2; endAngle = .pi
            
        case .bottomRight:
            x = width - cornerRadius
            y = height - cornerRadius
            startAngle = 0; endAngle = .pi/2
            
        case .topRight:
            x = width - cornerRadius
            startAngle = .pi*3/2; endAngle = 0
            
        default: break
        }
        
        let cornerPath = UIBezierPath(arcCenter: CGPoint(x: x, y: y),
                                      radius: cornerRadius - thickness,
                                      startAngle: startAngle,
                                      endAngle: endAngle,
                                      clockwise: true)

        let cornerShape = CAShapeLayer()
        cornerShape.path = cornerPath.cgPath
        cornerShape.lineWidth = thickness
        cornerShape.strokeColor = color
        cornerShape.fillColor = nil
        addSublayer(cornerShape)
    }
}
