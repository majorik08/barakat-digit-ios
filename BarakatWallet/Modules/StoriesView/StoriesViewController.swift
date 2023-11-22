//
//  StoriesViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 16/11/23.
//

import Foundation
import UIKit

protocol StoryPreviewProtocol: AnyObject {
    func didCompletePreview()
    func moveToPreviousStory()
    func didTapCloseButton()
}
enum SnapMovementDirectionState {
    case forward
    case backward
}

class StoriesViewController: BaseViewController, UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, StoryPreviewProtocol, UICollectionViewDelegateFlowLayout {
 
    public enum IGLayoutType {
        case cubic
        var animator: LayoutAttributesAnimator {
            switch self {
            case .cubic:return CubeAttributesAnimator(perspective: -1/100, totalAngle: .pi/12)
            }
        }
    }
    
    lazy var layoutAnimator: (LayoutAttributesAnimator, Bool, Int, Int) = (layoutType.animator, true, 1, 1)
    lazy var snapsCollectionViewFlowLayout: AnimatedCollectionViewLayout = {
        let flowLayout = AnimatedCollectionViewLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.animator = layoutAnimator.0
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        return flowLayout
    }()
    lazy var snapsCollectionView: UICollectionView! = {
        let cv = UICollectionView.init(frame: .zero, collectionViewLayout: self.snapsCollectionViewFlowLayout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.register(StoriesViewCell.self, forCellWithReuseIdentifier: "cell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isPagingEnabled = true
        cv.isPrefetchingEnabled = false
        cv.contentInset = .zero
        return cv
    }()
    private let dismissGesture: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer()
        gesture.direction = .down
        return gesture
    }()
    var layoutType: IGLayoutType
    let viewModel: StoriesViewModel
    private(set) var isTransitioning = false
    private(set) var currentIndexPath: IndexPath?
    private(set) var executeOnce = false
    private var nStoryIndex: Int = 0 //iteration(i+1)
    private var story_copy: StoriesItem?
    weak var coordinator: HomeCoordinator? = nil
    
    init(viewModel: StoriesViewModel) {
        self.viewModel = viewModel
        self.layoutType = .cubic
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        //self.modalPresentationCapturesStatusBarAppearance = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.view.addSubview(self.snapsCollectionView)
        NSLayoutConstraint.activate([
            self.snapsCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.snapsCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.snapsCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.snapsCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        self.snapsCollectionView.decelerationRate = .fast
        self.dismissGesture.delegate = self
        self.dismissGesture.addTarget(self, action: #selector(didSwipeDown(_:)))
        self.snapsCollectionView.addGestureRecognizer(self.dismissGesture)
    }
    
    @objc func didSwipeDown(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !self.executeOnce {
            DispatchQueue.main.async {
                self.snapsCollectionView.delegate = self
                self.snapsCollectionView.dataSource = self
                let indexPath = IndexPath(item: self.viewModel.handPickedStoryIndex, section: 0)
                self.snapsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                self.viewModel.handPickedStoryIndex = 0
                self.executeOnce = true
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.isTransitioning = true
        self.snapsCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func didCompletePreview() {
        let n = self.viewModel.handPickedStoryIndex + self.nStoryIndex + 1
        if n < self.viewModel.stories.count {
            //Move to next story
            self.story_copy = self.viewModel.stories[self.nStoryIndex+self.viewModel.handPickedStoryIndex]
            self.nStoryIndex = self.nStoryIndex + 1
            let nIndexPath = IndexPath.init(row: self.nStoryIndex, section: 0)
            //_view.snapsCollectionView.layer.speed = 0;
            self.snapsCollectionView.scrollToItem(at: nIndexPath, at: .right, animated: true)
            /**@Note:
             Here we are navigating to next snap explictly, So we need to handle the isCompletelyVisible. With help of this Bool variable we are requesting snap. Otherwise cell wont get Image as well as the Progress move :P
             */
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func moveToPreviousStory() {
        let n = self.nStoryIndex + 1
        if n <= self.viewModel.stories.count && n > 1 {
            self.story_copy = self.viewModel.stories[self.nStoryIndex + self.viewModel.handPickedStoryIndex]
            self.nStoryIndex = self.nStoryIndex - 1
            let nIndexPath = IndexPath.init(row: self.nStoryIndex, section: 0)
            self.snapsCollectionView.scrollToItem(at: nIndexPath, at: .left, animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func didTapCloseButton() {
        self.dismiss(animated: true, completion:nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StoriesViewCell
        let story = self.viewModel.stories[indexPath.item]
        cell.story = story
        cell.delegate = self
        self.currentIndexPath = indexPath
        self.nStoryIndex = indexPath.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? StoriesViewCell else { return }
        //Taking Previous(Visible) cell to store previous story
        let visibleCells = collectionView.visibleCells.sortedArrayByPosition()
        let visibleCell = visibleCells.first as? StoriesViewCell
        if let vCell = visibleCell {
            vCell.story?.isCompletelyVisible = false
            vCell.pauseSnapProgressors(with: (vCell.story?.lastPlayedSnapIndex)!)
            self.story_copy = vCell.story
        }
        //Prepare the setup for first time story launch
        if self.story_copy == nil {
            cell.willDisplayCellForZerothIndex(with: cell.story?.lastPlayedSnapIndex ?? 0, handpickedSnapIndex: self.viewModel.handPickedSnapIndex)
            return
        }
        if indexPath.item == self.nStoryIndex {
            let s = self.viewModel.stories[self.nStoryIndex + self.viewModel.handPickedStoryIndex]
            cell.willDisplayCell(with: s.lastPlayedSnapIndex)
        }
        /// Setting to 0, otherwise for next story snaps, it will consider the same previous story's handPickedSnapIndex. It will create issue in starting the snap progressors.
        self.viewModel.handPickedSnapIndex = 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let visibleCells = collectionView.visibleCells.sortedArrayByPosition()
        let visibleCell = visibleCells.first as? StoriesViewCell
        guard let vCell = visibleCell else { return }
        guard let vCellIndexPath = self.snapsCollectionView.indexPath(for: vCell) else { return }
        vCell.story?.isCompletelyVisible = true
        if vCell.story == self.story_copy {
            self.nStoryIndex = vCellIndexPath.item
            if vCell.longPressGestureState == nil {
                vCell.resumePreviousSnapProgress(with: (vCell.story?.lastPlayedSnapIndex)!)
            }
            vCell.longPressGestureState = nil
        } else {
            vCell.startProgressors()
        }
        if vCellIndexPath.item == self.nStoryIndex {
            vCell.didEndDisplayingCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /* During device rotation, invalidateLayout gets call to make cell width and height proper.
         * InvalidateLayout methods call this UICollectionViewDelegateFlowLayout method, and the scrollView content offset moves to (0, 0). Which is not the expected result.
         * To keep the contentOffset to that same position adding the below code which will execute after 0.1 second because need time for collectionView adjusts its width and height.
         * Adjusting preview snap progressors width to Holder view width because when animation finished in portrait orientation, when we switch to landscape orientation, we have to update the progress view width for preview snap progressors also.
         * Also, adjusting progress view width to updated frame width when the progress view animation is executing.
         */
        if self.isTransitioning {
            let visibleCells = collectionView.visibleCells.sortedArrayByPosition()
            let visibleCell = visibleCells.first as? StoriesViewCell
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { [weak self] in
                guard let strongSelf = self, let vCell = visibleCell, let progressIndicatorView = vCell.getProgressIndicatorView(with: vCell.snapIndex),
                    let pv = vCell.getProgressView(with: vCell.snapIndex) else {
                        fatalError("Visible cell or progressIndicatorView or progressView is nil")
                }
                vCell.scrollview.setContentOffset(CGPoint(x: CGFloat(vCell.snapIndex) * collectionView.frame.width, y: 0), animated: false)
                vCell.adjustPreviousSnapProgressorsWidth(with: vCell.snapIndex)
                if pv.state == .running {
                    pv.widthConstraint?.constant = progressIndicatorView.frame.width
                }
                strongSelf.isTransitioning = false
            }
        }
        if #available(iOS 11.0, *) {
            return CGSize(width: self.snapsCollectionView.safeAreaLayoutGuide.layoutFrame.width, height: self.snapsCollectionView.safeAreaLayoutGuide.layoutFrame.height)
        } else {
            return CGSize(width: self.snapsCollectionView.frame.width, height: self.snapsCollectionView.frame.height)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let vCell = self.snapsCollectionView.visibleCells.first as? StoriesViewCell else { return }
        vCell.pauseSnapProgressors(with: (vCell.story?.lastPlayedSnapIndex)!)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let sortedVCells = self.snapsCollectionView.visibleCells.sortedArrayByPosition()
        guard let f_Cell = sortedVCells.first as? StoriesViewCell else { return }
        guard let l_Cell = sortedVCells.last as? StoriesViewCell else { return }
        let f_IndexPath = self.snapsCollectionView.indexPath(for: f_Cell)
        let l_IndexPath = self.snapsCollectionView.indexPath(for: l_Cell)
        let numberOfItems = self.collectionView(self.snapsCollectionView, numberOfItemsInSection: 0) - 1
        if l_IndexPath?.item == 0 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                self.dismiss(animated: true, completion: nil)
            }
        } else if f_IndexPath?.item == numberOfItems {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
