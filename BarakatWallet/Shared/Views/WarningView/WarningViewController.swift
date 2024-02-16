//
//  WarningViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 30/11/23.
//

import Foundation
import UIKit

class WarningViewController: BaseViewController {
    
    weak var coordinator: AppCoordinator?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
        self.modalPresentationCapturesStatusBarAppearance = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            return .default
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemRed
        let blurEffect = UIBlurEffect(style: Theme.current.dark ? .dark : .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "SEC_WARNING".localized
        label.font = UIFont.semibold(size: 20)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        let labelInfo = UILabel(frame: .zero)
        labelInfo.translatesAutoresizingMaskIntoConstraints = false
        labelInfo.text = "SEC_WARNING_INFO".localized
        labelInfo.font = UIFont.medium(size: 17)
        labelInfo.textColor = .white
        labelInfo.textAlignment = .center
        labelInfo.numberOfLines = 0
        let button = BaseButtonView(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SEC_IGNORE_TEXT".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.startColor = .black
        button.endColor = .black
        button.radius = Theme.current.mainButtonHeight / 2
        let buttonQuit = BaseButtonView(frame: .zero)
        buttonQuit.translatesAutoresizingMaskIntoConstraints = false
        buttonQuit.setTitle("SEC_QUIT".localized, for: .normal)
        buttonQuit.setTitleColor(.white, for: .normal)
        buttonQuit.startColor = .black
        buttonQuit.endColor = .black
        buttonQuit.radius = Theme.current.mainButtonHeight / 2
        self.view.addSubview(blurEffectView)
        self.view.addSubview(label)
        self.view.addSubview(labelInfo)
        self.view.addSubview(button)
        self.view.addSubview(buttonQuit)
        NSLayoutConstraint.activate([
            blurEffectView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            blurEffectView.topAnchor.constraint(equalTo: self.view.topAnchor),
            blurEffectView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            label.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: Theme.current.mainPaddings),
            label.topAnchor.constraint(greaterThanOrEqualTo: self.view.topAnchor, constant: 0),
            label.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -Theme.current.mainPaddings),
            labelInfo.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: Theme.current.mainPaddings),
            labelInfo.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            labelInfo.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -Theme.current.mainPaddings),
            labelInfo.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -20),
            button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: Theme.current.mainPaddings),
            button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -Theme.current.mainPaddings),
            button.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
            buttonQuit.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: Theme.current.mainPaddings),
            buttonQuit.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 4),
            buttonQuit.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -Theme.current.mainPaddings),
            buttonQuit.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
        ])
        button.addTarget(self, action: #selector(self.ignoreTapped), for: .touchUpInside)
        buttonQuit.addTarget(self, action: #selector(self.quitTapped), for: .touchUpInside)
    }
    
    @objc func ignoreTapped() {
        self.coordinator?.start()
    }
    
    @objc func quitTapped() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        }
    }
}
