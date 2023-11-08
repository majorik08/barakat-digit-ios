//
//  PassCodeDotView.swift
//  BarakatWallet
//
//  Created by km1tj on 22/10/23.
//

import Foundation
import UIKit

internal extension UIBezierPath {
    convenience init(circleWithCenter center: CGPoint, radius: CGFloat, lineWidth: CGFloat) {
        self.init(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2.0 * CGFloat(Double.pi), clockwise: false)
        self.lineWidth = lineWidth
    }
}

open class PasswordDotView: UIView {
    
    open var inputDotCount = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    open var totalDotCount = 6 {
        didSet {
            setNeedsDisplay()
        }
    }
    open var strokeColor = UIColor.darkGray {
        didSet {
            setNeedsDisplay()
        }
    }
    open var fillColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    fileprivate var radius: CGFloat = 6
    fileprivate let spacingRatio: CGFloat = 2
    fileprivate let borderWidthRatio: CGFloat = 1 / 5
    fileprivate(set) open var isFull = false
    fileprivate var shakeCount = 0
    fileprivate var direction = false
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        isFull = (inputDotCount == totalDotCount)
        strokeColor.setStroke()
        fillColor.setFill()
        let isOdd = (totalDotCount % 2) != 0
        let positions = getDotPositions(isOdd)
        let borderWidth = radius * borderWidthRatio
        for (index, position) in positions.enumerated() {
            if index < inputDotCount {
                let pathToFill = UIBezierPath(circleWithCenter: position, radius: (radius + borderWidth / 2), lineWidth: borderWidth)
                pathToFill.fill()
            } else {
                let pathToStroke = UIBezierPath(circleWithCenter: position, radius: radius, lineWidth: borderWidth)
                pathToStroke.stroke()
            }
        }
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.updateRadius()
        setNeedsDisplay()
    }
    
    func updateRadius() {
        let width = bounds.width
        let height = bounds.height
        radius = height / 2 - height / 2 * borderWidthRatio
        let spacing = radius * spacingRatio
        let count = CGFloat(totalDotCount)
        let spaceCount = count - 1
        if (count * radius * 2 + spaceCount * spacing > width) {
            radius = floor((width / (count + spaceCount)) / 2)
        } else {
            radius = floor(height / 2);
        }
        radius = radius - radius * borderWidthRatio
    }

    func getDotPositions(_ isOdd: Bool) -> [CGPoint] {
        let centerX = bounds.midX
        let centerY = bounds.midY
        let spacing = radius * spacingRatio
        let middleIndex = isOdd ? (totalDotCount + 1) / 2 : (totalDotCount) / 2
        let offSet = isOdd ? 0 : -(radius + spacing / 2)
        let positions: [CGPoint] = (1...totalDotCount).map { index in
            let i = CGFloat(middleIndex - index)
            let positionX = centerX - (radius * 2 + spacing) * i + offSet
            return CGPoint(x: positionX, y: centerY)
        }
        return positions
    }
}
