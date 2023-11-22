//
//  AnimatedCollectionViewLayout.swift
//  BarakatWallet
//
//  Created by km1tj on 16/11/23.
//

import Foundation
import UIKit

public protocol LayoutAttributesAnimator {
    func animate(collectionView: UICollectionView, attributes: AnimatedCollectionViewLayoutAttributes)
}

/// A `UICollectionViewFlowLayout` subclass enables custom transitions between cells.
open class AnimatedCollectionViewLayout: UICollectionViewFlowLayout {
    
    /// The animator that would actually handle the transitions.
    open var animator: LayoutAttributesAnimator?
    
    /// Overrided so that we can store extra information in the layout attributes.
    open override class var layoutAttributesClass: AnyClass { return AnimatedCollectionViewLayoutAttributes.self }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        return attributes.compactMap { $0.copy() as? AnimatedCollectionViewLayoutAttributes }.map { self.transformLayoutAttributes($0) }
    }
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // We have to return true here so that the layout attributes would be recalculated
        // everytime we scroll the collection view.
        return true
    }
    
    /////// START - Added code additionally to fix content not displayed properly when rotating device.
    private var focusedIndexPath: IndexPath?

    override open func prepare(forAnimatedBoundsChange oldBounds: CGRect) {
        super.prepare(forAnimatedBoundsChange: oldBounds)
        focusedIndexPath = collectionView?.indexPathsForVisibleItems.first
    }

    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        guard let indexPath = focusedIndexPath
            , let attributes = layoutAttributesForItem(at: indexPath)
            , let collectionView = collectionView else {
                return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }
        return CGPoint(x: attributes.frame.origin.x - collectionView.contentInset.left,
                       y: attributes.frame.origin.y - collectionView.contentInset.top)
    }

    override open func finalizeAnimatedBoundsChange() {
        super.finalizeAnimatedBoundsChange()
        focusedIndexPath = nil
    }
    /////// END
    
    private func transformLayoutAttributes(_ attributes: AnimatedCollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        guard let collectionView = self.collectionView else { return attributes }
        
        let a = attributes
        
        /**
         The position for each cell is defined as the ratio of the distance between
         the center of the cell and the center of the collectionView and the collectionView width/height
         depending on the scroll direction. It can be negative if the cell is, for instance,
         on the left of the screen if you're scrolling horizontally.
         */
        
        let distance: CGFloat
        let itemOffset: CGFloat
        
        if scrollDirection == .horizontal {
            distance = collectionView.frame.width
            itemOffset = a.center.x - collectionView.contentOffset.x
            a.startOffset = (a.frame.origin.x - collectionView.contentOffset.x) / a.frame.width
            a.endOffset = (a.frame.origin.x - collectionView.contentOffset.x - collectionView.frame.width) / a.frame.width
        } else {
            distance = collectionView.frame.height
            itemOffset = a.center.y - collectionView.contentOffset.y
            a.startOffset = (a.frame.origin.y - collectionView.contentOffset.y) / a.frame.height
            a.endOffset = (a.frame.origin.y - collectionView.contentOffset.y - collectionView.frame.height) / a.frame.height
        }
        
        a.scrollDirection = scrollDirection
        a.middleOffset = itemOffset / distance - 0.5
        
        // Cache the contentView since we're going to use it a lot.
        if a.contentView == nil,
            let c = collectionView.cellForItem(at: attributes.indexPath)?.contentView {
            a.contentView = c
        }
        
        animator?.animate(collectionView: collectionView, attributes: a)
        
        return a
    }
}

/// A custom layout attributes that contains extra information.
open class AnimatedCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    public var contentView: UIView?
    public var scrollDirection: UICollectionView.ScrollDirection = .vertical
    
    /// The ratio of the distance between the start of the cell and the start of the collectionView and the height/width of the cell depending on the scrollDirection. It's 0 when the start of the cell aligns the start of the collectionView. It gets positive when the cell moves towards the scrolling direction (right/down) while getting negative when moves opposite.
    public var startOffset: CGFloat = 0
    
    /// The ratio of the distance between the center of the cell and the center of the collectionView and the height/width of the cell depending on the scrollDirection. It's 0 when the center of the cell aligns the center of the collectionView. It gets positive when the cell moves towards the scrolling direction (right/down) while getting negative when moves opposite.
    public var middleOffset: CGFloat = 0
    
    /// The ratio of the distance between the **start** of the cell and the end of the collectionView and the height/width of the cell depending on the scrollDirection. It's 0 when the **start** of the cell aligns the end of the collectionView. It gets positive when the cell moves towards the scrolling direction (right/down) while getting negative when moves opposite.
    public var endOffset: CGFloat = 0
    
    open override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! AnimatedCollectionViewLayoutAttributes
        copy.contentView = contentView
        copy.scrollDirection = scrollDirection
        copy.startOffset = startOffset
        copy.middleOffset = middleOffset
        copy.endOffset = endOffset
        return copy
    }
    
    open override func isEqual(_ object: Any?) -> Bool {
        guard let o = object as? AnimatedCollectionViewLayoutAttributes else { return false }
        
        return super.isEqual(o)
            && o.contentView == contentView
            && o.scrollDirection == scrollDirection
            && o.startOffset == startOffset
            && o.middleOffset == middleOffset
            && o.endOffset == endOffset
    }
}

