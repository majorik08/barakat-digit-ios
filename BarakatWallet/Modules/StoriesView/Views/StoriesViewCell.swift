//
//  StoriesViewCell.swift
//  BarakatWallet
//
//  Created by km1tj on 16/11/23.
//

import Foundation
import UIKit

class StoriesViewCell: UICollectionViewCell, UIScrollViewDelegate, UIGestureRecognizerDelegate, StoriesViewCellHeaderDelegate, RetryBtnDelegate {
 
    fileprivate let snapViewTagIndicator: Int = 8
    
    public weak var delegate: StoryPreviewProtocol? {
        didSet { self.storyHeaderView.delegate = self }
    }
    public let scrollview: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        sv.isScrollEnabled = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    private lazy var storyHeaderView: StoriesViewCellHeader = {
        let v = StoriesViewCellHeader()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private lazy var longPress_gesture: UILongPressGestureRecognizer = {
        let lp = UILongPressGestureRecognizer.init(target: self, action: #selector(didLongPress(_:)))
        lp.minimumPressDuration = 0.2
        lp.delegate = self
        return lp
    }()
    private lazy var tap_gesture: UITapGestureRecognizer = {
        let tg = UITapGestureRecognizer(target: self, action: #selector(didTapSnap(_:)))
        tg.cancelsTouchesInView = false;
        tg.numberOfTapsRequired = 1
        tg.delegate = self
        return tg
    }()
    var retryBtn: IGRetryLoaderButton!
    private var previousSnapIndex: Int {
        return self.snapIndex - 1
    }
    private var snapViewXPos: CGFloat {
        return (self.snapIndex == 0) ? 0 : self.scrollview.subviews[self.previousSnapIndex].frame.maxX
    }
    public var getSnapIndex: Int {
        return self.snapIndex
    }
    public var snapIndex: Int = 0 {
        didSet {
            self.scrollview.isUserInteractionEnabled = true
            switch direction {
            case .forward:
                if self.snapIndex < self.story?.snaps.count ?? 0 {
                    if let snap = self.story?.snaps[self.snapIndex] {
                        if let snapView = getSnapview() {
                            self.startRequest(snapView: snapView, with: snap.source)
                        } else {
                            let snapView = createSnapView()
                            self.startRequest(snapView: snapView, with: snap.source)
                        }
                    }
                }
            case .backward:
                if self.snapIndex < self.story?.snaps.count ?? 0 {
                    if let snap = self.story?.snaps[self.snapIndex] {
                        if let snapView = self.getSnapview() {
                            self.startRequest(snapView: snapView, with: snap.source)
                        }
                    }
                }
            }
        }
    }
    public var story: StoriesItem? {
        didSet {
            self.storyHeaderView.story = story
        }
    }
    
    private var videoSnapIndex: Int = 0
    private var handpickedSnapIndex: Int = 0
    var longPressGestureState: UILongPressGestureRecognizer.State?
    var direction: SnapMovementDirectionState = .forward
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 14
        self.scrollview.frame = self.bounds
        self.scrollview.delegate = self
        self.scrollview.isPagingEnabled = true
        self.scrollview.backgroundColor = .lightGray
        self.scrollview.addGestureRecognizer(self.longPress_gesture)
        self.scrollview.addGestureRecognizer(self.tap_gesture)
        self.contentView.addSubview(self.scrollview)
        self.contentView.addSubview(self.storyHeaderView)
        NSLayoutConstraint.activate([
            self.scrollview.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.scrollview.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.scrollview.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.scrollview.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.scrollview.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 1.0),
            self.scrollview.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 1.0),
            self.storyHeaderView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.storyHeaderView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.storyHeaderView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.storyHeaderView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.direction = .forward
        self.clearScrollViewGarbages()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UISwipeGestureRecognizer {
            return true
        }
        return false
    }
    
    func didTapCloseButton() {
        self.delegate?.didTapCloseButton()
    }
    
    func retryButtonTapped() {
        self.retryRequest(view: self.retryBtn.superview!, with: self.retryBtn.contentURL!)
    }
    
    private func getSnapview() -> UIImageView? {
        if let imageView = self.scrollview.subviews.filter({$0.tag == self.snapIndex + self.snapViewTagIndicator}).first as? UIImageView {
            return imageView
        }
        return nil
    }
    
    private func createSnapView() -> UIImageView {
        let snapView = UIImageView()
        snapView.translatesAutoresizingMaskIntoConstraints = false
        snapView.tag = self.snapIndex + self.snapViewTagIndicator
        /**
         Delete if there is any snapview/videoview already present in that frame location. Because of snap delete functionality, snapview/videoview can occupy different frames(created in 2nd position(frame), when 1st postion snap gets deleted, it will move to first position) which leads to weird issues.
         - If only snapViews are there, it will not create any issues.
         - But if story contains both image and video snaps, there will be a chance in same position both snapView and videoView gets created.
         - That's why we need to remove if any snap exists on the same position.
         */
        self.scrollview.subviews.filter({$0.tag == self.snapIndex + self.snapViewTagIndicator}).first?.removeFromSuperview()
        self.scrollview.addSubview(snapView)
        NSLayoutConstraint.activate([
            snapView.leadingAnchor.constraint(equalTo: (self.snapIndex == 0) ? self.scrollview.leadingAnchor : self.scrollview.subviews[self.previousSnapIndex].trailingAnchor),
            snapView.topAnchor.constraint(equalTo: self.scrollview.topAnchor),
            snapView.widthAnchor.constraint(equalTo: self.scrollview.widthAnchor),
            snapView.heightAnchor.constraint(equalTo: self.scrollview.heightAnchor),
            self.scrollview.bottomAnchor.constraint(equalTo: snapView.bottomAnchor)
        ])
        if(self.snapIndex != 0) {
            NSLayoutConstraint.activate([
                snapView.leadingAnchor.constraint(equalTo: self.scrollview.leadingAnchor, constant: CGFloat(self.snapIndex) * self.scrollview.width)
            ])
        }
        return snapView
    }
    
    private func showRetryButton(with url: String, for snapView: UIImageView) {
        self.retryBtn = IGRetryLoaderButton.init(withURL: url)
        self.retryBtn.translatesAutoresizingMaskIntoConstraints = false
        self.retryBtn.delegate = self
        self.isUserInteractionEnabled = true
        snapView.addSubview(self.retryBtn)
        NSLayoutConstraint.activate([
            self.retryBtn.centerXAnchor.constraint(equalTo: snapView.centerXAnchor),
            self.retryBtn.centerYAnchor.constraint(equalTo: snapView.centerYAnchor)
        ])
    }
    
    private func startRequest(snapView: UIImageView, with url: String) {
        snapView.setImage(url: url) { result in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return}
                switch result {
                    case .success(_):
                        /// Start progressor only if handpickedSnapIndex matches with snapIndex and the requested image url should be matched with current snapIndex imageurl
                    if(strongSelf.handpickedSnapIndex == strongSelf.snapIndex && url == strongSelf.story!.snaps[strongSelf.snapIndex].source) {
                            strongSelf.startProgressors()
                    }
                    case .failure(_):
                        strongSelf.showRetryButton(with: url, for: snapView)
                }
            }
        }
    }
    
