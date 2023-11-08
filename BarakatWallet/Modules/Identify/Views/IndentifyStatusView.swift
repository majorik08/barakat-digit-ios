//
//  IndentifyStatusView.swift
//  BarakatWallet
//
//  Created by km1tj on 30/10/23.
//

import Foundation
import UIKit

class IndentifyStatusView: UIView {
    
    let topView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 14
        view.layer.shadowColor = Theme.current.shadowColor.cgColor
        view.layer.shadowOpacity = 0.6
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.backgroundColor = Theme.current.plainTableCellColor
        return view
    }()
    let topAvatar: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    let topTitle: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 20)
        view.textAlignment = .center
        return view
    }()
    let limitsTitle: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 18)
        view.text = "LIMITS".localized
        view.textColor = Theme.current.primaryTextColor
        return view
    }()
    let topLimitView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 14
        view.layer.shadowColor = Theme.current.shadowColor.cgColor
        view.layer.shadowOpacity = 0.6
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.backgroundColor = Theme.current.plainTableCellColor
        return view
    }()
    let topLimitTitle: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 18)
        view.text = "MAX_IN_WALLET".localized
        view.textColor = Theme.current.primaryTextColor
        return view
    }()
    let topLimitDetail: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 24)
        view.text = "LIMITS".localized
        view.textColor = Theme.current.primaryTextColor
        return view
    }()
    let bottomLimitView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 14
        view.layer.shadowColor = Theme.current.shadowColor.cgColor
        view.layer.shadowOpacity = 0.6
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.backgroundColor = Theme.current.plainTableCellColor
        return view
    }()
    let bottomLimitTitle: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 18)
        view.text = "MAX_PAY_MONTH".localized
        view.textColor = Theme.current.primaryTextColor
        return view
    }()
    let bottomLimitDetail: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 24)
        view.text = "LIMITS".localized
        view.textColor = Theme.current.primaryTextColor
        return view
    }()
    let capabilitesLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 18)
        view.text = "CAPABILITIES".localized
        view.textColor = Theme.current.primaryTextColor
        return view
    }()
    let servicePayItem: CapabilityView = {
        let view = CapabilityView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageView.image = UIImage(name: .checked)
        view.tintColor = Theme.current.tintColor
        view.titleView.text = "PAY_SERVICES_PERMISSION".localized
        return view
    }()
    let qrItem: CapabilityView = {
        let view = CapabilityView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageView.image = UIImage(name: .checked)
        view.tintColor = Theme.current.tintColor
        view.titleView.text = "PAY_QR_PERMISSION".localized
        return view
    }()
    let orderCardItem: CapabilityView = {
        let view = CapabilityView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageView.image = UIImage(name: .check_x)
        view.tintColor = .systemRed
        view.titleView.text = "ORDER_CARD_PERMISSION".localized
        return view
    }()
    let transferItem: CapabilityView = {
        let view = CapabilityView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageView.image = UIImage(name: .check_x)
        view.tintColor = .systemRed
        view.titleView.text = "TRANSFER_PERMISSION".localized
        return view
    }()
    let cashItem: CapabilityView = {
        let view = CapabilityView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageView.image = UIImage(name: .check_x)
        view.tintColor = .systemRed
        view.titleView.text = "CASH_PERMISSION".localized
        return view
    }()
    let convertItem: CapabilityView = {
        let view = CapabilityView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageView.image = UIImage(name: .check_x)
        view.tintColor = .systemRed
        view.titleView.text = "CONVERT_PERMISSION".localized
        return view
    }()
    let creditItem: CapabilityView = {
        let view = CapabilityView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageView.image = UIImage(name: .check_x)
        view.tintColor = .systemRed
        view.titleView.text = "CREDIT_PERMISSION".localized
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(self.topView)
        self.topView.addSubview(self.topAvatar)
        self.topView.addSubview(self.topTitle)
        self.addSubview(self.limitsTitle)
        self.addSubview(self.topLimitView)
        self.topLimitView.addSubview(self.topLimitTitle)
        self.topLimitView.addSubview(self.topLimitDetail)
        self.addSubview(self.bottomLimitView)
        self.bottomLimitView.addSubview(self.bottomLimitTitle)
        self.bottomLimitView.addSubview(self.bottomLimitDetail)
        self.addSubview(self.capabilitesLabel)
        self.addSubview(self.servicePayItem)
        self.addSubview(self.qrItem)
        self.addSubview(self.orderCardItem)
        self.addSubview(self.transferItem)
        self.addSubview(self.cashItem)
        self.addSubview(self.convertItem)
        self.addSubview(self.creditItem)
        NSLayoutConstraint.activate([
            self.topView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.topView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            self.topView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.topView.heightAnchor.constraint(equalTo: self.topView.widthAnchor, multiplier: 0.36),
            self.topAvatar.topAnchor.constraint(equalTo: self.topView.topAnchor, constant: 10),
            self.topAvatar.centerXAnchor.constraint(equalTo: self.topView.centerXAnchor),
            self.topAvatar.widthAnchor.constraint(equalTo: self.topAvatar.heightAnchor, multiplier: 1),
            self.topTitle.leftAnchor.constraint(equalTo: self.topView.leftAnchor, constant: 0),
            self.topTitle.topAnchor.constraint(equalTo: self.topAvatar.bottomAnchor, constant: 10),
            self.topTitle.rightAnchor.constraint(equalTo: self.topView.rightAnchor, constant: 0),
            self.topTitle.bottomAnchor.constraint(equalTo: self.topView.bottomAnchor, constant: -16),
            self.topTitle.heightAnchor.constraint(equalToConstant: 20),
            self.limitsTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.limitsTitle.topAnchor.constraint(equalTo: self.topView.bottomAnchor, constant: 30),
            self.limitsTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.topLimitView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.topLimitView.topAnchor.constraint(equalTo: self.limitsTitle.bottomAnchor, constant: 10),
            self.topLimitView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.topLimitTitle.leftAnchor.constraint(equalTo: self.topLimitView.leftAnchor, constant: 16),
            self.topLimitTitle.topAnchor.constraint(equalTo: self.topLimitView.topAnchor, constant: 10),
            self.topLimitTitle.rightAnchor.constraint(equalTo: self.topLimitView.rightAnchor, constant: -16),
            self.topLimitDetail.leftAnchor.constraint(equalTo: self.topLimitView.leftAnchor, constant: 16),
            self.topLimitDetail.topAnchor.constraint(equalTo: self.topLimitTitle.bottomAnchor, constant: 10),
            self.topLimitDetail.rightAnchor.constraint(equalTo: self.topLimitView.rightAnchor, constant: -16),
            self.topLimitDetail.bottomAnchor.constraint(equalTo: self.topLimitView.bottomAnchor, constant: -10),
            self.bottomLimitView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.bottomLimitView.topAnchor.constraint(equalTo: self.topLimitView.bottomAnchor, constant: 20),
            self.bottomLimitView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.bottomLimitTitle.leftAnchor.constraint(equalTo: self.bottomLimitView.leftAnchor, constant: 16),
            self.bottomLimitTitle.topAnchor.constraint(equalTo: self.bottomLimitView.topAnchor, constant: 10),
            self.bottomLimitTitle.rightAnchor.constraint(equalTo: self.bottomLimitView.rightAnchor, constant: -16),
            self.bottomLimitDetail.leftAnchor.constraint(equalTo: self.bottomLimitView.leftAnchor, constant: 16),
            self.bottomLimitDetail.topAnchor.constraint(equalTo: self.bottomLimitTitle.bottomAnchor, constant: 10),
            self.bottomLimitDetail.rightAnchor.constraint(equalTo: self.bottomLimitView.rightAnchor, constant: -16),
            self.bottomLimitDetail.bottomAnchor.constraint(equalTo: self.bottomLimitView.bottomAnchor, constant: -10),
            self.capabilitesLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.capabilitesLabel.topAnchor.constraint(equalTo: self.bottomLimitView.bottomAnchor, constant: 20),
            self.capabilitesLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.servicePayItem.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.servicePayItem.topAnchor.constraint(equalTo: self.capabilitesLabel.bottomAnchor, constant: 10),
            self.servicePayItem.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.servicePayItem.heightAnchor.constraint(equalToConstant: 24),
            self.qrItem.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.qrItem.topAnchor.constraint(equalTo: self.servicePayItem.bottomAnchor, constant: 10),
            self.qrItem.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.qrItem.heightAnchor.constraint(equalToConstant: 24),
            self.orderCardItem.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.orderCardItem.topAnchor.constraint(equalTo: self.qrItem.bottomAnchor, constant: 10),
            self.orderCardItem.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.orderCardItem.heightAnchor.constraint(equalToConstant: 24),
            self.transferItem.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.transferItem.topAnchor.constraint(equalTo: self.orderCardItem.bottomAnchor, constant: 10),
            self.transferItem.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.transferItem.heightAnchor.constraint(equalToConstant: 24),
            self.cashItem.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.cashItem.topAnchor.constraint(equalTo: self.transferItem.bottomAnchor, constant: 10),
            self.cashItem.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.cashItem.heightAnchor.constraint(equalToConstant: 24),
            self.convertItem.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.convertItem.topAnchor.constraint(equalTo: self.cashItem.bottomAnchor, constant: 10),
            self.convertItem.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.convertItem.heightAnchor.constraint(equalToConstant: 24),
            self.creditItem.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.creditItem.topAnchor.constraint(equalTo: self.convertItem.bottomAnchor, constant: 10),
            self.creditItem.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.creditItem.heightAnchor.constraint(equalToConstant: 24),
            self.creditItem.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func themeChanged(newTheme: Theme) {
        self.topView.backgroundColor = Theme.current.plainTableCellColor
        self.topView.layer.shadowColor = Theme.current.shadowColor.cgColor
        self.limitsTitle.textColor = Theme.current.primaryTextColor
        self.topLimitView.backgroundColor = Theme.current.plainTableCellColor
        self.topLimitView.layer.shadowColor = Theme.current.shadowColor.cgColor
        self.topLimitTitle.textColor = Theme.current.primaryTextColor
        self.topLimitDetail.textColor = Theme.current.primaryTextColor
        self.bottomLimitView.backgroundColor = Theme.current.plainTableCellColor
        self.bottomLimitView.layer.shadowColor = Theme.current.shadowColor.cgColor
        self.bottomLimitTitle.textColor = Theme.current.primaryTextColor
        self.bottomLimitDetail.textColor = Theme.current.primaryTextColor
        self.capabilitesLabel.textColor = Theme.current.primaryTextColor
        self.servicePayItem.tintColor = Theme.current.tintColor
        self.servicePayItem.titleView.textColor = Theme.current.primaryTextColor
    }
}
