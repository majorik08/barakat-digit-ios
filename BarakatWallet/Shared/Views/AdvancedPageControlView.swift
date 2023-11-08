//
//  AdvancedPageControlView.swift
//  BarakatWallet
//
//  Created by km1tj on 22/10/23.
//

import Foundation
import UIKit

public func addColor(_ color1: UIColor, with color2: UIColor) -> UIColor {
    var (r1, g1, b1, a1) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
    var (r2, g2, b2, a2) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))

    color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
    color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

    // add the components, but don't let them go above 1.0
    return UIColor(red: min(r1 + r2, 1), green: min(g1 + g2, 1), blue: min(b1 + b2, 1), alpha: (a1 + a2) / 2)
}

public func multiplyColor(_ color: UIColor, by multiplier: CGFloat) -> UIColor {
    var (r, g, b, a) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
    color.getRed(&r, green: &g, blue: &b, alpha: &a)
    return UIColor(red: r * multiplier, green: g * multiplier, blue: b * multiplier, alpha: a)
}

public func + (color1: UIColor, color2: UIColor) -> UIColor {
    return addColor(color1, with: color2)
}

public func * (color: UIColor, multiplier: Double) -> UIColor {
    return multiplyColor(color, by: CGFloat(multiplier))
}

public protocol AdvancedPageControlDraw {
    var currentItem: CGFloat { get set }
    var size: CGFloat { get set }

    var numberOfPages: Int { get set }
    func draw(_ rect: CGRect)
}

public class AdvancedPageControlView: UIView {
    
    var animDuration = 0.2
    private var mustGoCurrentItem: CGFloat = 0
    private var previuscurrentItem: CGFloat = 0
    private var displayLink: CADisplayLink?
    private var startTime = 0.0

    public var numberOfPages: Int { get { return drawer.numberOfPages } set(val) {
        setNeedsDisplay()
        drawer.numberOfPages = val
    }}

    public var drawer: AdvancedPageControlDraw = ExtendedDotDrawer()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
    
    public func setPageOffset(_ offset: CGFloat) {
        drawer.currentItem = CGFloat(offset)
        setNeedsDisplay()
    }

    public func setPage(_ index: Int) {
        if mustGoCurrentItem != CGFloat(index) {
            previuscurrentItem = round(drawer.currentItem)
            self.mustGoCurrentItem = CGFloat(index)
            startDisplayLink()
        }
    }

    override public var intrinsicContentSize: CGSize {
        return CGSize(width: self.drawer.size, height: self.drawer.size + 16)
    }

    override public func draw(_ rect: CGRect) {
        drawer.draw(rect)
    }

    private func startDisplayLink() {
        stopDisplayLink() // make sure to stop a previous running display link
        startTime = Date.timeIntervalSinceReferenceDate // reset start time
        let displayLink = CADisplayLink(
            target: self, selector: #selector(displayLinkDidFire)
        )
        displayLink.add(to: .current, forMode: .common)
        self.displayLink = displayLink
    }

    @objc private func displayLinkDidFire(_: CADisplayLink) {
        var elapsed = Date.timeIntervalSinceReferenceDate - startTime

        if elapsed > animDuration {
            stopDisplayLink()
            elapsed = animDuration // clamp the elapsed time to the anim length
        }
        let progress = CGFloat(elapsed / animDuration)

        let sign = mustGoCurrentItem - previuscurrentItem

        drawer.currentItem = CGFloat(progress * sign + previuscurrentItem)

        setNeedsDisplay()
    }

    // invalidate display link if it's non-nil, then set to nil
    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
}

public class AdvancedPageControlDrawerParentWithIndicator: AdvancedPageControlDrawerParent {
    var indicatorBorderColor: UIColor
    var indicatorBorderWidth: CGFloat
    var indicatorColor: UIColor
    public init(numberOfPages: Int? = 5,
                height: CGFloat? = 8,
                width: CGFloat? = 8,
                space: CGFloat? = 8,
                raduis: CGFloat? = 4,
                currentItem: CGFloat? = 0,
                indicatorColor: UIColor? = .white,
                dotsColor: UIColor? = UIColor.lightGray,
                isBordered: Bool = false,
                borderColor: UIColor = .white,
                borderWidth: CGFloat = 1,
                indicatorBorderColor: UIColor = .white,
                indicatorBorderWidth: CGFloat = 2)
    {
        self.indicatorBorderColor = indicatorBorderColor
        self.indicatorBorderWidth = indicatorBorderWidth
        self.indicatorColor = indicatorColor!
        super.init(numberOfPages: numberOfPages,
                   height: height,
                   width: width,
                   space: space,
                   raduis: raduis,
                   currentItem: currentItem,
                   dotsColor: dotsColor,
                   isBordered: isBordered,
                   borderColor: borderColor,
                   borderWidth: borderWidth)
    }
}

public class AdvancedPageControlDrawerParent {
    public var numberOfPages: Int
    public var size: CGFloat
    public var currentItem: CGFloat
    public var items = [Int]()
    var width: CGFloat
    var space: CGFloat
    var radius: CGFloat
    var dotsColor: UIColor
    var isBordered: Bool
    var borderColor: UIColor
    var borderWidth: CGFloat