    //Used the below function for image retry option
    public func retryRequest(view: UIView, with url: String) {
        if let v = view as? UIImageView {
            v.removeRetryButton()
            self.startRequest(snapView: v, with: url)
        }
    }
    
    @objc private func didLongPress(_ sender: UILongPressGestureRecognizer) {
        longPressGestureState = sender.state
        if sender.state == .began ||  sender.state == .ended {
            if sender.state == .began {
                pauseEntireSnap()
            } else {
                resumeEntireSnap()
            }
        }
    }
    
    @objc private func didTapSnap(_ sender: UITapGestureRecognizer) {
        let touchLocation = sender.location(ofTouch: 0, in: self.scrollview)
        if let snapCount = self.story?.snaps.count {
            var n = self.snapIndex
            /*!
             * Based on the tap gesture(X) setting the direction to either forward or backward
             */
            if let _ = self.story?.snaps[n], self.getSnapview()?.image == nil {
                //Remove retry button if tap forward or backward if it exists
                if let snapView = self.getSnapview(), let btn = self.retryBtn, snapView.subviews.contains(btn) {
                    snapView.removeRetryButton()
                }
                self.fillupLastPlayedSnap(n)
            }
            if touchLocation.x < self.scrollview.contentOffset.x + (self.scrollview.frame.width/2) {
                self.direction = .backward
                if self.snapIndex >= 1 && self.snapIndex <= snapCount {
                    self.clearLastPlayedSnaps(n)
                    self.stopSnapProgressors(with: n)
                    n -= 1
                    self.resetSnapProgressors(with: n)
                    self.willMoveToPreviousOrNextSnap(n: n)
                } else {
                    self.delegate?.moveToPreviousStory()
                }
            } else {
                if self.snapIndex >= 0 && self.snapIndex <= snapCount {
                    //Stopping the current running progressors
                    self.stopSnapProgressors(with: n)
                    self.direction = .forward
                    n += 1
                    self.willMoveToPreviousOrNextSnap(n: n)
                }
            }
        }
    }
    
