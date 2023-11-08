//
//  UIFontExt.swift
//  BarakatWallet
//
//  Created by km1tj on 05/10/23.
//

import Foundation
import UIKit

extension UIFont {
    
    public static var regular: String? = nil
    public static var regularItalic: String? = nil
    public static var medium: String? = nil
    public static var mediumItalic: String? = nil
    public static var semibold: String? = nil
    public static var semiboldItalic: String? = nil
    public static var bold: String? = nil
    public static var boldItalic: String? = nil
    
    public static func regular(size: CGFloat, italic: Bool = false) -> UIFont {
        if italic, let ri = self.regularItalic {
            return UIFont(name: ri, size: size)!
        } else if let r = self.regular {
            return UIFont(name: r, size: size)!
        } else {
            return italic ? UIFont.italicSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size, weight: .regular)
        }
    }
    
    public static func semibold(size: CGFloat, italic: Bool = false) -> UIFont {
        if italic, let sbi = self.semiboldItalic {
            return UIFont(name: sbi, size: size)!
        } else if let sb = self.semibold {
            return UIFont(name: sb, size: size)!
        } else {
            return italic ? UIFont.italicSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size, weight: .semibold)
        }
    }
    
    public static func bold(size: CGFloat, italic: Bool = false) -> UIFont {
        if italic, let bi = self.boldItalic {
            return UIFont(name: bi, size: size)!
        } else if let b = self.bold {
            return UIFont(name: b, size: size)!
        } else {
            return italic ? UIFont.italicSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size, weight: .bold)
        }
    }
    
    public static func medium(size: CGFloat, italic: Bool = false) -> UIFont {
        if italic, let mi = self.mediumItalic {
            return UIFont(name: mi, size: size)!
        } else if let m = self.medium {
            return UIFont(name: m, size: size)!
        } else {
            return italic ? UIFont.italicSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size, weight: .medium)
        }
    }
}
