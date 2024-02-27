//
//  CardOrderViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 11/12/23.
//

import Foundation
import UIKit
import RxSwift

class CardOrderViewController: BaseViewController, CardRegionViewControllerDelegate {
    
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
    private let nextButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.radius = 14
        view.setTitle("CONTINUE".localized, for: .normal)
        view.isEnabled = false
        return view
    }()
    private let cardIconView: GradientImageView = {
        let view = GradientImageView(insets: .zero)
        view.circleImage = false
        view.imageView.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.current.plainTableCellColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    private let cardNameView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 16)
        view.textColor = Theme.current.primaryTextColor
        view.numberOfLines = 0
        return view
    }()
    private let cardInfoView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.medium(size: 16)
        view.textColor = Theme.current.primaryTextColor
        view.numberOfLines = 0
        return view
    }()
    private let clientInfoLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 14)
        view.text = "CLIENT_CARD_INFO".localized
        view.textColor = Theme.current.secondaryTextColor
        view.numberOfLines = 0
        return view
    }()
    private let toolbar: UIToolbar = {
        let view = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        view.backgroundColor = Theme.current.plainTableBackColor
        return view
    }()
    private let firstnameField: BaseTextFiled = {
        let view = BaseTextFiled()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topLabel.text =  "FIRSTNAME".localized
        view.textField.textColor = Theme.current.primaryTextColor
        view.textField.minimumFontSize = 14
        view.textField.adjustsFontSizeToFitWidth = true
        view.textField.returnKeyType = .done
        return view
    }()
    private let lastnameField: BaseTextFiled = {
        let view = BaseTextFiled()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topLabel.text =  "LASTNAME".localized
        view.textField.textColor = Theme.current.primaryTextColor
        view.textField.minimumFontSize = 14
        view.textField.adjustsFontSizeToFitWidth = true
        view.textField.returnKeyType = .done
        return view
    }()
    private let surnameField: BaseTextFiled = {
        let view = BaseTextFiled()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topLabel.text =  "SURNAME".localized
        view.textField.textColor = Theme.current.primaryTextColor
        view.textField.minimumFontSize = 14
        view.textField.adjustsFontSizeToFitWidth = true
        view.textField.returnKeyType = .done
        return view
    }()
    private let phoneNumberField: BaseTextFiled = {
        let view = BaseTextFiled()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topLabel.text = "PHONE_NUMBER".localized
        view.textField.textColor = Theme.current.primaryTextColor
        view.textField.minimumFontSize = 14
        view.textField.adjustsFontSizeToFitWidth = true
        view.textField.returnKeyType = .done
        view.textField.keyboardType = .phonePad
        return view
    }()
    private let shipInfoLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 14)
        view.text = "SHIP_INFO".localized
        view.textColor = Theme.current.secondaryTextColor
        view.numberOfLines = 0
        return view
    }()
    private let shipSegment: UISegmentedControl = {
        let view = UISegmentedControl(items: ["SHIP_DOSTAVKA".localized, "SHIP_SAMOVIVOS".localized])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.selectedSegmentIndex = 0
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        if #available(iOS 13.0, *) {
            view.selectedSegmentTintColor = Theme.current.tintColor
        }
        return view
    }()
    private let cityField: BaseTextFiled = {
        let view = BaseTextFiled()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topLabel.text = "CITY".localized
        view.textField.textColor = Theme.current.primaryTextColor
        view.textField.minimumFontSize = 14
        view.textField.adjustsFontSizeToFitWidth = true
        view.textField.returnKeyType = .done
        view.textField.keyboardType = .phonePad
        view.textField.isEnabled = false
        view.rightImage.image = UIImage(name: .down_arrow)
        view.rightImage.tintColor = Theme.current.primaryTextColor
        view.isUserInteractionEnabled = true
        return view
    }()
    private let addressField: BaseTextFiled = {
        let view = BaseTextFiled()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topLabel.text = "SHIP_ADDRESS".localized
        view.textField.textColor = Theme.current.primaryTextColor
        view.textField.minimumFontSize = 14
        view.textField.adjustsFontSizeToFitWidth = true
        view.textField.returnKeyType = .done
        view.textField.keyboardType = .phonePad
        view.textField.isEnabled = false
        view.rightImage.image = UIImage(name: .down_arrow)
        view.rightImage.tintColor = Theme.current.primaryTextColor
        view.isHidden = true
        view.isUserInteractionEnabled = true
        return view
    }()
    private let infoView: PaymentServiceInfoView = {
        let view = PaymentServiceInfoView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var addressHeight: NSLayoutConstraint!
    private var isExpand: Bool = false
    
    weak var coordinator: CardsCoordinator? = nil
    let viewModel: CardsViewModel
    let cardItem: AppStructs.CreditDebitCardTypes
    let regions: [AppStructs.Region]
    var selectedRegion: AppStructs.Region? {
        didSet {
            self.cityField.textField.text = selectedRegion?.name ?? ""
            self.shipSelected()
        }
    }
    var selectedPoint: AppStructs.Region.Points? {
        didSet {
            self.addressField.textField.text = selectedPoint?.name ?? ""
        }
    }
    
    init(viewModel: CardsViewModel, cardItem: AppStructs.CreditDebitCardTypes, regions: [AppStructs.Region]) {
        self.viewModel = viewModel
        self.cardItem = cardItem
        self.regions = regions
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:)")
    }
                   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.navigationItem.title = "ORDER_CARD".localized
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.rootView)
        self.rootView.addSubview(self.cardIconView)
        self.rootView.addSubview(self.cardNameView)
        self.rootView.addSubview(self.cardInfoView)
        self.rootView.addSubview(self.clientInfoLabel)
        self.rootView.addSubview(self.firstnameField)
        self.rootView.addSubview(self.lastnameField)
        self.rootView.addSubview(self.surnameField)
        self.rootView.addSubview(self.phoneNumberField)
        self.rootView.addSubview(self.shipInfoLabel)
        self.rootView.addSubview(self.shipSegment)
        self.rootView.addSubview(self.cityField)
        self.rootView.addSubview(self.addressField)
        self.rootView.addSubview(self.infoView)
        self.rootView.addSubview(self.nextButton)
        let rootHeight = self.rootView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        rootHeight.priority = UILayoutPriority(rawValue: 250)
        self.addressHeight = self.addressField.heightAnchor.constraint(equalToConstant: 0)
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
            self.cardIconView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.cardIconView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 10),
            self.cardIconView.heightAnchor.constraint(equalToConstant: 80),
            self.cardIconView.widthAnchor.constraint(equalToConstant: 128),
            self.cardNameView.leftAnchor.constraint(equalTo: self.cardIconView.rightAnchor, constant: 20),
            self.cardNameView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 12),
            self.cardNameView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.cardInfoView.leftAnchor.constraint(equalTo: self.cardIconView.rightAnchor, constant: 20),
            self.cardInfoView.topAnchor.constraint(equalTo: self.cardNameView.bottomAnchor, constant: 0),
            self.cardInfoView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.clientInfoLabel.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.clientInfoLabel.topAnchor.constraint(equalTo: self.cardIconView.bottomAnchor, constant: 10),
            self.clientInfoLabel.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.firstnameField.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.firstnameField.topAnchor.constraint(equalTo: self.clientInfoLabel.bottomAnchor, constant: 10),
            self.firstnameField.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.firstnameField.heightAnchor.constraint(equalToConstant: 56),
            self.lastnameField.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.lastnameField.topAnchor.constraint(equalTo: self.firstnameField.bottomAnchor, constant: 10),
            self.lastnameField.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.lastnameField.heightAnchor.constraint(equalToConstant: 56),
            self.surnameField.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.surnameField.topAnchor.constraint(equalTo: self.lastnameField.bottomAnchor, constant: 10),
            self.surnameField.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.surnameField.heightAnchor.constraint(equalToConstant: 56),
            self.phoneNumberField.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.phoneNumberField.topAnchor.constraint(equalTo: self.surnameField.bottomAnchor, constant: 10),
            self.phoneNumberField.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.phoneNumberField.heightAnchor.constraint(equalToConstant: 56),
            self.shipInfoLabel.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.shipInfoLabel.topAnchor.constraint(equalTo: self.phoneNumberField.bottomAnchor, constant: 10),
            self.shipInfoLabel.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.shipSegment.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.shipSegment.topAnchor.constraint(equalTo: self.shipInfoLabel.bottomAnchor, constant: 10),
            self.shipSegment.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.shipSegment.heightAnchor.constraint(equalToConstant: 48),
            self.cityField.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.cityField.topAnchor.constraint(equalTo: self.shipSegment.bottomAnchor, constant: 10),
            self.cityField.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.cityField.heightAnchor.constraint(equalToConstant: 56),
            self.addressField.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.addressField.topAnchor.constraint(equalTo: self.cityField.bottomAnchor, constant: 10),
            self.addressField.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.addressHeight,
            self.infoView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.infoView.topAnchor.constraint(equalTo: self.addressField.bottomAnchor, constant: 10),
            self.infoView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.nextButton.topAnchor.constraint(equalTo: self.infoView.bottomAnchor, constant: 20),
            self.nextButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.bottomAnchor.constraint(lessThanOrEqualTo: self.rootView.bottomAnchor, constant: -20),
            self.nextButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
        ])
        let space: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.toolbar.items = [space, UIBarButtonItem(title: "DONE".localized, style: .plain, target: self, action: #selector(self.hideKeyboard(_:)))]
        self.nextButton.addTarget(self, action: #selector(self.nextTapped(_:)), for: .touchUpInside)
        self.shipSegment.addTarget(self, action: #selector(self.shipSelected), for: .valueChanged)
        self.cityField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.citySelected)))
        self.addressField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.addressSelected)))
        self.firstnameField.textField.inputAccessoryView = self.toolbar
        self.lastnameField.textField.inputAccessoryView = self.toolbar
        self.surnameField.textField.inputAccessoryView = self.toolbar
        self.phoneNumberField.textField.inputAccessoryView = self.toolbar
        self.cardNameView.text = self.cardItem.name
        self.cardInfoView.text = self.cardItem.cardCategory.name
        self.selectedRegion = self.regions.first
        self.selectedPoint = self.regions.first?.points.first
        if self.cardItem.image.isEmpty {
            if self.cardItem.cardCategory.colorID == 0 {
                self.cardIconView.endColor = Constants.cardColors[0].end
                self.cardIconView.startColor = Constants.cardColors[0].start
            } else if self.cardItem.cardCategory.colorID == 1 {
                self.cardIconView.endColor = Constants.cardColors[1].end
                self.cardIconView.startColor = Constants.cardColors[1].start
            } else {
                self.cardIconView.endColor = Constants.cardColors[2].end
                self.cardIconView.startColor = Constants.cardColors[2].start
            }
            self.cardIconView.imageView.image = nil
        } else {
            self.cardIconView.endColor = .clear
            self.cardIconView.startColor = .clear
            self.cardIconView.imageView.loadImage(filePath: self.cardItem.image)
        }
        let validName1 = self.firstnameField.textField.rx.text.orEmpty.map({ $0.count >= 2 }).share(replay: 1)
        let validName2 = self.lastnameField.textField.rx.text.orEmpty.map({ $0.count >= 2 }).share(replay: 1)
        let validName3 = self.surnameField.textField.rx.text.orEmpty.map({ $0.count >= 2 }).share(replay: 1)
        let validName4 = self.phoneNumberField.textField.rx.text.orEmpty.map({ $0.count >= 6 }).share(replay: 1)
        let enableButton = Observable.combineLatest(validName1, validName2, validName3, validName4) { $0 && $1 && $2 && $3 }.share(replay: 1)
        enableButton.bind(to: self.nextButton.rx.isEnabled).disposed(by: self.viewModel.disposeBag)
        self.firstnameField.textField.text = self.viewModel.accountInfo.client.firstName
        self.lastnameField.textField.text = self.viewModel.accountInfo.client.lastName
        self.surnameField.textField.text = self.viewModel.accountInfo.client.midName
        self.phoneNumberField.textField.text = self.viewModel.accountInfo.client.wallet.formatedPrefix()
        self.firstnameField.textField.sendActions(for: .editingChanged)
        self.lastnameField.textField.sendActions(for: .editingChanged)
        self.surnameField.textField.sendActions(for: .editingChanged)
        self.phoneNumberField.textField.sendActions(for: .editingChanged)
    }
    
    @objc func hideKeyboard(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardApperence(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardApperence(notification: NSNotification) {
        if !self.isExpand {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                let full = self.scrollView.frame.height + keyboardHeight
                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: full)
            } else {
                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height + 250)
            }
            self.isExpand = true
        }
    }
    
    @objc func keyboardDisappear(notification: NSNotification) {
        if self.isExpand {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height - keyboardHeight)
            } else {
                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height - 250)
            }
            self.isExpand = false
        }
    }
    
    @objc func shipSelected() {
        if self.shipSegment.selectedSegmentIndex == 0 {
            let shipCost = Double(self.selectedRegion?.deliveryPrice ?? 0)
            let shipCostText = shipCost == 0 ? "FREE".localized : shipCost.balanceText
            let cardCostText = self.cardItem.price == 0 ? "FREE".localized : self.cardItem.price.balanceText
            self.infoView.infoLabel.text = "SHIP_DOSTAVKA_INFO".localizedFormat(arguments: cardCostText, shipCostText)
            self.addressHeight.constant = 0
            self.addressField.isHidden = true
        } else {
            let cardCostText = self.cardItem.price == 0 ? "FREE".localized : self.cardItem.price.balanceText
            self.infoView.infoLabel.text = "SHIP_SAMOVIVOS_INFO".localizedFormat(arguments: cardCostText)
            self.addressHeight.constant = 56
            self.addressField.isHidden = false
        }
        self.rootView.setNeedsLayout()
    }
    
    @objc func citySelected() {
        let vc = CardRegionViewController(selectType: .region(regions: self.regions))
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    @objc func addressSelected() {
        guard let region = self.selectedRegion else { return }
        let vc = CardRegionViewController(selectType: .point(points: region.points))
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    func regionSelected(region: AppStructs.Region?, point: AppStructs.Region.Points?) {
        if let region = region {
            self.selectedRegion = region
            self.selectedPoint = point ?? region.points.first
        } else {
            self.selectedPoint = point
        }
    }
    
    @objc func nextTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if let region = self.selectedRegion {
            self.coordinator?.navigateToPaymentCard(cardItem: self.cardItem, holderMidname: self.lastnameField.textField.text ?? "", holderName: self.firstnameField.textField.text ?? "", holderSurname: self.surnameField.textField.text ?? "", phoneNumber: self.phoneNumberField.textField.text ?? "", receivingType: self.shipSegment.selectedSegmentIndex == 0 ? .ship : .point, region: region, pointId: self.selectedPoint?.id)
        }
    }
}