public struct CubeAttributesAnimator: LayoutAttributesAnimator {
    /// The perspective that will be applied to the cells. Must be negative. -1/500 by default.
    /// Recommended range [-1/2000, -1/200].
    public var perspective: CGFloat
    
    /// The higher the angle is, the _steeper_ the cell would be when transforming.
    public var totalAngle: CGFloat
    
    public init(perspective: CGFloat = -1 / 500, totalAngle: CGFloat = .pi / 2) {
        self.perspective = perspective
        self.totalAngle = totalAngle
    }
    
    public func animate(collectionView: UICollectionView, attributes: AnimatedCollectionViewLayoutAttributes) {
        let position = attributes.middleOffset
        if abs(position) >= 1 {
            attributes.contentView?.layer.transform = CATransform3DIdentity
        } else if attributes.scrollDirection == .horizontal {
            let rotateAngle = totalAngle * position
            var transform = CATransform3DIdentity
            transform.m34 = perspective
            transform = CATransform3DRotate(transform, rotateAngle, 0, 1, 0)
            /* Handling collectionView's contentView transform animation
             * Setting contentView's subview's first which is scrollView UserInteractionEnabled = false
             * Then checking the completion status. If false then again setting UserInteractionEnabled = false
             * Otherwise setting UserInteractionEnabled = true.
             * Until animation completes, UIView Animation completion block will be called continuously.
             * If animation completed will get status value as true otherwise false
             */
            UIView.animate(withDuration: 0.3, animations: {
                attributes.contentView?.subviews.first?.isUserInteractionEnabled = false
                attributes.contentView?.layer.transform = transform
            }) {
                attributes.contentView?.subviews.first?.isUserInteractionEnabled = $0
            }
            attributes.contentView?.keepCenterAndApplyAnchorPoint(CGPoint(x: position > 0 ? 0 : 1, y: 0.5))
        } else {
            let rotateAngle = totalAngle * position
            var transform = CATransform3DIdentity
            transform.m34 = perspective
            transform = CATransform3DRotate(transform, rotateAngle, -1, 0, 0)
            /* Handling collectionView's contentView transform animation
             * Setting contentView's subview's first which is scrollView UserInteractionEnabled = false
             * Then checking the completion status. If false then again setting UserInteractionEnabled = false
             * Otherwise setting UserInteractionEnabled = true.
             * Until animation completes, UIView Animation completion block will be called continuously.
             * If animation completed will get status value as true otherwise false
             */
            UIView.animate(withDuration: 0.3, animations: {
                attributes.contentView?.subviews.first?.isUserInteractionEnabled = false
                attributes.contentView?.layer.transform = transform
            }) {
                attributes.contentView?.subviews.first?.isUserInteractionEnabled = $0
            }
            attributes.contentView?.keepCenterAndApplyAnchorPoint(CGPoint(x: 0.5, y: position > 0 ? 0 : 1))
        }
    }
}

extension UIView {
    func keepCenterAndApplyAnchorPoint(_ point: CGPoint) {
        guard layer.anchorPoint != point else { return }
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        var c = layer.position
        c.x -= oldPoint.x
        c.x += newPoint.x
        c.y -= oldPoint.y
        c.y += newPoint.y
        layer.position = c
        layer.anchorPoint = point
    }
}
extension Int {
    var toFloat: CGFloat {
        return CGFloat(self)
    }
}
extension Array {
     func sortedArrayByPosition() -> [Element] {
        return sorted(by: { (obj1 : Element, obj2 : Element) -> Bool in
            
            let view1 = obj1 as! UIView
            let view2 = obj2 as! UIView
            
            let x1 = view1.frame.minX
            let y1 = view1.frame.minY
            let x2 = view2.frame.minX
            let y2 = view2.frame.minY
            
            if y1 != y2 {
                return y1 < y2
            } else {
                return x1 < x2
            }
        })
    }
}
extension UIView {
    var width: CGFloat {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.layoutFrame.width
        }
        return frame.width
    }
    var height: CGFloat {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.layoutFrame.height
        }
        return frame.height
    }
}
