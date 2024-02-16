//
//  ShowcaseViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 08/11/23.
//

import Foundation
import UIKit
import MapKit

class ShowcaseViewController: BaseViewController {
    
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
    private let imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.contentMode = .scaleAspectFill
        view.backgroundColor = Theme.current.secondTintColor
        return view
    }()
    private let cashbekView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.tintColor
        view.font = UIFont.semibold(size: 24)
        return view
    }()
    private let cashbekInfoView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.tintColor
        view.font = UIFont.semibold(size: 14)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    private let descView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.regular(size: 14)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    private let infoTitleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.medium(size: 16)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    private let infoView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.regular(size: 14)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    private let contactTitleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.medium(size: 16)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    private let contactView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 6
        return view
    }()
    private let addressTitleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.medium(size: 16)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    private let addressView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.current.primaryTextColor
        view.font = UIFont.regular(size: 14)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    private let mapView: MKMapView = {
        let view = MKMapView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.current.secondTintColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    let viewModel: ShowcaseViewModel
    let showcase: AppStructs.Showcase
    weak var coordinator: HomeCoordinator? = nil
    
    init(viewModel: ShowcaseViewModel, showcase: AppStructs.Showcase) {
        self.viewModel = viewModel
        self.showcase = showcase
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "SHOWCASE".localized
        self.navigationItem.largeTitleDisplayMode = .never
        self.view.backgroundColor = Theme.current.plainTableBackColor
        let lineView = UIView(backgroundColor: Theme.current.plainTableSeparatorColor)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.rootView)
        self.rootView.addSubview(self.imageView)
        self.rootView.addSubview(self.cashbekView)
        self.rootView.addSubview(self.cashbekInfoView)
        self.rootView.addSubview(lineView)
        self.rootView.addSubview(self.descView)
        self.rootView.addSubview(self.infoTitleView)
        self.rootView.addSubview(self.infoView)
        self.rootView.addSubview(self.contactTitleView)
        self.rootView.addSubview(self.contactView)
        self.rootView.addSubview(self.addressTitleView)
        self.rootView.addSubview(self.addressView)
        self.rootView.addSubview(self.mapView)
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
            self.imageView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.imageView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 10),
            self.imageView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor, multiplier: 0.6),
            self.cashbekView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.cashbekView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 20),
            self.cashbekView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.cashbekInfoView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.cashbekInfoView.topAnchor.constraint(equalTo: self.cashbekView.bottomAnchor, constant: 0),
            self.cashbekInfoView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            lineView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            lineView.topAnchor.constraint(equalTo: self.cashbekInfoView.bottomAnchor, constant: 20),
            lineView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            lineView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
            self.descView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.descView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 20),
            self.descView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.infoTitleView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.infoTitleView.topAnchor.constraint(equalTo: self.descView.bottomAnchor, constant: 20),
            self.infoTitleView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.infoView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.infoView.topAnchor.constraint(equalTo: self.infoTitleView.bottomAnchor, constant: 10),
            self.infoView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.contactTitleView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.contactTitleView.topAnchor.constraint(equalTo: self.infoView.bottomAnchor, constant: 20),
            self.contactTitleView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.contactView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.contactView.topAnchor.constraint(equalTo: self.contactTitleView.bottomAnchor, constant: 10),
            self.contactView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.addressTitleView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.addressTitleView.topAnchor.constraint(equalTo: self.contactView.bottomAnchor, constant: 20),
            self.addressTitleView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.addressView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.addressView.topAnchor.constraint(equalTo: self.addressTitleView.bottomAnchor, constant: 10),
            self.addressView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.mapView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.mapView.topAnchor.constraint(equalTo: self.addressView.bottomAnchor, constant: 20),
            self.mapView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.mapView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -20),
            self.mapView.heightAnchor.constraint(equalTo: self.mapView.widthAnchor, multiplier: 0.4),
        ])
        self.configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: nil)
    }
    
    func configure() {
        self.navigationItem.title = self.showcase.name
        self.imageView.loadImage(filePath: self.showcase.image)
        self.cashbekView.text = "\(self.showcase.cashBack)%"
        self.cashbekInfoView.text = self.showcase.payText
        self.descView.text = self.showcase.description
        self.infoTitleView.text = "CASHBEK_INFO".localized
        self.contactTitleView.text = "CASHBEK_CONTACT".localized
        self.addressTitleView.text = "CASHBEK_ADDRESS".localized
        if let v = self.showcase.validityDate {
            self.infoView.text = "\("CASHBEK_EXPIRE_DATE".localized)\n\(v)"
        }
        for item in self.showcase.contacts ?? [] {
            let itemView = HorizontalImageText(frame: .zero)
            itemView.heightAnchor.constraint(equalToConstant: 28).isActive = true
            itemView.textView.text = item.text
            itemView.textView.textColor = Theme.current.primaryTextColor
            itemView.textView.font = UIFont.regular(size: 14)
            itemView.iconView.contentMode = .scaleAspectFill
            itemView.iconView.clipsToBounds = true
            itemView.iconView.layer.cornerRadius = 6
            if let logo = item.logo {
                itemView.iconView.loadImage(filePath: logo)
            }
            self.contactView.addArrangedSubview(itemView)
        }
        self.addressView.text = self.showcase.address
        if Theme.current.dark {
            if #available(iOS 13.0, *) {
                self.mapView.overrideUserInterfaceStyle = .dark
            }
        } else {
            if #available(iOS 13.0, *) {
                self.mapView.overrideUserInterfaceStyle = .light
            }
        }
        if let lat = self.showcase.lat, let long = self.showcase.long {
            let region = MKCoordinateRegion.init(center: .init(latitude: lat, longitude: long), latitudinalMeters: 300, longitudinalMeters: 300)
            self.mapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.title = self.showcase.name
            annotation.coordinate = .init(latitude: lat, longitude: long)
            self.mapView.addAnnotation(annotation)
        } else {
            self.mapView.isHidden = true
        }
    }
}
