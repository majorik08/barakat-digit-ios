//
//  StoriesProgressView.swift
//  BarakatWallet
//
//  Created by km1tj on 16/11/23.
//

import Foundation
import UIKit

enum ProgressorState {
    case notStarted
    case paused
    case running
    case finished
}
protocol ViewAnimator {
    func start(with duration: TimeInterval, holderView: UIView, completion: @escaping (_ storyIdentifier: Int, _ snapIndex: Int, _ isCancelledAbruptly: Bool) -> Void)
    func resume()
    func pause()
    func stop()
    func reset()
}
final class IGSnapProgressView: UIView, ViewAnimator {
    public var storyIdentifier: Int?
    public var snapIndex: Int?
    public var story: StoriesItem!
    public var widthConstraint: NSLayoutConstraint?
    public var state: ProgressorState = .notStarted
}
final class IGSnapProgressIndicatorView: UIView {
    public var widthConstraint: NSLayoutConstraint?
    public var leftConstraiant: NSLayoutConstraint?
    public var rightConstraiant: NSLayoutConstraint?
}

extension ViewAnimator where Self: IGSnapProgressView {
    func start(with duration: TimeInterval, holderView: UIView, completion: @escaping (_ storyIdentifier: Int, _ snapIndex: Int, _ isCancelledAbruptly: Bool) -> Void) {
        // Modifying the existing widthConstraint and setting the width equalTo holderView's widthAchor
        self.state = .running
        self.widthConstraint?.isActive = false
        self.widthConstraint = self.widthAnchor.constraint(equalToConstant: 0)
        self.widthConstraint?.isActive = true
        self.widthConstraint?.constant = holderView.width
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: {[weak self] in
            if let strongSelf = self {
                strongSelf.superview?.layoutIfNeeded()
            }
        }) { [weak self] (finished) in
            self?.story.isCancelledAbruptly = !finished
            self?.state = .finished
            if finished == true {
                if let strongSelf = self {
                    return completion(strongSelf.storyIdentifier!, strongSelf.snapIndex!, strongSelf.story.isCancelledAbruptly)
                }
            } else {
                return completion(self?.storyIdentifier ?? -1, self?.snapIndex ?? 0, self?.story.isCancelledAbruptly ?? true)
            }
        }
    }
    func resume() {
        let pausedTime = self.layer.timeOffset
        self.layer.speed = 1.0
        self.layer.timeOffset = 0.0
        self.layer.beginTime = 0.0
        let timeSincePause = self.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        self.layer.beginTime = timeSincePause
        self.state = .running
    }
    func pause() {
        let pausedTime = self.layer.convertTime(CACurrentMediaTime(), from: nil)
        self.layer.speed = 0.0
        self.layer.timeOffset = pausedTime
        self.state = .paused
    }
    func stop() {
        self.resume()
        self.layer.removeAllAnimations()
        self.state = .finished
    }
    func reset() {
        self.state = .notStarted
        self.story.isCancelledAbruptly = true
        self.widthConstraint?.isActive = false
        self.widthConstraint = self.widthAnchor.constraint(equalToConstant: 0)
        self.widthConstraint?.isActive = true
    }
}
