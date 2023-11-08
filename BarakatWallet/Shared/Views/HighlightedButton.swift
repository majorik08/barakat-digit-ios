//
//  HighlightButton.swift
//  BarakatWallet
//
//  Created by km1tj on 31/10/23.
//

import Foundation
import UIKit

public class HighlightedButton: UIButton {
    
    public override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                self.alpha = 0.6
            } else {
                self.alpha = 1
            }
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            if self.isEnabled {
                self.alpha = 1
            } else {
                self.alpha = 0.6
            }
        }
    }
}
