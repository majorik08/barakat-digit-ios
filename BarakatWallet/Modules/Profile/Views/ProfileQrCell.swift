//
//  ProfileQrCell.swift
//  BarakatWallet
//
//  Created by km1tj on 04/12/23.
//

import Foundation
import UIKit

protocol ProfileQrCellDelegate: AnyObject {
    func didTapDownload()
    func didTapShare()
    func didTapMyQr()
}

class ProfileQrCell: UITableViewCell {
    
    let rootView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    let myqrButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(Theme.current.tintColor, for: .normal)
        view.backgroundColor = Theme.current.plainTableBackColor
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        view.setTitle("MY_QR_CODE".localized, for: .normal)
        view.setImage(UIImage(name: .qr_button), for: .normal)
        view.imageView?.tintColor = Theme.current.tintColor
        view.titleEdgeInsets = .init(top: 0, left: 20, bottom: 0, right: 0)
        view.layer.borderColor = Theme.current.borderColor.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    let qrView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = Theme.current.primaryTextColor
        view.contentMode = .scaleAspectFit
        return view
    }()
    let shareButton: VerticalButtonView = {
        let view = VerticalButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.iconView.imageView.image = UIImage(name: .share)
        view.iconView.imageView.tintColor = Theme.current.whiteColor
        view.nameView.textColor = Theme.current.primaryTextColor
        view.nameView.text = "SHARE".localized
        view.nameView.font = UIFont.regular(size: 10)
        view.isUserInteractionEnabled = true
        return view
    }()
    let downloadButton: VerticalButtonView = {
        let view = VerticalButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.iconView.imageView.image = UIImage(name: .download)
        view.iconView.imageView.tintColor = Theme.current.whiteColor
        view.nameView.textColor = Theme.current.primaryTextColor
        view.nameView.text = "DOWNLOAD".localized
        view.nameView.font = UIFont.regular(size: 10)
        view.isUserInteractionEnabled = true
        return view
    }()
    weak var delegate: ProfileQrCellDelegate? = nil
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .none
        self.separatorInset = .zero
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.selectedBackgroundView = UIView(backgroundColor: .clear)
        self.contentView.addSubview(self.rootView)
        self.rootView.addSubview(self.myqrButton)
        self.rootView.addSubview(self.qrView)
        self.rootView.addSubview(self.shareButton)
        self.rootView.addSubview(self.downloadButton)
        NSLayoutConstraint.activate([
            self.rootView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Theme.current.mainPaddings),
            self.rootView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.rootView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.rootView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            self.myqrButton.centerXAnchor.constraint(equalTo: self.rootView.centerXAnchor),
            self.myqrButton.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 10),
            self.myqrButton.widthAnchor.constraint(equalTo: self.rootView.widthAnchor, multiplier: 0.7),
            self.myqrButton.heightAnchor.constraint(equalToConstant: 44),
            self.qrView.leftAnchor.constraint(equalTo: self.myqrButton.leftAnchor),
            self.qrView.topAnchor.constraint(equalTo: self.myqrButton.bottomAnchor, constant: 20),
            self.qrView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0),
            self.qrView.heightAnchor.constraint(equalTo: self.qrView.widthAnchor, multiplier: 1),
            self.downloadButton.leftAnchor.constraint(equalTo: self.qrView.rightAnchor, constant: 10),
            self.downloadButton.topAnchor.constraint(equalTo: self.myqrButton.bottomAnchor, constant: 30),
            self.downloadButton.rightAnchor.constraint(equalTo: self.myqrButton.rightAnchor),
            self.downloadButton.widthAnchor.constraint(equalToConstant: 64),
            self.downloadButton.heightAnchor.constraint(equalToConstant: 76),
            self.shareButton.leftAnchor.constraint(equalTo: self.qrView.rightAnchor, constant: 10),
            self.shareButton.topAnchor.constraint(greaterThanOrEqualTo: self.downloadButton.bottomAnchor),
            self.shareButton.rightAnchor.constraint(equalTo: self.myqrButton.rightAnchor),
            self.shareButton.widthAnchor.constraint(equalToConstant: 64),
            self.shareButton.heightAnchor.constraint(equalToConstant: 76),
            self.shareButton.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: 0),
        ])
        self.myqrButton.addTarget(self, action: #selector(self.myQrButtonTapped), for: .touchUpInside)
        self.shareButton.addTarget(self, action: #selector(self.shareButtonTapped), for: .touchUpInside)
        self.downloadButton.addTarget(self, action: #selector(self.downloadButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(clientInfo: AppStructs.ClientInfo) {
        self.qrView.image = UIImage.generateAppQRCode(from: clientInfo.wallet)
        self.myqrButton.setTitleColor(Theme.current.tintColor, for: .normal)
        self.myqrButton.backgroundColor = Theme.current.plainTableBackColor
        self.myqrButton.imageView?.tintColor = Theme.current.tintColor
        self.qrView.tintColor = Theme.current.primaryTextColor
        self.shareButton.iconView.imageView.tintColor = Theme.current.whiteColor
        self.shareButton.nameView.textColor = Theme.current.primaryTextColor
        self.downloadButton.iconView.imageView.tintColor = Theme.current.whiteColor
        self.downloadButton.nameView.textColor = Theme.current.primaryTextColor
    }
    
    @objc func myQrButtonTapped() {
        self.delegate?.didTapMyQr()
    }
    
    @objc func shareButtonTapped() {
        self.delegate?.didTapShare()
    }
    
    @objc func downloadButtonTapped() {
        self.delegate?.didTapDownload()
    }
}