    @objc private func didEnterForeground() {
        if let _ = self.story?.snaps[self.snapIndex] {
            self.startSnapProgress(with: self.snapIndex)
        }
    }
    
    @objc private func didEnterBackground() {
        self.resetSnapProgressors(with: self.snapIndex)
    }
    
    @objc private func didCompleteProgress() {
        let n = self.snapIndex + 1
        if let count = self.story?.snaps.count {
            if n < count {
                //Move to next snap
                let x = n.toFloat * frame.width
                let offset = CGPoint(x: x,y: 0)
                self.scrollview.setContentOffset(offset, animated: false)
                self.story?.lastPlayedSnapIndex = n
                self.direction = .forward
                self.handpickedSnapIndex = n
                self.snapIndex = n
            } else {
                self.delegate?.didCompletePreview()
            }
        }
    }
    
    private func willMoveToPreviousOrNextSnap(n: Int) {
        if let count = self.story?.snaps.count {
            if n < count {
                //Move to next or previous snap based on index n
                let x = n.toFloat * frame.width
                let offset = CGPoint(x: x,y: 0)
                self.scrollview.setContentOffset(offset, animated: false)
                self.story?.lastPlayedSnapIndex = n
                self.handpickedSnapIndex = n
                self.snapIndex = n
            } else {
                self.delegate?.didCompletePreview()
            }
        }
    }
    
    private func fillUpMissingImageViews(_ sIndex: Int) {
        if sIndex != 0 {
            for i in 0..<sIndex {
                self.snapIndex = i
            }
            let xValue = sIndex.toFloat * self.scrollview.frame.width
            self.scrollview.contentOffset = CGPoint(x: xValue, y: 0)
        }
    }
    
    //Before progress view starts we have to fill the progressView
    private func fillupLastPlayedSnap(_ sIndex: Int) {
        if let holderView = self.getProgressIndicatorView(with: sIndex),
            let progressView = self.getProgressView(with: sIndex){
            progressView.widthConstraint?.isActive = false
            progressView.widthConstraint = progressView.widthAnchor.constraint(equalTo: holderView.widthAnchor, multiplier: 1.0)
            progressView.widthConstraint?.isActive = true
        }
    }
    
    private func fillupLastPlayedSnaps(_ sIndex: Int) {
        //Coz, we are ignoring the first.snap
        if sIndex != 0 {
            for i in 0..<sIndex {
                if let holderView = self.getProgressIndicatorView(with: i),
                    let progressView = self.getProgressView(with: i){
                    progressView.widthConstraint?.isActive = false
                    progressView.widthConstraint = progressView.widthAnchor.constraint(equalTo: holderView.widthAnchor, multiplier: 1.0)
                    progressView.widthConstraint?.isActive = true
                }
            }
        }
    }
    
    private func clearLastPlayedSnaps(_ sIndex: Int) {
        if let _ = self.getProgressIndicatorView(with: sIndex),
            let progressView = self.getProgressView(with: sIndex) {
            progressView.widthConstraint?.isActive = false
            progressView.widthConstraint = progressView.widthAnchor.constraint(equalToConstant: 0)
            progressView.widthConstraint?.isActive = true
        }
    }
    
    private func clearScrollViewGarbages() {
        self.scrollview.contentOffset = CGPoint(x: 0, y: 0)
        if self.scrollview.subviews.count > 0 {
            var i = 0 + self.snapViewTagIndicator
            var snapViews = [UIView]()
            self.scrollview.subviews.forEach({ (imageView) in
                if imageView.tag == i {
                    snapViews.append(imageView)
                    i += 1
                }
            })
            if snapViews.count > 0 {
                snapViews.forEach({ (view) in
                    view.removeFromSuperview()
                })
            }
        }
    }
    
