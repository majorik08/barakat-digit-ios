//
//  ProfileLogoutViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 31/10/23.
//

import Foundation
import UIKit
import RxSwift

class ProfileLogoutViewController: BaseViewController {
    
    let bgView: GradientView = {
        let view = GradientView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startColor = Theme.current.mainGradientStartColor
        view.endColor = Theme.current.mainGradientEndColor
        view.alpha = 0.5
        return view
    }()
    let rootView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.navigationColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        return view
    }()
    let titleView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.tintColor
        view.font = UIFont.bold(size: 16)
        view.text = "LOGOUT_FROM_ACC".localized
        view.textAlignment = .center
        return view
    }()
    let subTitleView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.regular(size: 14)
        view.text = "LOGOUT_HELP".localized
        view.textAlignment = .center
        return view
    }()
    let imageView: CircleImageView = {
        let view = CircleImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(name: .logout)
        view.tintColor = .white
        view.backgroundColor = .systemRed
        return view
    }()
    let yesButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("YES".localized, for: .normal)
        view.setTitleColor(Theme.current.tintColor, for: .normal)
        view.titleLabel?.font = UIFont.bold(size: 17)
        return view
    }()
    let noButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("NO".localized, for: .normal)
        view.setTitleColor(Theme.current.tintColor, for: .normal)
        view.titleLabel?.font = UIFont.bold(size: 17)
        return view
    }()
    
    let viewModel: ProfileViewModel
    weak var coordinator: ProfileCoordinator?
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.view.addSubview(self.bgView)
        self.view.addSubview(self.rootView)
        self.rootView.addSubview(self.titleView)
        self.rootView.addSubview(self.subTitleView)
        self.rootView.addSubview(self.imageView)
        self.rootView.addSubview(self.yesButton)
        self.rootView.addSubview(self.noButton)
        NSLayoutConstraint.activate([
            self.bgView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.bgView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.bgView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.bgView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.rootView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: Theme.current.mainPaddings),
            self.rootView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -Theme.current.mainPaddings),
            self.rootView.heightAnchor.constraint(equalTo: self.rootView.widthAnchor, multiplier: 0.8),
            self.rootView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.titleView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 20),
            self.titleView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 20),
            self.titleView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -20),
            self.subTitleView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 20),
            self.subTitleView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 10),
            self.subTitleView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -20),
            self.imageView.centerXAnchor.constraint(equalTo: self.rootView.centerXAnchor),
            self.imageView.topAnchor.constraint(greaterThanOrEqualTo: self.subTitleView.bottomAnchor, constant: 20),
            self.imageView.bottomAnchor.constraint(lessThanOrEqualTo: self.yesButton.topAnchor, constant: -20),
            self.imageView.widthAnchor.constraint(equalTo: self.rootView.widthAnchor, multiplier: 0.2),
            self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor, multiplier: 1),
            self.imageView.centerYAnchor.constraint(equalTo: self.rootView.centerYAnchor),
            self.noButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -20),
            self.noButton.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -20),
            self.noButton.heightAnchor.constraint(equalToConstant: 20),
            self.noButton.widthAnchor.constraint(equalToConstant: 50),
            self.yesButton.rightAnchor.constraint(equalTo: self.noButton.leftAnchor, constant: -20),
            self.yesButton.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -20),
            self.yesButton.heightAnchor.constraint(equalToConstant: 20),
            self.yesButton.widthAnchor.constraint(equalToConstant: 50),
        ])
        self.rootView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        self.yesButton.addTarget(self, action: #selector(self.goToLogout), for: .touchUpInside)
        self.noButton.addTarget(self, action: #selector(self.goToPay), for: .touchUpInside)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.animateDismis()
    }
    
    @objc func goToPay() {
        self.animateDismis()
    }
    
    @objc func goToLogout() {
        self.showProgressView()
        self.viewModel.profileService.logout()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                Constants.Username = nil
                self?.hideProgressView()
                self?.coordinator?.logoutFromAccount()
            } onFailure: { [weak self] _ in
                self?.hideProgressView()
                self?.showServerErrorAlert()
            }.disposed(by: self.viewModel.disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.animateView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    func animateView() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.rootView.transform = .identity
        }, completion: {(finished: Bool) -> Void in })
    }
    
    func animateDismis() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {() -> Void in
            self.rootView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        }, completion: {(finished: Bool) -> Void in
            self.dismiss(animated: true)
        })
    }
}
