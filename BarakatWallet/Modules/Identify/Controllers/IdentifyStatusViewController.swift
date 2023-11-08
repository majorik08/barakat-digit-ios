//
//  IndentifyMainViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 30/10/23.
//

import Foundation
import UIKit

class IndentifyMainViewController: BaseViewController {
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alwaysBounceVertical = true
        view.keyboardDismissMode = .interactive
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        return view
    }()
    private let rootView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let statusView: IndentifyStatusView = {
        let view = IndentifyStatusView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let nextButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.radius = 14
        view.setTitle("GET_LIMIT".localized, for: .normal)
        return view
    }()
    
    let viewModel: IdentifyViewModel
    weak var coordinator: IdentifyCoordinator?
    
    init(viewModel: IdentifyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "IDENTIFICATION".localized
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.rootView)
        self.rootView.addSubview(self.statusView)
        self.rootView.addSubview(self.nextButton)
        let rootHeight = self.rootView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        rootHeight.priority = UILayoutPriority(rawValue: 250)
        NSLayoutConstraint.activate([
            self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.rootView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.rootView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.rootView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            self.rootView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            rootView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            rootHeight,
            self.statusView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
            self.statusView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 20),
            self.statusView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
            self.nextButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 30),
            self.nextButton.topAnchor.constraint(equalTo: self.statusView.bottomAnchor, constant: 20),
            self.nextButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -30),
            self.nextButton.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -30),
            self.nextButton.heightAnchor.constraint(equalToConstant: 56),
        ])
        self.nextButton.addTarget(self, action: #selector(self.navigateToVerify), for: .touchUpInside)
        self.setStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: nil)
    }
    
    override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.statusView.themeChanged(newTheme: newTheme)
        self.nextButton.startColor = newTheme.mainGradientStartColor
        self.nextButton.endColor = newTheme.mainGradientEndColor
        self.setStatus()
    }
    
    @objc func navigateToVerify() {
        self.coordinator?.navigateToVerify()
    }
    
    func setStatus() {
        self.statusView.topTitle.text = "НЕ ИДЕНТИФИЦИРОВАННЫЙ"
        self.statusView.topTitle.textColor = .systemRed
        self.statusView.topAvatar.image = UIImage(name: .status_id)
        self.statusView.topAvatar.tintColor = UIColor(red: 0.20, green: 0.58, blue: 0.84, alpha: 1.00)
        self.statusView.topLimitDetail.text = "1360 сомони"
        self.statusView.bottomLimitDetail.text = "3400 сомони"
    }
}
