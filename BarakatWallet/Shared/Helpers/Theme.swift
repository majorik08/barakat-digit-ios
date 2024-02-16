//
//  Theme.swift
//  BarakatWallet
//
//  Created by km1tj on 05/10/23.
//

import Foundation
import UIKit

public class Theme {
    
    public var mainPaddings: CGFloat = 20
    public var mainButtonHeight: CGFloat = 52
    
    public var whiteColor: UIColor = UIColor(red: 0.976, green: 0.976, blue: 0.976, alpha: 1)
    
    public var value: String = "DEFAULT"
    public var dark: Bool = false
    public var lightStatusBar: Bool = false
    public var searchBarTint: UIColor? = nil
    public var tintColor: UIColor = UIColor(red: 0.00, green: 0.67, blue: 1.00, alpha: 1.00)
    public var secondTintColor: UIColor = UIColor(red: 0.73, green: 0.86, blue: 1.00, alpha: 1.00)
    public var grayColor: UIColor = UIColor(red: 0.969, green: 0.973, blue: 0.98, alpha: 1)
    public var shadowColor: UIColor = UIColor(red: 0.204, green: 0.584, blue: 0.918, alpha: 0.38)
    public var borderColor: UIColor = UIColor(red: 0.729, green: 0.859, blue: 1, alpha: 1)
    public var dimColor: UIColor = UIColor(red: 0.00, green: 0.04, blue: 0.15, alpha: 0.2)
   
    public var navigationColor: UIColor = .white
    public var navigationTextColor: UIColor = UIColor(red: 0.00, green: 0.67, blue: 1.00, alpha: 1.00)
   
    public var primaryTextColor: UIColor = .black
    public var secondaryTextColor: UIColor = UIColor(red:0.49, green:0.55, blue:0.60, alpha:1.0)
   
    public var groupedTableBackColor: UIColor = UIColor(red: 0.97, green: 0.97, blue: 1.00, alpha: 1.00)
    public var plainTableBackColor: UIColor = .white
    public var groupedTableCellColor: UIColor = .white
    public var plainTableCellColor: UIColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
    public var groupedTableSeparatorColor: UIColor = UIColor(red: 0.783922, green: 0.780392, blue: 0.8, alpha: 1)
    public var plainTableSeparatorColor: UIColor = UIColor(red: 0.783922, green: 0.780392, blue: 0.8, alpha: 1)
    public var groupedSelectedCellBackground: UIColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
    public var plainSelectedCellBackground: UIColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
    
    public var mainGradientStartColor: UIColor = UIColor(red: 0.255, green: 0.486, blue: 0.914, alpha: 1)
    public var mainGradientEndColor: UIColor = UIColor(red: 0.329, green: 0.82, blue: 0.941, alpha: 1)
    public var cardGradientStartColor = UIColor(red: 0.407, green: 0.572, blue: 0.746, alpha: 1)
    public var cardGradientEndColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
   
    public static var current: Theme = Theme() {
        didSet {
            if current.dark {
                if #available(iOS 13.0, *) {
                } else {
                    UIVisualEffectView.appearance(whenContainedInInstancesOf: [UIAlertController.classForCoder() as! UIAppearanceContainer.Type]).effect = UIBlurEffect(style: .dark)
                }
                UITextField.appearance().keyboardAppearance = .dark
            } else {
                UITextField.appearance().keyboardAppearance = .default
                if #available(iOS 13.0, *) {
                } else {
                    UIVisualEffectView.appearance(whenContainedInInstancesOf: [UIAlertController.classForCoder() as! UIAppearanceContainer.Type]).effect = UIBlurEffect(style: .extraLight)
                }
            }
        }
    }
    
    public static func configure(currenTheme: String, darkGlobalColor: UIColor, lightGlobalColor: UIColor) {
        if currenTheme == "LIGHT" {
            Theme.current = Theme.light(globalColor: lightGlobalColor)
        } else if currenTheme == "DARK" {
            Theme.current = Theme.dark(globalColor: darkGlobalColor)
        } else {
            if #available(iOS 12.0, *) {
                if UIViewController().traitCollection.userInterfaceStyle == .dark {
                    Theme.current = Theme.dark(globalColor: darkGlobalColor)
                } else {
                    Theme.current = Theme.light(globalColor: lightGlobalColor)
                }
            } else {
                Theme.current = Theme.light(globalColor: lightGlobalColor)
            }
            Theme.current.value = "DEFAULT"
        }
    }
    
    public static func light(globalColor: UIColor) -> Theme {
        let t = Theme()
        t.value = "LIGHT"
        t.dark = false
        t.lightStatusBar = false
        t.tintColor = globalColor
        return t
    }
    
    public static func dark(globalColor: UIColor) -> Theme {
        let t = Theme()
        t.value = "DARK"
        t.dark = true
        t.lightStatusBar = true
        t.tintColor = globalColor
        t.navigationColor = .black
        t.navigationTextColor = globalColor
        t.shadowColor = UIColor(red: 0.279, green: 0.29, blue: 0.35, alpha: 0.29)
        t.grayColor = UIColor(red: 0.141, green: 0.141, blue: 0.149, alpha: 1)
        t.dimColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        t.borderColor = UIColor(red: 0.30, green: 0.67, blue: 0.93, alpha: 1.00)
        t.primaryTextColor = UIColor(red: 0.976, green: 0.976, blue: 0.976, alpha: 1)
        t.secondaryTextColor = UIColor(red:0.49, green:0.55, blue:0.60, alpha:1.0)
        t.searchBarTint = t.navigationColor
        t.groupedTableBackColor = .black//UIColor(red: 0.97, green: 0.97, blue: 1.00, alpha: 1.00)
        t.plainTableBackColor = .black//UIColor(red: 0.97, green: 0.97, blue: 1.00, alpha: 1.00)
        t.groupedTableCellColor = t.navigationColor
        t.plainTableCellColor = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.00)//UIColor(red: 0.141, green: 0.141, blue: 0.149, alpha: 1)
        t.groupedTableSeparatorColor = .black
        t.plainTableSeparatorColor = UIColor(red:0.24, green:0.24, blue:0.26, alpha:1.0)  //t.navigationColor
        t.groupedSelectedCellBackground = UIColor(red: 0.19, green: 0.19, blue: 0.21, alpha: 1.00)//UIColor(red:0.10, green:0.10, blue:0.10, alpha:1.0)
        t.plainSelectedCellBackground = UIColor(red:0.10, green:0.10, blue:0.10, alpha:1.0)
        
        t.mainGradientEndColor = UIColor(red: 0.33, green: 0.82, blue: 0.94, alpha: 1.00)//UIColor(red: 0.003, green: 0.318, blue: 0.396, alpha: 1)
        t.mainGradientStartColor = UIColor(red: 0.25, green: 0.49, blue: 0.91, alpha: 1.00)//UIColor(red: 0.042, green: 0.15, blue: 0.35, alpha: 1)
        
        return t
    }
}
