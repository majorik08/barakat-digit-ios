//
//  CircleImageView.swift
//  BarakatWallet
//
//  Created by km1tj on 05/10/23.
//

import Foundation
import UIKit

public class InnerImageView: UIView {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .clear
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(self.imageView)
        NSLayoutConstraint.activate([
            self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.imageView.heightAnchor.constraint(equalToConstant: 100),
            self.imageView.widthAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class GradientImageView: GradientView {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.tintColor = .white
        view.backgroundColor = .clear
        return view
    }()
    var circleImage = true

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.installLayers()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.installLayers()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = self.bounds
        if self.circleImage {
            self.radius = self.bounds.width / 2
        }
    }

    private func installLayers() {
        self.startColor = Theme.current.mainGradientStartColor
        self.endColor = Theme.current.mainGradientEndColor
        if self.circleImage {
            self.radius = self.bounds.width / 2
        }
        self.backgroundColor = .clear
        self.clipsToBounds = false
        self.addSubview(self.imageView)
        self.imageView.frame = self.bounds
    }
}

public class CircleImageView: UIImageView {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width / 2
    }
}

open class AvatarImageView: UIImageView {
    
    public let progressView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .white)
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.isHidden = true
        view.color = Theme.current.tintColor
        view.hidesWhenStopped = true
        return view
    }()
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Theme.current.secondTintColor
        self.addSubview(self.progressView)
        NSLayoutConstraint.activate([
            self.progressView.heightAnchor.constraint(equalToConstant: 10),
            self.progressView.widthAnchor.constraint(equalToConstant: 10),
            self.progressView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.progressView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