    private func gearupTheProgressors() {
        if let holderView = self.getProgressIndicatorView(with: self.snapIndex),
           let progressView = self.getProgressView(with: self.snapIndex) {
            progressView.storyIdentifier = self.story?.id
            progressView.snapIndex = self.snapIndex
            DispatchQueue.main.async {
                progressView.start(with: 5.0, holderView: holderView, completion: {(identifier, snapIndex, isCancelledAbruptly) in
                    print("Completed snapindex: \(snapIndex)")
                    if isCancelledAbruptly == false {
                        self.didCompleteProgress()
                    }
                })
            }
        }
    }
    
    func startProgressors() {
        DispatchQueue.main.async {
            if self.scrollview.subviews.count > 0 {
                let imageView = self.scrollview.subviews.filter{v in v.tag == self.snapIndex + self.snapViewTagIndicator}.first as? UIImageView
                if imageView?.image != nil && self.story?.isCompletelyVisible == true {
                    self.gearupTheProgressors()
                }
            }
        }
    }
    
    func getProgressView(with index: Int) -> IGSnapProgressView? {
        let progressView = self.storyHeaderView.getProgressView
        if progressView.subviews.count > 0 {
            let pv = self.getProgressIndicatorView(with: index)?.subviews.first as? IGSnapProgressView
            guard let currentStory = self.story else {
                fatalError("story not found")
            }
            pv?.story = currentStory
            return pv
        }
        return nil
    }
    
    func getProgressIndicatorView(with index: Int) -> IGSnapProgressIndicatorView? {
        let progressView = storyHeaderView.getProgressView
        return progressView.subviews.filter({v in v.tag == index + progressIndicatorViewTag}).first as? IGSnapProgressIndicatorView ?? nil
    }
    
    func adjustPreviousSnapProgressorsWidth(with index: Int) {
        fillupLastPlayedSnaps(index)
    }
    
    public func willDisplayCellForZerothIndex(with sIndex: Int, handpickedSnapIndex: Int) {
        self.handpickedSnapIndex = handpickedSnapIndex
        self.story?.isCompletelyVisible = true
        self.willDisplayCell(with: handpickedSnapIndex)
    }
    
    public func willDisplayCell(with sIndex: Int) {
        //Todo:Make sure to move filling part and creating at one place
        //Clear the progressor subviews before the creating new set of progressors.
        self.storyHeaderView.clearTheProgressorSubviews()
        self.storyHeaderView.createSnapProgressors()
        self.fillUpMissingImageViews(sIndex)
        self.fillupLastPlayedSnaps(sIndex)
        self.snapIndex = sIndex
        //Remove the previous observors
        NotificationCenter.default.removeObserver(self)
        // Add the observer to handle application from background to foreground
        NotificationCenter.default.addObserver(self, selector: #selector(self.didEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    public func startSnapProgress(with sIndex: Int) {
        if let indicatorView = self.getProgressIndicatorView(with: sIndex),
            let pv = self.getProgressView(with: sIndex) {
            pv.start(with: 5.0, holderView: indicatorView, completion: { (identifier, snapIndex, isCancelledAbruptly) in
                if isCancelledAbruptly == false {
                    self.didCompleteProgress()
                }
            })
        }
    }
    
    public func pauseSnapProgressors(with sIndex: Int) {
        self.story?.isCompletelyVisible = false
        self.getProgressView(with: sIndex)?.pause()
    }
    
    public func stopSnapProgressors(with sIndex: Int) {
        self.getProgressView(with: sIndex)?.stop()
    }
    
    public func resetSnapProgressors(with sIndex: Int) {
        self.getProgressView(with: sIndex)?.reset()
    }

    public func didEndDisplayingCell() {
        
    }
    
    public func resumePreviousSnapProgress(with sIndex: Int) {
        self.getProgressView(with: sIndex)?.resume()
    }
    
    public func pauseEntireSnap() {
        let v = self.getProgressView(with: self.snapIndex)
        v?.pause()
    }
    
    public func resumeEntireSnap() {
        let v = self.getProgressView(with: self.snapIndex)
        v?.resume()
    }
}
