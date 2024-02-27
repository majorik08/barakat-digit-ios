//
//  AboutViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 30/10/23.
//

import Foundation
import UIKit
import RxSwift

class AboutViewController: BaseViewController {
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alwaysBounceVertical = true
        view.keyboardDismissMode = .interactive
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = Theme.current.plainTableBackColor
        return view
    }()
    private let rootView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let textLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 16)
        view.textColor = Theme.current.primaryTextColor
        view.numberOfLines = 0
        return view
    }()
    let nextButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.radius = 14
        view.setTitle("PROFILE_SHARE".localized, for: .normal)
        return view
    }()
    let viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "ABOUT_APP".localized
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.rootView)
        self.rootView.addSubview(self.textLabel)
        let rootHeight = self.rootView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        rootHeight.priority = UILayoutPriority(rawValue: 250)
        let lineView = UIView(backgroundColor: Theme.current.tintColor)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(lineView)
        self.rootView.addSubview(self.nextButton)
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
            self.textLabel.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.textLabel.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 20),
            self.textLabel.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            lineView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            lineView.topAnchor.constraint(equalTo: self.textLabel.bottomAnchor, constant: 20),
            lineView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            self.nextButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.nextButton.topAnchor.constraint(greaterThanOrEqualTo: lineView.bottomAnchor, constant: 20),
            self.nextButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -50),
            self.nextButton.heightAnchor.constraint(equalToConstant: 56),
        ])
        self.nextButton.addTarget(self, action: #selector(self.shareApp), for: .touchUpInside)
        self.loadDocs()
    }
    
    @objc func loadDocs() {
        self.showProgressView()
        self.viewModel.profileService.getDocs()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] item in
                guard let self = self else { return }
                self.textLabel.text = item.aboutApp
                self.hideProgressView()
            } onFailure: { [weak self] _ in
                guard let self = self else { return }
                self.hideProgressView()
                self.showServerErrorAlert()
            }.disposed(by: self.viewModel.disposeBag)
    }
    
    @objc func shareApp() {
        let activity: UIActivityViewController
        activity = UIActivityViewController(activityItems: ["INVITE".localizedFormat(arguments: Constants.AppName, Constants.AppUrl)], applicationActivities: nil)
        activity.popoverPresentationController?.sourceView = self.nextButton
        self.present(activity, animated: true, completion: nil)
    }
}
