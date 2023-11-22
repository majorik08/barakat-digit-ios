//
//  CardOptionViews.swift
//  BarakatWallet
//
//  Created by km1tj on 18/11/23.
//

import Foundation
import UIKit

class DisclosureOptionView: UIControl {
    let titleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 16)
        view.textColor = Theme.current.primaryTextColor
        return view
    }()
    let iconView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = Theme.current.tintColor
        view.image = UIImage(name: .arrow_right)
        view.isUserInteractionEnabled = false
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.titleView)
        self.addSubview(self.iconView)
        NSLayoutConstraint.activate([
            self.titleView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.titleView.topAnchor.constraint(equalTo: self.topAnchor),
            self.titleView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.iconView.leftAnchor.constraint(greaterThanOrEqualTo: self.titleView.rightAnchor, constant: 10),
            self.iconView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            self.iconView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.iconView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            self.iconView.widthAnchor.constraint(equalTo: self.iconView.heightAnchor, multiplier: 1)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SwitchOptionView: UIControl {
    let titleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 16)
        view.textColor = Theme.current.primaryTextColor
        return view
    }()
    let switchView: UISwitch = {
        let view = UISwitch(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .lightGray
        view.onTintColor = Theme.current.tintColor
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .horizontal)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.titleView)
        self.addSubview(self.switchView)
        NSLayoutConstraint.activate([
            self.titleView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.titleView.topAnchor.constraint(equalTo: self.topAnchor),
            self.titleView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.switchView.leftAnchor.constraint(greaterThanOrEqualTo: self.titleView.rightAnchor, constant: 10),
            self.switchView.topAnchor.constraint(equalTo: self.topAnchor),
            self.switchView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.switchView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        self.switchView.addTarget(self, action: #selector(self.changed), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func changed() {
        self.sendActions(for: .valueChanged)
    }
}

class ColorOptionView: UIControl {
    let titleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 16)
        view.textColor = Theme.current.primaryTextColor
        return view
    }()
    let firstColorView: GradientImageView = {
        let view = GradientImageView(frame: .zero)
        view.startColor = UIColor(red: 0.20, green: 0.24, blue: 0.92, alpha: 1.00)
        view.endColor = UIColor(red: 0.20, green: 0.70, blue: 0.92, alpha: 1.00)
        view.circleImage = false
        view.imageView.contentMode = .scaleAspectFit
        view.imageView.tintColor = Theme.current.whiteColor
        view.imageView.image = UIImage(name: .checked_fill)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        view.tag = 0
        view.isUserInteractionEnabled = true
        return view
    }()
    let secondColorView: GradientImageView = {
        let view = GradientImageView(frame: .zero)
        view.startColor = UIColor(red: 0.20, green: 0.92, blue: 0.32, alpha: 1.00)
        view.endColor = UIColor(red: 0.73, green: 0.92, blue: 0.20, alpha: 1.00)
        view.circleImage = false
        view.imageView.contentMode = .scaleAspectFit
        view.imageView.tintColor = Theme.current.whiteColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        view.tag = 1
        view.isUserInteractionEnabled = true
        return view
    }()
    let thirdColorView: GradientImageView = {
        let view = GradientImageView(frame: .zero)
        view.startColor = UIColor(red: 0.92, green: 0.20, blue: 0.20, alpha: 1.00)
        view.endColor = UIColor(red: 0.92, green: 0.59, blue: 0.20, alpha: 1.00)
        view.circleImage = false
        view.imageView.contentMode = .scaleAspectFit
        view.imageView.tintColor = Theme.current.whiteColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        view.tag = 2
        view.isUserInteractionEnabled = true
        return view
    }()
    var selectedColor: Int = 0
    
    var colors: [(start: UIColor, end: UIColor)] = [
        (start: UIColor(red: 0.20, green: 0.24, blue: 0.92, alpha: 1.00), end: UIColor(red: 0.20, green: 0.70, blue: 0.92, alpha: 1.00)),
        (start: UIColor(red: 0.20, green: 0.92, blue: 0.32, alpha: 1.00), end: UIColor(red: 0.73, green: 0.92, blue: 0.20, alpha: 1.00)),
        (start: UIColor(red: 0.92, green: 0.20, blue: 0.20, alpha: 1.00), end: UIColor(red: 0.92, green: 0.59, blue: 0.20, alpha: 1.00))
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.titleView)
        self.addSubview(self.firstColorView)
        self.addSubview(self.secondColorView)
        self.addSubview(self.thirdColorView)
        NSLayoutConstraint.activate([
            self.titleView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.titleView.topAnchor.constraint(equalTo: self.topAnchor),
            self.titleView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.firstColorView.leftAnchor.constraint(greaterThanOrEqualTo: self.titleView.rightAnchor, constant: 10),
            self.firstColorView.topAnchor.constraint(equalTo: self.topAnchor),
            self.firstColorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.firstColorView.widthAnchor.constraint(equalTo: self.firstColorView.heightAnchor, multiplier: 1.518),
            self.secondColorView.leftAnchor.constraint(equalTo: self.firstColorView.rightAnchor, constant: 10),
            self.secondColorView.topAnchor.constraint(equalTo: self.topAnchor),
            self.secondColorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.secondColorView.widthAnchor.constraint(equalTo: self.secondColorView.heightAnchor, multiplier: 1.518),
            self.thirdColorView.leftAnchor.constraint(equalTo: self.secondColorView.rightAnchor, constant: 10),
            self.thirdColorView.topAnchor.constraint(equalTo: self.topAnchor),
            self.thirdColorView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.thirdColorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.thirdColorView.widthAnchor.constraint(equalTo: self.thirdColorView.heightAnchor, multiplier: 1.518),
        ])
        self.firstColorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:))))
        self.secondColorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:))))
        self.thirdColorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:))))
    }
    
    @objc func tapped(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }
        if view === self.firstColorView {
            self.selectedColor = 0
            self.firstColorView.imageView.image = UIImage(name: .checked_fill)
            self.secondColorView.imageView.image = nil
            self.thirdColorView.imageView.image = nil
        } else if view == self.secondColorView {
            self.selectedColor = 1
            self.firstColorView.imageView.image = nil
            self.secondColorView.imageView.image = UIImage(name: .checked_fill)
            self.thirdColorView.imageView.image = nil
        } else if view == self.thirdColorView {
            self.selectedColor = 2
            self.firstColorView.imageView.image = nil
            self.secondColorView.imageView.image = nil
            self.thirdColorView.imageView.image = UIImage(name: .checked_fill)
        }
        self.sendActions(for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