    public init(numberOfPages: Int? = 5,
                height: CGFloat? = 8,
                width: CGFloat? = 8,
                space: CGFloat? = 8,
                raduis: CGFloat? = 4,
                currentItem: CGFloat? = 0,
                dotsColor: UIColor? = UIColor.lightGray,
                isBordered: Bool = false,
                borderColor: UIColor = .white,
                borderWidth: CGFloat = 1)
    {
        self.numberOfPages = numberOfPages!
        self.space = space!
        radius = raduis!
        self.currentItem = currentItem!
        self.dotsColor = dotsColor!
        self.width = width!
        size = height!
        self.isBordered = isBordered
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }

    func getScaleFactor(currentItem: CGFloat, ratio: CGFloat) -> CGFloat {
        let scale = currentItem - floor(currentItem)
        let scaleFactor = (scale > 0.5 ? 0.5 - (scale - 0.5) : scale) * ratio
        return scaleFactor
    }

    func getCenteredXPosition(_ rect: CGRect, itemPos: CGFloat, dotSize: CGFloat, space: CGFloat, numberOfPages: Int) -> CGFloat {
        let individualDotPos = (itemPos * (dotSize + space))
        let halfViewWidth = (rect.width / 2)
        let halfAlldotsWidthWithSpaces = ((CGFloat(numberOfPages) * (dotSize + (space - 1))) / 2.0)
        return individualDotPos - halfAlldotsWidthWithSpaces + halfViewWidth
    }

    func getCenteredYPosition(_ rect: CGRect, dotSize: CGFloat) -> CGFloat {
        let halfViewHeight = (rect.size.height / 2)
        let halfDotSize = (dotSize / 2)
        let centeredYPosition = halfViewHeight - halfDotSize
        return centeredYPosition
    }

    func drawItem(_ rect: CGRect, raduis: CGFloat, color: UIColor, borderWidth: CGFloat = 0, borderColor: UIColor = .clear, index _: Int = 0) {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: raduis)
        path.lineWidth = borderWidth
        borderColor.setStroke()
        path.stroke()
        color.setFill()
        path.fill()
    }
}

public class ExtendedDotDrawer: AdvancedPageControlDrawerParentWithIndicator, AdvancedPageControlDraw {
    
    public func draw(_ rect: CGRect) {
        drawIndicators(rect)
        drawCurrentItem(rect)
    }
    
    func drawIndicators(_ rect: CGRect) {
        let step: CGFloat = (space + width)
        for i in 0 ... numberOfPages {
            if i != Int(currentItem + 1), i != Int(currentItem) {
                var newX: CGFloat = 0
                var newY: CGFloat = 0
                var newHeight: CGFloat = 0
                var newWidth: CGFloat = 0
                let progress = currentItem - floor(currentItem)
                var dotColor = dotsColor
                if i == Int(currentItem + 2) {
                    dotColor = (dotsColor * Double(1 - progress)) + (indicatorColor * Double(progress))
                    let centeredYPosition = getCenteredYPosition(rect, dotSize: size)
                    let y = rect.origin.y + centeredYPosition
                    let currPosProgress = currentItem - floor(currentItem)
                    let curPos = floor(currentItem + 2) - currPosProgress
                    let x = getCenteredXPosition(rect, itemPos: curPos, dotSize: width, space: space, numberOfPages: numberOfPages + 1)
                    let halfMovementRatio = 1 - currPosProgress
                    // reverse the scale value
                    let scale = step - (halfMovementRatio * step)
                    newHeight = size
                    newWidth = width + scale
                    newX = rect.origin.x + x
                    newY = y
                } else {
                    let centeredYPosition = getCenteredYPosition(rect, dotSize: size)
                    let y = rect.origin.y + centeredYPosition
                    let x = getCenteredXPosition(rect, itemPos: CGFloat(i), dotSize: width, space: space, numberOfPages: numberOfPages + 1)
                    newHeight = size
                    newWidth = width
                    newX = rect.origin.x + x
                    newY = y
                }
                drawItem(CGRect(x: newX, y: newY, width: newWidth, height: newHeight), raduis: radius, color: dotColor, borderWidth: borderWidth, borderColor: borderColor)
            }
        }
    }
    
    fileprivate func drawCurrentItem(_ rect: CGRect) {
        let progress = currentItem - floor(currentItem)
        let color = (dotsColor * Double(progress)) + (indicatorColor * Double(1 - progress))
        if currentItem >= 0 {
            let step: CGFloat = (space + width)
            let centeredYPosition = getCenteredYPosition(rect, dotSize: size)
            let y = rect.origin.y + centeredYPosition
            let currPosProgress = currentItem - floor(currentItem)
            let steadyPosition = floor(currentItem)
            let x = getCenteredXPosition(rect, itemPos: steadyPosition, dotSize: width, space: space, numberOfPages: numberOfPages + 1)
            let halfMovementRatio = 1 - currPosProgress
            let desiredWidth = width + (halfMovementRatio * step)
            let desiredX = rect.origin.x + x
            let rect = CGRect(x: desiredX, y: y, width: desiredWidth, height: size)
            drawItem(rect, raduis: radius, color: color, borderWidth: borderWidth, borderColor: borderColor)
        }
    }
}
