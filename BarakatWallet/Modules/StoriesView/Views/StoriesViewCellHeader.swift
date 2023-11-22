//
//  StoriesViewCellHeader.swift
//  BarakatWallet
//
//  Created by km1tj on 16/11/23.
//

import Foundation
import UIKit

protocol RetryBtnDelegate: AnyObject {
    func retryButtonTapped()
}

public class IGRetryLoaderButton: UIButton {
    
    var contentURL: String?
    weak var delegate: RetryBtnDelegate?
    
    convenience init(withURL url: String) {
        self.init()
        self.contentURL = url
        self.backgroundColor = .white
        self.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        self.setImage(UIImage(name: .repeat_icon), for: .normal)
        self.tintColor = .black
        self.addTarget(self, action: #selector(didTapRetryBtn), for: .touchUpInside)
        self.tag = 100
    }
    
    @objc func didTapRetryBtn() {
        self.delegate?.retryButtonTapped()
    }
}

extension UIView {
    func removeRetryButton() {
        self.subviews.forEach({v in
            if(v.tag == 100) { v.removeFromSuperview() }
        })
    }
}

protocol StoriesViewCellHeaderDelegate: AnyObject {
    func didTapCloseButton()
}

public let progressIndicatorViewTag = 88

class StoriesViewCellHeader: UIView {
    
    public weak var delegate: StoriesViewCellHeaderDelegate?
    public var story: StoriesItem? {
        didSet {
            self.snapsPerStory  = (story?.snaps.count)! < maxSnaps ? (story?.snaps.count)! : maxSnaps
        }
    }
    fileprivate let maxSnaps = 30
    fileprivate var snapsPerStory: Int = 0
    fileprivate var progressView: UIView?
    fileprivate lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(name: .close_x), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapClose(_:)), for: .touchUpInside)
        return button
    }()
    public var getProgressView: UIView {
        if let progressView = self.progressView { return progressView }
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        self.progressView = v
        self.addSubview(self.getProgressView)
        return v
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.backgroundColor = .clear
        self.addSubview(self.getProgressView)
        self.addSubview(self.closeButton)
        let pv = self.getProgressView
        NSLayoutConstraint.activate([
            pv.leftAnchor.constraint(equalTo: self.leftAnchor),
            pv.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            pv.rightAnchor.constraint(equalTo: self.rightAnchor),
            pv.heightAnchor.constraint(equalToConstant: 10),
            self.closeButton.widthAnchor.constraint(equalToConstant: 60),
            self.closeButton.heightAnchor.constraint(equalToConstant: 80),
            self.closeButton.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.closeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func didTapClose(_ sender: UIButton) {
        self.delegate?.didTapCloseButton()
    }
    
    private func applyProperties<T: UIView>(_ view: T, with tag: Int? = nil, alpha: CGFloat = 1.0) -> T {
        view.layer.cornerRadius = 1
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.white.withAlphaComponent(alpha)
        if let tagValue = tag {
            view.tag = tagValue
        }
        return view
    }
    
    public func clearTheProgressorSubviews() {
        self.getProgressView.subviews.forEach { v in
            v.subviews.forEach{ v in (v as! IGSnapProgressView).stop() }
            v.removeFromSuperview()
        }
    }
    
    public func clearAllProgressors() {
        self.clearTheProgressorSubviews()
        self.getProgressView.removeFromSuperview()
        self.progressView = nil
    }
    
    public func clearSnapProgressor(at index: Int) {
        self.getProgressView.subviews[index].removeFromSuperview()
    }
    
    public func createSnapProgressors(){
        print("Progressor count: \(self.getProgressView.subviews.count)")
        let padding: CGFloat = 8 //GUI-Padding
        let height: CGFloat = 3
        var pvIndicatorArray: [IGSnapProgressIndicatorView] = []
        var pvArray: [IGSnapProgressView] = []
        // Adding all ProgressView Indicator and ProgressView to seperate arrays
        for i in 0..<self.snapsPerStory {
            let pvIndicator = IGSnapProgressIndicatorView()
            pvIndicator.translatesAutoresizingMaskIntoConstraints = false
            self.getProgressView.addSubview(applyProperties(pvIndicator, with: i + progressIndicatorViewTag, alpha:0.2))
            pvIndicatorArray.append(pvIndicator)
            let pv = IGSnapProgressView()
            pv.translatesAutoresizingMaskIntoConstraints = false
            pvIndicator.addSubview(self.applyProperties(pv))
            pvArray.append(pv)
        }
        // Setting Constraints for all progressView indicators
        for index in 0..<pvIndicatorArray.count {
            let pvIndicator = pvIndicatorArray[index]
            if index == 0 {
                pvIndicator.leftConstraiant = pvIndicator.leftAnchor.constraint(equalTo: self.getProgressView.leftAnchor, constant: padding)
                NSLayoutConstraint.activate([
                    pvIndicator.leftConstraiant!,
                    pvIndicator.centerYAnchor.constraint(equalTo: self.getProgressView.centerYAnchor),
                    pvIndicator.heightAnchor.constraint(equalToConstant: height)
                    ])
                if pvIndicatorArray.count == 1 {
                    pvIndicator.rightConstraiant = self.getProgressView.rightAnchor.constraint(equalTo: pvIndicator.rightAnchor, constant: padding)
                    pvIndicator.rightConstraiant!.isActive = true
                }
            }else {
                let prePVIndicator = pvIndicatorArray[index-1]
                pvIndicator.widthConstraint = pvIndicator.widthAnchor.constraint(equalTo: prePVIndicator.widthAnchor, multiplier: 1.0)
                pvIndicator.leftConstraiant = pvIndicator.leftAnchor.constraint(equalTo: prePVIndicator.rightAnchor, constant: padding)
                NSLayoutConstraint.activate([
                    pvIndicator.leftConstraiant!,
                    pvIndicator.centerYAnchor.constraint(equalTo: prePVIndicator.centerYAnchor),
                    pvIndicator.heightAnchor.constraint(equalToConstant: height),
                    pvIndicator.widthConstraint!
                    ])
                if index == pvIndicatorArray.count-1 {
                    pvIndicator.rightConstraiant = self.rightAnchor.constraint(equalTo: pvIndicator.rightAnchor, constant: padding)
                    pvIndicator.rightConstraiant!.isActive = true
                }
            }
        }
        // Setting Constraints for all progressViews
        for index in 0..<pvArray.count {
            let pv = pvArray[index]
            let pvIndicator = pvIndicatorArray[index]
            pv.widthConstraint = pv.widthAnchor.constraint(equalToConstant: 0)
            NSLayoutConstraint.activate([
                pv.leftAnchor.constraint(equalTo: pvIndicator.leftAnchor),
                pv.heightAnchor.constraint(equalTo: pvIndicator.heightAnchor),
                pv.topAnchor.constraint(equalTo: pvIndicator.topAnchor),
                pv.widthConstraint!
                ])
        }
    }
}
