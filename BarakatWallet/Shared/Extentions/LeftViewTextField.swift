//
//  LeftViewTextField.swift
//  BarakatWallet
//
//  Created by km1tj on 21/10/23.
//

import Foundation
import UIKit

class LeftViewTextField: UITextField {
    
    var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }
    var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    var leftPadding: CGFloat = 10
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += self.leftPadding
        return textRect
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.tintColor = color
            leftView = imageView
        } else if let image = self.rightImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.tintColor = color
            rightView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
}
