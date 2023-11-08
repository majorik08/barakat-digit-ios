//
//  PaddingLabel.swift
//  BarakatWallet
//
//  Created by km1tj on 24/10/23.
//

import Foundation
import UIKit

public class PaddingLabel: UILabel {
    
    public var topInset: CGFloat = 0.0
    public var bottomInset: CGFloat = 0.0
    public var leftInset: CGFloat = 0.0
    public var rightInset: CGFloat = 0.0
    
    public override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
        //super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    public override var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}

public class CircleLabel: PaddingLabel {
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height / 2
    }
}
