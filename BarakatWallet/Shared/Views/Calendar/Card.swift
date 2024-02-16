//
//  Card.swift
//  BarakatWallet
//
//  Created by km1tj on 23/11/23.
//

import Foundation
import UIKit

/// Card view
open class Card: UIView, UIGestureRecognizerDelegate {

    public typealias TapHandler = () -> Void

    // MARK: - Variables

    /// Type of animation when tap
    open var animation: Animation?

    /// The blur radius (in points) used to render the Card’s shadow. Animatable.
    open var shadowRadius: CGFloat {
        get {
            self.layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
        }
    }

    /// The color of the Card’s shadow. Animatable.
    open var shadowColor: UIColor? {
        get {
            if let shadowColor = self.layer.shadowColor {
                return UIColor(cgColor: shadowColor)
            }
            return nil
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }

    /// The offset (in points) of the Card’s shadow. Animatable.
    open var shadowOffset: CGSize {
        get {
            self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }

    /// The opacity of the Card’s shadow. Animatable.
    open var shadowOpacity: Float {
        get {
            self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }

    /// The radius to use when drawing rounded corners for the layer’s background.
    open var cornerRadius: CGFloat {
        get {
            self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.containerView.layer.cornerRadius = newValue
        }
    }

    public let containerView: UIView = .init()

    /// Tap callback
    public var tapHandler: TapHandler?
    public var tapBeginHandler: TapHandler?
    public var forwardTouchesToSuperview = true

    private var isTouched = false
    private let recognizer = UITapGestureRecognizer()

    // MARK: - Overriding

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }

    // MARK: - Configurations

    private func configure() {
        self.layer.masksToBounds = false
        if #available(iOS 13.0, *) {
            self.layer.cornerCurve = .continuous
            self.containerView.layer.cornerCurve = .continuous
        }
        self.clipsToBounds = false
        self.isExclusiveTouch = true
        self.isUserInteractionEnabled = true
        self.configureRecognizer()
        self.configureContainer()
        self.moveSubviews()
    }

    private func configureRecognizer() {
        self.recognizer.delaysTouchesBegan = false
        self.recognizer.delegate = self
        self.recognizer.cancelsTouchesInView = false
        self.addGestureRecognizer(self.recognizer)
    }

    private func configureContainer() {
        self.containerView.clipsToBounds = true
        self.containerView.backgroundColor = .clear
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.containerView)

        NSLayoutConstraint.activate([
            .init(
                item: self.containerView,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: self,
                attribute: .bottom,
                multiplier: 1,
                constant: 0
            ),
            .init(item: self.containerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            .init(
                item: self.containerView,
                attribute: .leading,
                relatedBy: .equal,
                toItem: self,
                attribute: .leading,
                multiplier: 1,
                constant: 0
            ),
            .init(
                item: self.containerView,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: self,
                attribute: .trailing,
                multiplier: 1,
                constant: 0
            )
        ])
    }

    private func moveSubviews() {
        self.subviews
            .filter({ $0 != self.containerView })
            .forEach(self.containerView.addSubview)
    }

    // MARK: - Animations

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isTouched = true
        self.tapBeginHandler?()
        self.animation?.animationBlock(self, false)
        if self.forwardTouchesToSuperview {
            super.touchesBegan(touches, with: event)
        }
    }

    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first, !self.containerView.frame.contains(touch.location(in: self.containerView)) {
            self.resetAnimation(handler: nil)
        }
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resetAnimation(handler: self.tapHandler)
        super.touchesEnded(touches, with: event)
    }

    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resetAnimation(handler: nil)
        super.touchesCancelled(touches, with: event)
    }

    private func resetAnimation(handler: Card.TapHandler?) {

        defer {
            self.isTouched = false
        }

        guard self.isTouched else { return }

        guard let animation = self.animation else {
            handler?()
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            handler?()
        })
        animation.animationBlock(self, true)

    }
}

public extension Card {

    /// Card animation
    class Animation {

        /// Animation closure
        public typealias Closure = (_ card: Card, _ isReverced: Bool) -> Void

        internal var animationBlock: Closure

        fileprivate init(_ animationBlock: @escaping Closure) {
            self.animationBlock = animationBlock
        }

    }

}

// MARK: - Default animations

public extension Card.Animation {

