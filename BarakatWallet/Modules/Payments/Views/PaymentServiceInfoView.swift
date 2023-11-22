//
//  PaymentParamInfoView.swift
//  BarakatWallet
//
//  Created by km1tj on 11/11/23.
//

import Foundation
import UIKit

class PaymentServiceInfoView: UIView {
    
    let infoLabel: PaddingLabel = {
        let view = PaddingLabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 14)
        view.textColor = .white
        view.numberOfLines = 0
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .systemOrange
        self.addSubview(self.infoLabel)
        NSLayoutConstraint.activate([
            self.infoLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            self.infoLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.infoLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            self.infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
