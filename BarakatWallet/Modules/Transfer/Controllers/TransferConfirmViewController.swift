//
//  TransferConfirmViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 25/10/23.
//

import Foundation
import UIKit

class TransferConfirmViewController: BaseViewController {
    
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
    let topAnchorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red:0.73, green:0.74, blue:0.75, alpha:1.0)
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
        return view
    }()
    let titleView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.bold(size: 17)
        view.text = "TRANSFER_CONFIRM".localized
        view.textAlignment = .center
        return view
    }()
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.current.groupedTableBackColor
        return view
    }()
    let nextButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.radius = 14
        view.setTitle("CONFIRM".localized, for: .normal)
        return view
    }()
    
    let type: TransferType
    let sender: TransferIdentifier
    let receiver: TransferIdentifier
    let amount: Double
    let currency: Currency
    
    weak var coordinator: TransferCoordinator?
    
    init(type: TransferType, sender: TransferIdentifier, receiver: TransferIdentifier, amount: Double, currency: Currency) {
        self.type = type
        self.amount = amount
        self.currency = currency
        self.sender = sender
        self.receiver = receiver
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
        self.rootView.addSubview(self.topAnchorView)
        self.rootView.addSubview(self.titleView)
        self.rootView.addSubview(self.containerView)
        self.containerView.addSubview(self.nextButton)
        NSLayoutConstraint.activate([
            self.bgView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.bgView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.bgView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.bgView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.rootView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.rootView.topAnchor.constraint(greaterThanOrEqualTo: self.view.topAnchor),
            self.rootView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.rootView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.topAnchorView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 16),
            self.topAnchorView.centerXAnchor.constraint(equalTo: self.rootView.centerXAnchor),
            self.topAnchorView.heightAnchor.constraint(equalToConstant: 6),
            self.topAnchorView.widthAnchor.constraint(equalToConstant: 42),
            self.titleView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 16),
            self.titleView.topAnchor.constraint(equalTo: self.topAnchorView.bottomAnchor, constant: 20),
            self.titleView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -16),
            self.containerView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 20),
            self.containerView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
            self.containerView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
            self.containerView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0),
            
            
            
            self.nextButton.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 20),
            self.nextButton.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 24),
            self.nextButton.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -24),
            self.nextButton.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -40),
            self.nextButton.heightAnchor.constraint(equalToConstant: 56),
        ])
        self.rootView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        self.nextButton.addTarget(self, action: #selector(self.goToPay), for: .touchUpInside)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.animateDismis()
    }
    
    @objc func goToPay() {
        self.dismiss(animated: true)
        self.coordinator?.presentResult(type: self.type, sender: self.sender, receiver: self.receiver, amount: self.amount, currency: self.currency, result: true)
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
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {() -> Void in
            self.rootView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        }, completion: {(finished: Bool) -> Void in
            self.dismiss(animated: true)
        })
    }
}
