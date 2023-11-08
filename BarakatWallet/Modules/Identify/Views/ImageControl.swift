//
//  ImageControl.swift
//  BarakatWallet
//
//  Created by km1tj on 06/11/23.
//

import Foundation
import UIKit

class ImageControl: UIControl {
    
    let imageView: GradientImageView = {
        let view = GradientImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageView.image = UIImage(name: .plus_inset)
        view.layer.shadowColor = Theme.current.shadowColor.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 28
        view.layer.shadowOffset = CGSize(width: 2, height: 5)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.addSubview(self.imageView)
        NSLayoutConstraint.activate([
            self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25),
            self.imageView.widthAnchor.constraint(equalTo: self.imageView.heightAnchor, multiplier: 1)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 8)
        Theme.current.plainTableBackColor.setFill()
        path.fill()
        Theme.current.secondTintColor.setStroke()
        path.lineWidth = 3
        let dashPattern : [CGFloat] = [6, 3]
        path.setLineDash(dashPattern, count: 2, phase: 0)
        path.stroke()
    }
}
