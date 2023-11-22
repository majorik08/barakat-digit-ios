//
//  PasscodeResetViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 20/11/23.
//

import Foundation
import UIKit

class PasscodeResetViewController: BaseViewController {
    
    let topTitleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 22)
        view.textColor = Theme.current.primaryTextColor
        view.textAlignment = .center
        view.text = "RESET_PASSCODE_TITLE".localized
        view.numberOfLines = 0
        return view
    }()
    let topSubTitleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 17)
        view.textColor = Theme.current.primaryTextColor
        view.textAlignment = .center
        view.text = "RESET_SMS_INFO".localized
        view.numberOfLines = 0
        return view
    }()
    let smsButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.radius = 14
        view.setTitle("SEND_SMS".localized, for: .normal)
        return view
    }()
    let bottomSubTitleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 17)
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
    
    weak var coordinator: PasscodeCoordinator?
    let viewModel: PasscodeViewModel
    
    init(viewModel: PasscodeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "CHANGE_PASSCODE_TITLE".localized
        self.view.backgroundColor = Theme.current.plainTableBackColor
        let lineView = UIView(backgroundColor: Theme.current.tintColor)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.topTitleView)
        self.view.addSubview(self.topSubTitleView)
        self.view.addSubview(self.smsButton)
        self.view.addSubview(lineView)
        self.view.addSubview(self.bottomSubTitleView)
        self.view.addSubview(self.callButton)
        self.view.addSubview(self.buttonsStackView)
        NSLayoutConstraint.activate([
            self.topTitleView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: Theme.current.mainPaddings),
            self.topTitleView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
            self.topTitleView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -Theme.current.mainPaddings),
            self.topSubTitleView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: Theme.current.mainPaddings),
            self.topSubTitleView.topAnchor.constraint(equalTo: self.topTitleView.bottomAnchor, constant: 30),
            self.topSubTitleView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -Theme.current.mainPaddings),
            self.smsButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: Theme.current.mainPaddings),
            self.smsButton.topAnchor.constraint(equalTo: self.topSubTitleView.bottomAnchor, constant: 30),
            self.smsButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -Theme.current.mainPaddings),
            self.smsButton.bottomAnchor.constraint(equalTo: lineView.topAnchor, constant: -50),
            self.smsButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
            lineView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: Theme.current.mainPaddings),
            lineView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -Theme.current.mainPaddings),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            self.bottomSubTitleView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: Theme.current.mainPaddings),
            self.bottomSubTitleView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 50),
            self.bottomSubTitleView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -Theme.current.mainPaddings),
            self.callButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: Theme.current.mainPaddings),
            self.callButton.topAnchor.constraint(equalTo: self.bottomSubTitleView.bottomAnchor, constant: 30),
            self.callButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -Theme.current.mainPaddings),
            self.callButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
            self.buttonsStackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: Theme.current.mainPaddings),
            self.buttonsStackView.topAnchor.constraint(equalTo: self.callButton.bottomAnchor, constant: 30),
            self.buttonsStackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -Theme.current.mainPaddings),
            self.buttonsStackView.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor, constant: -30),
        ])
        self.buttonsStackView.addArrangedSubview(self.getButton(type: .facebook))
        self.buttonsStackView.addArrangedSubview(self.getButton(type: .instagram))
        self.buttonsStackView.addArrangedSubview(self.getButton(type: .telegram))
        self.buttonsStackView.addArrangedSubview(self.getButton(type: .linkedin))
        self.callButton.addTarget(self, action: #selector(self.makeCall(_:)), for: .touchUpInside)
        self.callButton.addTarget(self, action: #selector(self.sendRecoverySms(_:)), for: .touchUpInside)
    }
    
    enum SocialNets: Int { case facebook = 1, instagram = 2, telegram = 3, linkedin = 4 }
    
    func getButton(type: SocialNets) -> BaseButtonView {
        let button = BaseButtonView(frame: .zero)
        button.circle = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Theme.current.whiteColor
        button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1).isActive = true
        button.addTarget(self, action: #selector(self.socialTapped(_:)), for: .touchUpInside)
        switch type {
        case .facebook:
            button.setImage(UIImage(name: .facebook_icon), for: .normal)
        case .instagram:
            button.setImage(UIImage(name: .instagram_icon), for: .normal)
        case .telegram:
            button.setImage(UIImage(name: .telegram_icon), for: .normal)
        case .linkedin:
            button.setImage(UIImage(name: .linkedin_icon), for: .normal)
        }
        return button
    }
    
    @objc func socialTapped(_ sender: BaseButtonView) {
        guard let type = SocialNets(rawValue: sender.tag) else { return }
        switch type {
        case .facebook:
            UIApplication.shared.open(URL(string: Constants.FacebookUrl)!)
        case .instagram:
            UIApplication.shared.open(URL(string: Constants.InstagramUrl)!)
        case .telegram:
            UIApplication.shared.open(URL(string: Constants.TelegramUrl)!)
        case .linkedin:
            UIApplication.shared.open(URL(string: Constants.LinkedinUrl)!)
        }
    }
    
    @objc func makeCall(_ sender: UIButton) {
        guard let number = URL(string: "tel://" + Constants.SupportNumber) else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    
    @objc func sendRecoverySms(_ sender: UIButton) {
        
    }
}