    /// Zoom animation for Card
    ///
    /// - Parameters:
    ///   - scale: Card X & Y scale
    ///   - duration: The total duration of the animations, measured in seconds. If you specify a negative value or 0, the changes are made without animating them. **Default is 0.35**.
    ///   - damping: The damping ratio for the spring animation as it approaches its quiescent state. To smoothly decelerate the animation without oscillation, use a value of 1. Employ a damping ratio closer to zero to increase oscillation. **Default is 1.0**.
    ///   - velocity: The initial spring velocity. For smooth start to the animation, match this value to the view’s velocity as it was prior to attachment. Default is **1.5**.
    /// - Returns: Animation object
    static func zoom(
        to scale: CGFloat,
        duration: TimeInterval = 0.35,
        damping: CGFloat = 1,
        velocity: CGFloat = 1.5
    ) -> Card.Animation {

        Card.Animation({ card, isReverced in
            UIView.animate(
                withDuration: duration,
                delay: isReverced ? 0.1 : 0,
                usingSpringWithDamping: damping,
                initialSpringVelocity: velocity,
                options: [.beginFromCurrentState],
                animations: {
                    card.transform = isReverced
                        ? .identity
                        : .init(scaleX: scale, y: scale)
                }
            )
        })

    }

    /// Fade animation for Card
    ///
    /// - Parameters:
    ///   - alpha: The value of this property is a floating-point number in the range 0.0 to 1.0, where 0.0 represents totally transparent and 1.0 represents totally opaque.
    ///   - duration: The total duration of the animations, measured in seconds. If you specify a negative value or 0, the changes are made without animating them. Default value is 0.1
    /// - Returns: Animation object
    static func fade(to alpha: CGFloat, duration: TimeInterval = 0.15) -> Card.Animation {
        Card.Animation({ card, isReverced in
            UIView.animate(withDuration: duration, delay: isReverced ? 0.05 : 0, options: [.beginFromCurrentState], animations: {
                card.alpha = isReverced ? 1 : alpha
            })
        })
    }

    /// Make custom Animation
    ///
    /// - Parameter animationBlock: Custom animation closure
    /// - Returns: Animation object
    static func custom(_ animationBlock: @escaping Card.Animation.Closure) -> Card.Animation {
        .init(animationBlock)
    }

    /// Zoom in Card to 1.05 scale
    static var zoomIn: Card.Animation { .zoom(to: 1.05) }

    /// Zoom out Card to 0.95 scale
    static var zoomOut: Card.Animation { .zoom(to: 0.95) }

    /// Fade out Card to 0.7 alpha
    static var highlight: Card.Animation { .fade(to: 0.7) }

}

public extension CALayer {

    func applyCardShadow(_ shadow: Card.Shadow) {
        self.shadowColor = shadow.color?.cgColor
        self.shadowOffset = shadow.offset
        self.shadowOpacity = shadow.opacity
        self.shadowRadius = shadow.radius
    }

}

public protocol CardShadowProtocol {
    var opacity: Float { get }
    var radius: CGFloat { get }
    var offset: CGSize { get }
    var color: UIColor? { get }
}

public extension Card {

    enum Shadow: CardShadowProtocol {

        case soft
        case large
        case medium
        case small

        public var opacity: Float {
            switch self {
            case .soft: return 0.08
            default: return 0.16
            }
        }

        public var radius: CGFloat {
            switch self {
            case .large: return 32
            case .medium,
                 .soft: return 16
            case .small: return 2
            }
        }

        public var offset: CGSize {
            switch self {
            case .small:
                return CGSize(width: 0, height: 2)
            case .medium,
                 .soft:
                return CGSize(width: 0, height: 8)
            case .large:
                return CGSize(width: 0, height: 16)
            }
        }

        public var color: UIColor? {
            UIColor(red: 30 / 255, green: 34 / 255, blue: 72 / 255, alpha: 1)
        }

    }

    func setShadow(_ shadow: Card.Shadow) {
        self.shadowColor = shadow.color
        self.shadowOffset = shadow.offset
        self.shadowRadius = shadow.radius
        self.shadowOpacity = shadow.opacity
    }

    func setShadow<T: CardShadowProtocol>(_ shadow: T) {
        self.shadowColor = shadow.color
        self.shadowOffset = shadow.offset
        self.shadowRadius = shadow.radius
        self.shadowOpacity = shadow.opacity
    }

    func setShadow(_ shadow: CardShadowProtocol) {
        self.shadowColor = shadow.color
        self.shadowOffset = shadow.offset
        self.shadowRadius = shadow.radius
        self.shadowOpacity = shadow.opacity
    }

}
