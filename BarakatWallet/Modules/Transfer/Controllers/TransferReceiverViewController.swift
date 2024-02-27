//
//  TransferRootViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 22/10/23.
//

import Foundation
import UIKit
import PhoneNumberKit
import ContactsUI
import RxSwift

class TransferReceiverViewController: BaseViewController, UITabBarControllerDelegate, UITextFieldDelegate, CNContactPickerDelegate, PaymentServiceSelectViewDelegate {
    
    private let topBar: TransferTopView = {
        let view = TransferTopView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backButton.tintColor = .white
        view.titleLabel.text = "MONEY_TRANSERS".localized
        view.subTitleLabel.text = ""
        return view
    }()
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
    private let cardNumerField: BaseTextFiled = {
        let view = BaseTextFiled()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topLabel.text = "CARD_NUMBER_RECEIVER".localized
        view.textField.textColor = Theme.current.primaryTextColor
        view.textField.minimumFontSize = 14
        view.textField.adjustsFontSizeToFitWidth = true
        view.textField.attributedPlaceholder = NSAttributedString(string: "1111-1111-1111-1111", attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryTextColor])
        view.textField.keyboardType = .numberPad
        view.textField.returnKeyType = .done
        return view
    }()
    private let numberView: BasePrefixTextField = {
        let view = UITextField(frame: .zero)
        //let view = PhoneNumberTextField(withPhoneNumberKit: Constants.phoneNumberKit)
        let filedView = BasePrefixTextField(textField: view)
        filedView.topLabel.text = "PHONE_NUMBER_RECEIVER".localized
        filedView.translatesAutoresizingMaskIntoConstraints = false
        filedView.rightImage.image = UIImage(name: .add_number)
        filedView.prefixLabel.text = "+992"
        //view.withFlag = false
        //view.maxDigits = 9
        //view.withPrefix = true
        //view.withExamplePlaceholder = false
        view.leftViewMode = .always
        view.keyboardType = UIKeyboardType.phonePad
        view.borderStyle = .none
        view.attributedPlaceholder = NSAttributedString(string: "918000000", attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryTextColor])
        return filedView
    }()
    let selectorView: PaymentServiceSelectView = {
        let view = PaymentServiceSelectView(frame: .zero)
        view.controlView.isHidden = true
        view.titleView.isHidden = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let bottomAuthLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 16)
        view.textColor = Theme.current.primaryTextColor
        view.text = "RECEIVER_NOT_CARD_ANSWER".localized
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    private let bottomAuthHintLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 14)
        view.textColor = Theme.current.secondaryTextColor
        view.text = "RECEIVER_ORDER_CARD_HELP".localized
        view.numberOfLines = 0
        view.textAlignment = .center
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
    private var nextButtonBottom: NSLayoutConstraint!
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    weak var delegate: TransferSumViewControllerDelegate?
    weak var coordinator: TransferCoordinator?
    var pickMode: Bool = false
    var type: TransferType
    var cards: [CardTypes] = {
        return [.AmericanExpress, .DinersClub, .MasterCard, .Viza, .UnionPay, .kortimilli]
    }()
    let viewModel: TransferViewModel
    
    init(viewModel: TransferViewModel, type: TransferType, delegate: TransferSumViewControllerDelegate?) {
        self.type = type
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.topBar)
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.rootView)
        self.rootView.addSubview(self.nextButton)
        let rootHeight = self.rootView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        rootHeight.priority = UILayoutPriority(rawValue: 250)
        self.nextButtonBottom = self.nextButton.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -20)
        NSLayoutConstraint.activate([
            self.topBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.topBar.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.topBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.topBar.heightAnchor.constraint(equalToConstant: 160),
            self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.topBar.bottomAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.rootView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.rootView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.rootView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            self.rootView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            rootView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            rootHeight,
        ])
        switch self.type {
        case .byCard:
            self.rootView.addSubview(self.cardNumerField)
            self.rootView.addSubview(self.numberView)
            self.rootView.addSubview(self.bottomAuthLabel)
            self.rootView.addSubview(self.bottomAuthHintLabel)
            self.topBar.subTitleLabel.text = "TRANSFER_BY_CARD_INFO".localized
            self.bottomAuthLabel.isHidden = false
            self.bottomAuthHintLabel.isHidden = false
            NSLayoutConstraint.activate([
                self.cardNumerField.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
                self.cardNumerField.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 30),
                self.cardNumerField.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
                self.cardNumerField.heightAnchor.constraint(equalToConstant: 74),
                self.numberView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
                self.numberView.topAnchor.constraint(equalTo: self.cardNumerField.bottomAnchor, constant: 20),
                self.numberView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
                self.numberView.heightAnchor.constraint(equalToConstant: 74),
                self.bottomAuthLabel.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
                self.bottomAuthLabel.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
                self.bottomAuthHintLabel.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
                self.bottomAuthHintLabel.topAnchor.constraint(equalTo: self.bottomAuthLabel.bottomAnchor, constant: 10),
                self.bottomAuthHintLabel.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
                self.bottomAuthHintLabel.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -(30 + 40 + Theme.current.mainButtonHeight)),
                self.nextButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
                self.nextButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
                self.nextButton.topAnchor.constraint(greaterThanOrEqualTo: self.numberView.bottomAnchor, constant: 20),
                self.nextButtonBottom,
                self.nextButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight)
            ])
        case .byNumber:
            self.rootView.addSubview(self.numberView)
            self.rootView.addSubview(self.selectorView)
            self.topBar.subTitleLabel.text = "TRANSFER_BY_NUMBER_INFO".localized
            self.bottomAuthLabel.isHidden = true
            self.bottomAuthHintLabel.isHidden = true
            NSLayoutConstraint.activate([
                self.numberView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
                self.numberView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 30),
                self.numberView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
                self.numberView.heightAnchor.constraint(equalToConstant: 74),
                self.selectorView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
                self.selectorView.topAnchor.constraint(equalTo: self.numberView.bottomAnchor, constant: 10),
                self.selectorView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
                self.selectorView.heightAnchor.constraint(equalToConstant: 140),
                self.nextButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
                self.nextButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
                self.nextButton.topAnchor.constraint(greaterThanOrEqualTo: self.selectorView.bottomAnchor, constant: 20),
                self.nextButtonBottom,
                self.nextButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight)
            ])
            let validNumber = self.numberView.textField.rx.text.orEmpty
            validNumber
                .debounce(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
                .distinctUntilChanged()
                .filter({ $0.count >= 6 })
                .flatMap { str in
                    self.selectorView.configure(services: [])
                    return self.viewModel.loadNumberServices(number: "+992\(str.digits)")
                }
                .subscribe { [weak self] services in
                    self?.selectorView.configure(services: services)
                    self?.checkFields()
                } onError: { _ in
                    
                }.disposed(by: self.viewModel.disposeBag)
        }
        self.selectorView.delegate = self
        self.cardNumerField.textField.addTarget(self, action: #selector(reformatAsCardNumber), for: [.editingChanged])
        self.cardNumerField.textField.delegate = self
        self.numberView.textField.addTarget(self, action: #selector(reformatAsCardNumber), for: [.editingChanged])
        self.numberView.textField.delegate = self
        self.numberView.rightImage.isUserInteractionEnabled = true
        self.numberView.rightImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.contactPick)))
        self.topBar.backButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        self.nextButton.addTarget(self, action: #selector(self.goToSum), for: .touchUpInside)
    }
    
    override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
        self.topBar.themeChanged(newTheme: newTheme)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        switch self.type {
        case .byNumber:
            self.numberView.textField.becomeFirstResponder()
        case .byCard:
            self.cardNumerField.textField.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        var visibleHeight: CGFloat = 0
        if let userInfo = notification.userInfo {
            if let windowFrame = UIApplication.shared.keyWindow?.frame,
                let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                visibleHeight = windowFrame.intersection(keyboardRect).height
            }
        }
        self.nextButtonBottom.constant = -(visibleHeight - (self.tabBarController?.tabBar.frame.height ?? 0) + 6)
    }
     
    @objc func keyboardWillHide(_ notification: Notification) {
        self.nextButtonBottom.constant = -20
    }
    
    @objc func contactPick() {
        let vc = CNContactPickerViewController(nibName: nil, bundle: nil)
        vc.predicateForSelectionOfProperty = NSPredicate(format: "key == 'phoneNumbers'")
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        guard let item = contactProperty.value as? CNPhoneNumber else { return }
        var txt = item.stringValue.digits
        if txt.starts(with: "992") {
            txt = txt.replacingOccurrences(of: "992", with: "")
        }
        self.numberView.textField.text = txt
        self.numberView.textFieldTopLabel.text = "\(contactProperty.contact.givenName) \(contactProperty.contact.familyName)"
        if self.checkFields() {
            self.view.endEditing(true)
        }
    }
    
    func serviceSelected() {
        if self.checkFields() {
            self.view.endEditing(true)
        }
    }
    
    @objc func goBack() {
        self.coordinator?.navigateBack()
    }
    
    @objc func goToSum() {
        let receiver: TransferIdentifier
        switch self.type {
        case .byNumber:
            guard let service = self.selectorView.selectedService else { return }
            receiver = .number(number: "+992\(self.numberView.textField.text?.digits ?? "")", service: service.service, info: service.accountInfo)
        case .byCard:
            receiver = .card(number: self.cardNumerField.textField.text ?? "", phoneNumber: "+992\(self.numberView.textField.text?.digits ?? "")")
        }
        self.view.endEditing(true)
        if let delegate = self.delegate {
            delegate.receiverPicked(receiver: receiver)
            self.coordinator?.navigateBack()
        } else {
            self.showProgressView()
            self.viewModel.service.loadTransferData()
                .observe(on: MainScheduler.instance)
                .subscribe { [weak self] result in
                    guard let self = self else { return }
                    self.hideProgressView()
                    self.coordinator?.navigateToEnterSum(type: self.type, receiver: receiver, transferData: result)
                } onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.hideProgressView()
                    self.showServerErrorAlert()
                }.disposed(by: self.viewModel.disposeBag)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.checkFields() {
            self.view.endEditing(true)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.cardNumerField.textField {
            self.previousTextFieldContent = textField.text
            self.previousSelection = textField.selectedTextRange
            return true
        } else if textField == self.numberView.textField {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 9
        }
        return false
    }
    
    @discardableResult
    func checkFields() -> Bool {
        switch self.type {
        case .byCard:
            guard let cardNumber = self.cardNumerField.textField.text?.digits, cardNumber.count >= 14 else {
                self.nextButton.isEnabled = false
                return false
            }
            guard let cardNumber = self.numberView.textField.text?.digits, cardNumber.count >= 8 else {
                self.nextButton.isEnabled = false
                return false
            }
        case .byNumber:
            guard let cardNumber = self.numberView.textField.text?.digits, cardNumber.count >= 8 else {
                self.nextButton.isEnabled = false
                return false
            }
            guard let _ = self.selectorView.selectedService else {
                self.nextButton.isEnabled = false
                return false
            }
        }
        self.nextButton.isEnabled = true
        return true
    }
    
    @objc func reformatAsCardNumber(textField: UITextField) {
        if textField == self.cardNumerField.textField {
            var targetCursorPosition = 0
            if let startPosition = textField.selectedTextRange?.start {
                targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
            }
            var cardNumberWithoutSpaces = ""
            if let text = textField.text {
                cardNumberWithoutSpaces = CardTypes.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
            }
            if cardNumberWithoutSpaces.count > 16 {
                textField.text = self.previousTextFieldContent
                textField.selectedTextRange = self.previousSelection
                if self.checkFields() {
                    self.cardNumerField.textField.resignFirstResponder()
                } else {
                    self.numberView.textField.becomeFirstResponder()
                }
                return
            }
            self.checkFields()
            let cardNumberWithSpaces = CardTypes.insertCreditCardSpaces(cardNumberWithoutSpaces, preserveCursorPosition: &targetCursorPosition)
            textField.text = cardNumberWithSpaces.0
            self.cardNumerField.rightImage.image = cardNumberWithSpaces.1?.image
            if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
                textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
            }
        } else if textField == self.numberView.textField {
            self.numberView.textFieldTopLabel.text = nil
            self.checkFields()
            if let t = textField.text, t.count == 9 {
                self.numberView.textField.resignFirstResponder()
            }
        }
    }
}
