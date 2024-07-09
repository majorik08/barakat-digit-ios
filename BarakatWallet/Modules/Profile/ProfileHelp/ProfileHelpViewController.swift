//
//  Help.swift
//  BarakatWallet
//
//  Created by Murodjon on 08/06/24.
//

import Foundation
import UIKit
import RxSwift

class ProfileHelpViewController: BaseViewController {
 
    let bottomSubTitleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 18)
        view.textColor = Theme.current.primaryTextColor
        view.textAlignment = .center
        view.text = "RESET_CALL_INFO".localized
        view.numberOfLines = 0
        return view
    }()
    let callButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.radius = 14
        view.titleLabel?.font = UIFont.medium(size: 17)
        view.setTitle("MAKE_CALL".localized, for: .normal)
        return view
    }()
    let buttonsStackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    weak var coordinator: ProfileCoordinator?
    let viewModel: ProfileViewModel
    var help: AppMethods.App.GetHelp.GetHelpResult? = nil
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "PROFILE_HELP".localized
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.bottomSubTitleView)
        self.view.addSubview(self.callButton)
        self.view.addSubview(self.buttonsStackView)
        NSLayoutConstraint.activate([
            self.bottomSubTitleView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: Theme.current.mainPaddings),
            self.bottomSubTitleView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
            self.bottomSubTitleView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -Theme.current.mainPaddings),
            self.callButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: Theme.current.mainPaddings),
            self.callButton.topAnchor.constraint(equalTo: self.bottomSubTitleView.bottomAnchor, constant: 70),
            self.callButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -Theme.current.mainPaddings),
            self.callButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
            self.buttonsStackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: Theme.current.mainPaddings),
            self.buttonsStackView.topAnchor.constraint(equalTo: self.callButton.bottomAnchor, constant: 40),
            self.buttonsStackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -Theme.current.mainPaddings),
            self.buttonsStackView.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor, constant: -30),
        ])
        self.callButton.addTarget(self, action: #selector(self.makeCall(_:)), for: .touchUpInside)
        self.getHelp()
    }
    
    func getHelp() {
        self.showProgressView()
        self.viewModel.profileService.getHelp()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] item in
                guard let self = self else { return }
                self.help = item
                self.setHelp(help: item)
                self.hideProgressView()
            } onFailure: { [weak self] error in
                guard let self = self else { return }
                self.hideProgressView()
                self.showApiError(title: "ERROR".localized, error: error)
            }.disposed(by: self.viewModel.disposeBag)
    }
    
    func setHelp(help: AppMethods.App.GetHelp.GetHelpResult) {
        for item in help.socials {
            self.buttonsStackView.addArrangedSubview(self.getButton(type: item))
        }
    }
    
    func getButton(type: AppMethods.App.GetHelp.GetHelpResult.Socials) -> CircleImageView {
        let button = CircleImageView(frame: .zero)
        button.tag = type.id
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1).isActive = true
        button.isUserInteractionEnabled = true
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.socialTapped(_:))))
        button.loadImage(filePath: Theme.current.dark ? type.darkLogo : type.logo)
        return button
    }
    
    @objc func socialTapped(_ sender: UITapGestureRecognizer) {
        guard let soc = self.help?.socials, let item = soc.first(where: { $0.id == sender.view?.tag }), let url = URL(string: item.link) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func makeCall(_ sender: UIButton) {
        guard let result = self.help else { return }
        guard let number = URL(string: "tel://+" + result.callCenter.digits) else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
}
