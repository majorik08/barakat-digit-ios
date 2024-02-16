//
//  HistorySumPickViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 23/11/23.
//

import Foundation
import UIKit

protocol HistorySumPickViewControllerDelegate: AnyObject {
    func historySumPicked(from: Double, to: Double)
}

class HistorySumPickViewController: BaseViewController {
    
    let bgView: GradientView = {
        let view = GradientView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startColor = Theme.current.mainGradientStartColor
        view.endColor = Theme.current.mainGradientEndColor
        view.alpha = 0.5
        view.isUserInteractionEnabled = true
        return view
    }()
    let rootView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.current.plainTableBackColor
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
        view.font = UIFont.medium(size: 17)
        view.text = "TRANSFER_CONFIRM".localized
        view.numberOfLines = 0
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
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    let fromSumView: CardTextFiled = {
        let view = CardTextFiled()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topLabel.text =  "FROM".localized
        view.textField.attributedPlaceholder = NSAttributedString(string: "SUMMA".localized, attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryTextColor])
        view.textField.textColor = Theme.current.primaryTextColor
        view.textField.keyboardType = .decimalPad
        view.textField.returnKeyType = .done
        return view
    }()
    let toSumView: CardTextFiled = {
        let view = CardTextFiled()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topLabel.text = "TO".localized
        view.textField.attributedPlaceholder = NSAttributedString(string: "SUMMA".localized, attributes: [NSAttributedString.Key.foregroundColor: Theme.current.secondaryTextColor])
        view.textField.textColor = Theme.current.primaryTextColor
        view.textField.keyboardType = .decimalPad
        view.textField.returnKeyType = .done
        view.textField.enablesReturnKeyAutomatically = true
        return view
    }()
    let nextButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.radius = 14
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.setTitle("READY".localized, for: .normal)
        return view
    }()
    var nextButtonBottom: NSLayoutConstraint!
    let currency: CurrencyEnum
    weak var coordinator: HistoryCoordinator?
    weak var delegate: HistorySumPickViewControllerDelegate?
    
    init(currency: CurrencyEnum) {
        self.currency = currency
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
        self.modalPresentationCapturesStatusBarAppearance = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.view.addSubview(self.bgView)
        self.view.addSubview(self.rootView)
        self.rootView.addSubview(self.topAnchorView)
        self.rootView.addSubview(self.titleView)
        self.rootView.addSubview(self.scrollView)
        self.rootView.addSubview(self.nextButton)
        self.scrollView.addSubview(self.containerView)
        self.containerView.addSubview(self.fromSumView)
        self.containerView.addSubview(self.toSumView)
        let rootHeight = self.containerView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        rootHeight.priority = UILayoutPriority(rawValue: 250)
        self.nextButtonBottom = self.nextButton.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -(self.view.safeAreaInsets.bottom + 50))
        NSLayoutConstraint.activate([
            self.bgView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.bgView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.bgView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.bgView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.rootView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.rootView.topAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.rootView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.rootView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            //self.rootView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6),
            self.topAnchorView.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 16),
            self.topAnchorView.centerXAnchor.constraint(equalTo: self.rootView.centerXAnchor),
            self.topAnchorView.heightAnchor.constraint(equalToConstant: 6),
            self.topAnchorView.widthAnchor.constraint(equalToConstant: 48),
            self.titleView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.titleView.topAnchor.constraint(equalTo: self.topAnchorView.bottomAnchor, constant: 20),
            self.titleView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.scrollView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 20),
            self.scrollView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.scrollView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.containerView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.containerView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.containerView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.containerView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            rootHeight,
            self.fromSumView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant:  0),
            self.fromSumView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 0),
            self.fromSumView.rightAnchor.constraint(equalTo: self.containerView.centerXAnchor, constant: -10),
            self.fromSumView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -10),
            self.fromSumView.heightAnchor.constraint(equalToConstant: 74),
            self.toSumView.leftAnchor.constraint(equalTo: self.containerView.centerXAnchor, constant: 10),
            self.toSumView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 0),
            self.toSumView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: 0),
            self.toSumView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -10),
            self.toSumView.heightAnchor.constraint(equalToConstant: 74),
            self.nextButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.nextButton.topAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: 20),
            self.nextButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButtonBottom,
            self.nextButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
        ])
        self.rootView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        self.bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismisIfCan)))
        self.nextButton.addTarget(self, action: #selector(self.goToPay), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.titleView.text = "SUM_IN_CUR".localizedFormat(arguments: self.currency.description)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        var visibleHeight: CGFloat = 0
        if let userInfo = notification.userInfo {
            if let windowFrame = UIApplication.shared.keyWindow?.frame,
                let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                visibleHeight = windowFrame.intersection(keyboardRect).height
            }
        }
        self.nextButtonBottom.constant = -(visibleHeight + 20)
    }
     
    @objc func keyboardWillHide(_ notification: Notification) {
        self.nextButtonBottom.constant = -(self.view.safeAreaInsets.bottom + 50)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            return .default
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.animateView()
        self.setNeedsStatusBarAppearanceUpdate()
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
    
    @objc func dismisIfCan() {
        self.animateDismis()
    }
    
    @objc func goToPay() {
        guard let from = Double(self.fromSumView.textField.text ?? "0.0"), let to = Double(self.toSumView.textField.text ?? "0.0") else { return }
        self.delegate?.historySumPicked(from: from, to: to)
        self.dismisIfCan()
    }
}
