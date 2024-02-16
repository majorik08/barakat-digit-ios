//
//  TransferResultViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 25/10/23.
//

import Foundation
import UIKit

class TransferResultViewController: BaseViewController {
    
    let imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(name: .success)
        view.tintColor = Theme.current.tintColor
        return view
    }()
    let titleView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.medium(size: 18)
        view.text = "TRANSFER_IN_PROGRESS".localized
        view.textAlignment = .center
        return view
    }()
    let infoView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.secondaryTextColor
        view.font = UIFont.regular(size: 16)
        view.text = "TRANSFER_IN_PROGRESS_INFO".localized
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    let nextButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.radius = 14
        view.setTitle("GO_TO_MAIN".localized, for: .normal)
        return view
    }()
    let result: Bool
    weak var coordinator: TransferCoordinator?
    
    init(result: Bool) {
        self.result = result
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.titleView)
        self.view.addSubview(self.infoView)
        self.view.addSubview(self.nextButton)
        NSLayoutConstraint.activate([
            self.imageView.heightAnchor.constraint(equalToConstant: 100),
            self.imageView.widthAnchor.constraint(equalToConstant: 100),
            self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIApplication.statusBarHeight + 44 + 10),
            self.titleView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: Theme.current.mainPaddings),
            self.titleView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 30),
            self.titleView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -Theme.current.mainPaddings),
            self.infoView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: Theme.current.mainPaddings),
            self.infoView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 40),
            self.infoView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.topAnchor.constraint(greaterThanOrEqualTo: self.infoView.bottomAnchor, constant: 10),
            self.nextButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: Theme.current.mainPaddings),
            self.nextButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            self.nextButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
        ])
        self.nextButton.addTarget(self, action: #selector(self.animateDismis), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setStatusBarStyle(dark: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.setStatusBarStyle(dark: false)
    }
    
    @objc func animateDismis() {
        self.coordinator?.navigateToMain()
    }
}
