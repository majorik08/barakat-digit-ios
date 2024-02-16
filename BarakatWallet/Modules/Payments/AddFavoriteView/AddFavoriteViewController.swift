//
//  File.swift
//  BarakatWallet
//
//  Created by km1tj on 11/11/23.
//

import Foundation
import UIKit

protocol AddFavoriteViewControllerDelegate: AnyObject {
    func addFavorite(name: String)
}

class AddFavoriteViewController: BaseViewController {
    
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
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.regular(size: 20)
        view.text = "APPLY_CONFIRM".localized
        return view
    }()
    let nameField: LabeledField = {
        let view = LabeledField(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.labelView.text = "FAV_NAME".localized
        view.labelView.font = UIFont.regular(size: 20)
        view.labelView.textColor = Theme.current.tintColor
        view.fieldView.textColor = Theme.current.primaryTextColor
        view.fieldView.font = UIFont.regular(size: 20)
        return view
    }()
    let yesButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("ADD".localized, for: .normal)
        view.setTitleColor(Theme.current.tintColor, for: .normal)
        view.titleLabel?.font = UIFont.bold(size: 17)
        return view
    }()
    let noButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("CLOSE".localized, for: .normal)
        view.setTitleColor(Theme.current.tintColor, for: .normal)
        view.titleLabel?.font = UIFont.bold(size: 17)
        return view
    }()
    weak var delegate: AddFavoriteViewControllerDelegate?
    
    init() {
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
        self.rootView.addSubview(self.nameField)
        self.rootView.addSubview(self.yesButton)
        self.rootView.addSubview(self.noButton)
        NSLayoutConstraint.activate([
            self.bgView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.bgView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.bgView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.bgView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.rootView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: Theme.current.mainPaddings),
            self.rootView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -Theme.current.mainPaddings),
            self.rootView.heightAnchor.constraint(equalTo: self.rootView.widthAnchor, multiplier: 0.5),
            self.rootView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.titleView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 20),
            self.titleView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 20),
            self.titleView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -20),
            self.nameField.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 20),
            self.nameField.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 20),
            self.nameField.heightAnchor.constraint(equalToConstant: 72),
            self.nameField.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -20),
            self.nameField.bottomAnchor.constraint(lessThanOrEqualTo: self.yesButton.topAnchor, constant: -20),
            self.noButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 20),
            self.noButton.rightAnchor.constraint(equalTo: self.rootView.centerXAnchor, constant: 0),
            self.noButton.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -20),
            self.noButton.heightAnchor.constraint(equalToConstant: 24),
            self.yesButton.leftAnchor.constraint(equalTo: self.rootView.centerXAnchor, constant: 0),
            self.yesButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -20),
            self.yesButton.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -20),
            self.yesButton.heightAnchor.constraint(equalToConstant: 24),
        ])
        self.rootView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        self.yesButton.addTarget(self, action: #selector(self.goToLogout), for: .touchUpInside)
        self.noButton.addTarget(self, action: #selector(self.goToPay), for: .touchUpInside)
        self.nameField.fieldView.becomeFirstResponder()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.animateDismis()
    }
    
    @objc func goToPay() {
        self.animateDismis()
    }
    
    @objc func goToLogout() {
        self.delegate?.addFavorite(name: self.nameField.fieldView.text ?? "")
        self.animateDismis()
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
