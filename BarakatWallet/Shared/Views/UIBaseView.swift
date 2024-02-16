//
//  UIBaseView.swift
//  BarakatWallet
//
//  Created by km1tj on 22/01/24.
//

import Foundation
import UIKit

class UIBaseView: UIView {
    
    @IBInspectable
    var highlightColor: UIColor = UIColor.white
    
    var action: Action?
    typealias Action = (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initGestureRecognizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initGestureRecognizer()
    }
    
    private func initGestureRecognizer() {
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(tapHandler(gesture:)))
        tap.minimumPressDuration = 0
        addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    public func addTapGestureRecognizerr(action: (() -> Void)?) {
        self.action = action
    }
    
    @objc func tapHandler(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            self.backgroundColor = highlightColor
        } else if  gesture.state == .ended {
            self.backgroundColor = UIColor.clear
            if let a = action {
                a?()
            }
        }
    }
}
