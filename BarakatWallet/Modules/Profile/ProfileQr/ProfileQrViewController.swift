//
//  ProfileQrViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 19/02/24.
//

import Foundation
import UIKit

class ProfileQrViewController: BaseViewController {
    
    let titleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 19)
        view.textColor = Theme.current.primaryTextColor
        view.text = "MY_QR_CODE".localized
        view.textAlignment = .center
        return view
    }()
    let infoView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 17)
        view.textColor = Theme.current.primaryTextColor
        view.text = "QR_SHOW_HELP".localized
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    let imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 14
        view.layer.shadowColor = Theme.current.shadowColor.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        return view
    }()
    let shareButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(Theme.current.tintColor, for: .normal)
        view.backgroundColor = Theme.current.plainTableBackColor
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        view.setTitle("SHARE".localized, for: .normal)
        view.layer.borderColor = Theme.current.borderColor.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let client: AppStructs.ClientInfo
    
    init(client: AppStructs.ClientInfo) {
        self.client = client
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.titleView)
        self.view.addSubview(self.infoView)
        self.view.addSubview(self.shareButton)
        NSLayoutConstraint.activate([
            self.titleView.leftAnchor.constraint(equalTo: self.imageView.leftAnchor, constant: 0),
            self.titleView.rightAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: 0),
            self.infoView.leftAnchor.constraint(equalTo: self.imageView.leftAnchor, constant: 0),
            self.infoView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 10),
            self.infoView.rightAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: 0),
            self.infoView.bottomAnchor.constraint(equalTo: self.imageView.topAnchor, constant: -20),
            self.imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -30),
            self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7),
            self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor, multiplier: 1),
            self.shareButton.leftAnchor.constraint(equalTo: self.imageView.leftAnchor, constant: 0),
            self.shareButton.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 20),
            self.shareButton.rightAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: 0),
            self.shareButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
        ])
        self.imageView.image = UIImage.generateAppQRCode(from: self.client.wallet)
        self.shareButton.addTarget(self, action: #selector(self.shareButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: nil)
    }
    
    @objc func shareButtonTapped() {
        guard let image = UIImage.generateAppQRCode(from: self.client.wallet) else { return }
        let activity: UIActivityViewController
        activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activity.popoverPresentationController?.sourceView = self.shareButton
        self.present(activity, animated: true, completion: nil)
    }
}
