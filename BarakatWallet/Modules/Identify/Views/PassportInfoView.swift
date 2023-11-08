//
//  PassportInfoView.swift
//  BarakatWallet
//
//  Created by km1tj on 06/11/23.
//

import Foundation
import UIKit

class PassportInfoView: UIView {
    
    let topLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 14)
        view.textColor = Theme.current.primaryTextColor
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        let note = NSAttributedString(string: "\("NOTE".localized): ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemRed])
        let text = NSMutableAttributedString(attributedString: note)
        let att = NSAttributedString(string: "SECURITY_HINT".localized, attributes: [NSAttributedString.Key.foregroundColor : Theme.current.primaryTextColor])
        text.append(att)
        view.attributedText = text
        return view
    }()
    let checkButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(name: .checked), for: .selected)
        view.setImage(UIImage(name: .unchecked), for: .normal)
        view.tintColor = Theme.current.tintColor
        view.isSelected = true
        return view
    }()
    let privacyHint: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 14)
        view.textColor = Theme.current.primaryTextColor
        view.text = "PRIVACY_PASSPORT".localized
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    let bottomLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 14)
        view.textColor = Theme.current.primaryTextColor
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        let note = NSAttributedString(string: "\("ATTENTION".localized): ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemRed])
        let text = NSMutableAttributedString(attributedString: note)
        let att = NSAttributedString(string: "SECURE_CHANNEL_INFO".localized, attributes: [NSAttributedString.Key.foregroundColor : Theme.current.primaryTextColor])
        text.append(att)
        view.attributedText = text
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.topLabel)
        self.addSubview(self.checkButton)
        self.addSubview(self.privacyHint)
        self.addSubview(self.bottomLabel)
        NSLayoutConstraint.activate([
            self.topLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.topLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            self.topLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.checkButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.checkButton.topAnchor.constraint(equalTo: self.topLabel.bottomAnchor, constant: 16),
            self.checkButton.heightAnchor.constraint(equalToConstant: 22),
            self.checkButton.widthAnchor.constraint(equalToConstant: 22),
            self.privacyHint.leftAnchor.constraint(equalTo: self.checkButton.rightAnchor, constant: 10),
            self.privacyHint.topAnchor.constraint(equalTo: self.topLabel.bottomAnchor, constant: 16),
            self.privacyHint.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.bottomLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.bottomLabel.topAnchor.constraint(equalTo: self.privacyHint.bottomAnchor, constant: 20),
            self.bottomLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.bottomLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func themeChanged(newTheme: Theme) {
        self.backgroundColor = Theme.current.plainTableCellColor
        
    }
}
