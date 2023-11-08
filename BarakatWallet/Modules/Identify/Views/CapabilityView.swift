//
//  CapabilityView.swift
//  BarakatWallet
//
//  Created by km1tj on 06/11/23.
//

import Foundation
import UIKit

class CapabilityView: UIView {
    
    let imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    let titleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 18)
        view.textColor = Theme.current.primaryTextColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imageView)
        self.addSubview(self.titleView)
        NSLayoutConstraint.activate([
            self.imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 2),
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.imageView.widthAnchor.constraint(equalTo: self.imageView.heightAnchor, multiplier: 1),
            self.titleView.leftAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: 10),
            self.titleView.topAnchor.constraint(equalTo: self.topAnchor),
            self.titleView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.titleView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
