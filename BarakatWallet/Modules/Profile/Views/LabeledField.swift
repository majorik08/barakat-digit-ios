//
//  LabeledField.swift
//  BarakatWallet
//
//  Created by km1tj on 31/10/23.
//

import Foundation
import UIKit

class LabeledField: UIView {
    
    let labelView: UILabel = {
        let view = UILabel()
        view.textColor = Theme.current.secondaryTextColor
        view.font = UIFont.semibold(size: 14)
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let fieldView: PaddingTextField = {
        let view = PaddingTextField()
        view.padding = .init(top: 0, left: 10, bottom: 0, right: 10)
        view.textColor = Theme.current.primaryTextColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.font = UIFont.medium(size: 16)
        view.clipsToBounds = true
        view.layer.borderColor = Theme.current.secondTintColor.withAlphaComponent(0.3).cgColor
        view.layer.borderWidth = 0.5
        view.backgroundColor = Theme.current.plainTableCellColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.labelView)
        self.addSubview(self.fieldView)
        NSLayoutConstraint.activate([
            self.labelView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.labelView.topAnchor.constraint(equalTo: self.topAnchor),
            self.labelView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.labelView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.35),
            self.fieldView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.fieldView.topAnchor.constraint(equalTo: self.labelView.bottomAnchor),
            self.fieldView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.fieldView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.65)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
