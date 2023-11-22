//
//  CardAddViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 08/11/23.
//

import Foundation
import UIKit

class CardAddViewController: BaseViewController {
    
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
    private let cardView: CardView = {
        let view = CardView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setColors()
        return view
    }()
    private let colorSelectorView: ColorOptionView = {
        let view = ColorOptionView(frame: .zero)
        view.titleView.text = "CARD_CHANGE_COLOR".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let cardNumerField: CardTextFiled = {
        let view = CardTextFiled()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topLabel.text =  "SENDER_CARD_NUMBER".localized
        view.textField.textColor = Theme.current.primaryTextColor
        view.textField.minimumFontSize = 14
        view.textField.adjustsFontSizeToFitWidth = true
        view.textField.attributedPlaceholder = NSAttributedString(string: "1111-1111-1111-1111", attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryTextColor])
        view.textField.keyboardType = .numberPad
        view.textField.returnKeyType = .done
        //view.textField.textContentType = UITextContentType.creditCardNumber
        return view
    }()
    let cardDateField: CardTextFiled = {
        let view = CardTextFiled()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topLabel.text =  "CARD_DATE".localized
        view.textField.attributedPlaceholder = NSAttributedString(string: "12/24", attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryTextColor])
        view.textField.textColor = Theme.current.primaryTextColor
        view.textField.keyboardType = .numberPad
        view.textField.returnKeyType = .done
        return view
    }()
    let cardCvvField: CardTextFiled = {
        let view = CardTextFiled()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topLabel.text = "CVC/CVV"
        view.textField.attributedPlaceholder = NSAttributedString(string: "123", attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryTextColor])
        view.textField.textColor = Theme.current.primaryTextColor
        view.textField.keyboardType = .numberPad
        view.textField.returnKeyType = .done
        view.textField.enablesReturnKeyAutomatically = true
        return view
    }()
    private let nextButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.radius = 14
        view.setTitle("ADD_CARD".localized, for: .normal)
        view.isEnabled = true
        return view
    }()
    var nextButtonBottom: NSLayoutConstraint!
    
    let viewModel: CardsViewModel
    var selectedColor: (start: UIColor, end: UIColor)? = nil
    weak var coordinator: CardsCoordinator? = nil
    
    init(viewModel: CardsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "CARD_ADDING".localized
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.rootView)
        self.rootView.addSubview(self.cardView)
        self.rootView.addSubview(self.colorSelectorView)
        self.rootView.addSubview(self.cardNumerField)
        self.rootView.addSubview(self.cardDateField)
        self.rootView.addSubview(self.cardCvvField)
        self.rootView.addSubview(self.nextButton)
        let rootHeight = self.rootView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        rootHeight.priority = UILayoutPriority(rawValue: 250)
        self.nextButtonBottom = self.nextButton.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -20)
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
            self.cardView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
            self.cardView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 0),
            self.cardView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
            self.cardView.heightAnchor.constraint(equalTo: self.cardView.widthAnchor, multiplier: 0.561797753, constant: 10),
            self.colorSelectorView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.colorSelectorView.topAnchor.constraint(equalTo: self.cardView.bottomAnchor, constant: 20),
            self.colorSelectorView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.colorSelectorView.heightAnchor.constraint(equalToConstant: 36),
            self.cardNumerField.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.cardNumerField.topAnchor.constraint(equalTo: self.colorSelectorView.bottomAnchor, constant: 20),
            self.cardNumerField.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.cardNumerField.heightAnchor.constraint(equalToConstant: 74),
            self.cardDateField.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.cardDateField.topAnchor.constraint(equalTo: self.cardNumerField.bottomAnchor, constant: 20),
            self.cardDateField.rightAnchor.constraint(equalTo: self.rootView.centerXAnchor, constant: -10),
            self.cardDateField.heightAnchor.constraint(equalToConstant: 74),
            self.cardCvvField.leftAnchor.constraint(equalTo: self.rootView.centerXAnchor, constant: 10),
            self.cardCvvField.topAnchor.constraint(equalTo: self.cardNumerField.bottomAnchor, constant: 20),
            self.cardCvvField.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.cardCvvField.heightAnchor.constraint(equalToConstant: 74),
            self.nextButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.nextButton.topAnchor.constraint(greaterThanOrEqualTo: self.cardCvvField.bottomAnchor, constant: 20),
            self.nextButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButtonBottom,
            self.nextButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
        ])
        self.colorSelectorView.addTarget(self, action: #selector(self.optionTapped(_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func optionTapped(_ sender: ColorOptionView) {
        let color = sender.colors[sender.selectedColor]
        self.selectedColor = color
        self.cardView.setColors(selectedColor: color)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        var visibleHeight: CGFloat = 0
        if let userInfo = notification.userInfo {
            if let windowFrame = UIApplication.shared.keyWindow?.frame,
                let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                visibleHeight = windowFrame.intersection(keyboardRect).height
            }
        }
        self.nextButtonBottom.constant = -(visibleHeight - 20 + 2)
    }
     
    @objc func keyboardWillHide(_ notification: Notification) {
        self.nextButtonBottom.constant = -20
    }
}
