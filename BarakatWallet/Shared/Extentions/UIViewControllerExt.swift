//
//  UIViewControllerExt.swift
//  BarakatWallet
//
//  Created by km1tj on 24/10/23.
//

import Foundation
import UIKit
import MBProgressHUD

public extension UIViewController {
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func setChatInfo(title: String, subTitle: String?) {
        let titleText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.semibold(size: 16)])
        self.updateTitleView(title: titleText, subtitle: subTitle, subTitleColor: nil)
    }
    
    private func updateTitleView(title: NSAttributedString, subtitle: String?, subTitleColor: UIColor? = nil) {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height: 0))
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = Theme.current.primaryTextColor
        titleLabel.font = UIFont.regular(size: 15)
        titleLabel.attributedText = title
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.textColor = subTitleColor ?? Theme.current.primaryTextColor.withAlphaComponent(0.95)
        subtitleLabel.font = UIFont.regular(size: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.textAlignment = .center
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        if subtitle != nil && !subtitle!.isEmpty {
            titleView.addSubview(subtitleLabel)
        } else {
            titleLabel.frame = titleView.frame
        }
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }
        self.navigationItem.titleView = titleView
    }
    
    func getAlertView(style: UIAlertController.Style = .alert, title: String, message: String) -> UIAlertController {
        if title.isEmpty && message.isEmpty {
            let a = UIAlertController(title: nil, message: nil, preferredStyle: style)
            if #available(iOS 13.0, tvOS 13.0, *) {
                a.overrideUserInterfaceStyle = Theme.current.dark ? .dark : .light
            }
            return a
        }
        let alert = UIAlertController(title: title, message: message.isEmpty ? nil : message, preferredStyle: style)
        if #available(iOS 13.0, tvOS 13.0, *) {
            alert.overrideUserInterfaceStyle = Theme.current.dark ? .dark : .light
        }
        let attributesTitle = [NSAttributedString.Key.foregroundColor: Theme.current.primaryTextColor, NSAttributedString.Key.font: UIFont.semibold(size: 17)]
        let attributedTitleText = NSAttributedString(string: title, attributes: attributesTitle)
        alert.setValue(attributedTitleText, forKey: "attributedTitle")
        if !message.isEmpty {
            let attributesMessage = [NSAttributedString.Key.foregroundColor: Theme.current.primaryTextColor, NSAttributedString.Key.font: UIFont.regular(size: 13)]
            let attributedMessageText = NSAttributedString(string: message, attributes: attributesMessage)
            alert.setValue(attributedMessageText, forKey: "attributedMessage")
        }
        return alert
    }
    
    func getActionSheet(popOver: UIView?, barButton: UIBarButtonItem?) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if #available(iOS 13.0, tvOS 13.0, *) {
            alert.overrideUserInterfaceStyle = Theme.current.dark ? .dark : .light
        }
        alert.popoverPresentationController?.sourceView = popOver
        alert.popoverPresentationController?.barButtonItem = barButton
        return alert
    }
    
    func showNetworkErrorAlert() {
        self.showErrorAlert(title: "NETWORK_PROBLEM".localized, message: "NETWORK_PROBLEM_HELP".localized)
    }
    
    func showServerErrorAlert() {
        self.showErrorAlert(title: "ERROR".localized, message: "SERVER_ERROR".localized)
    }
    
    func showErrorAlert(title: String, message: String) {
        let alert = getAlertView(title: title, message: message)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSuccessAlert(title: String, message: String, completion:@escaping(_ success: Bool) -> Void) {
        let alert = getAlertView(title: title, message: message)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
            completion(true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showBooleanAlert(title: String, message: String, cancelText: String? = nil, okText: String? = nil, completion:@escaping(_ success: Bool) -> Void) {
        let alert = getAlertView(title: title, message: message)
        alert.addAction(UIAlertAction(title: cancelText ?? "CANCEL".localized, style: .cancel, handler: {  action in
            completion(false)
        }))
        alert.addAction(UIAlertAction(title: okText ?? "OK", style: .default, handler: {  action in
            completion(true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showProgressAddedTo(view: UIView, title: String? = nil, info: String? = nil) {
        self.view.endEditing(true)
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .customView
        let alert = InfoProgress(text: title ?? "LOADING".localized, info: info)
        hud.customView = alert
        hud.backgroundView.style = .solidColor
        //hud.backgroundView.blurEffectStyle = .extraLight
        hud.animationType = .zoomIn
        if view is UITableView || view is UICollectionView {
            hud.backgroundView.color = UIColor(white: 0.0, alpha: 0.2)
        } else {
            hud.backgroundView.color = UIColor(white: 0.0, alpha: 0.7)
        }
        hud.bezelView.style = .solidColor
        hud.bezelView.color = Theme.current.navigationColor
    }
    
    func hideProgressFrom(view: UIView) {
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    func successProgress(text: String) {
        var uiView: UIView? = self.navigationController?.view
        if uiView == nil {
            uiView = self.view
        }
        let hud = MBProgressHUD.forView(uiView!)
        hud?.customView = UIImageView(image: UIImage(named: "checkmark", in: .main, compatibleWith: nil))
        hud?.mode = .customView
        hud?.label.text = text
        hud?.hide(animated: true, afterDelay: 1)
    }
    
    func hideProgressView() {
        var uiView: UIView? = self.navigationController?.view
        if uiView == nil {
            uiView = self.view
        }
        self.hideProgressFrom(view: uiView!)
    }
    
    func showProgressView(title: String? = nil, info: String? = nil) {
        self.view.endEditing(true)
        var uiView: UIView? = self.navigationController?.view
        if uiView == nil {
            uiView = self.view
        }
        self.showProgressAddedTo(view: uiView!, title: title, info: info)
    }
}
