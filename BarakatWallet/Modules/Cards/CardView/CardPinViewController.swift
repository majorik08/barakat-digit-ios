//
//  CardChangePin.swift
//  BarakatWallet
//
//  Created by km1tj on 02/02/24.
//

import Foundation
import UIKit
import RxSwift

class CardPinViewController: BaseViewController, KeyPadViewDelegate {
    
    enum ChangeSteps {
        case first
        case second(new: String)
    }
    
    let backButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(name: .back_arrow), for: .normal)
        view.tintColor = Theme.current.primaryTextColor
        view.isHidden = true
        return view
    }()
    let numberHint: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.bold(size: 16)
        view.textColor = Theme.current.primaryTextColor
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.text = "ENTER_PIN_MIN".localized
        return view
    }()
    let passcodeDotView: PasswordDotView = {
        let view = PasswordDotView()
        view.fillColor = Theme.current.primaryTextColor
        view.strokeColor = Theme.current.primaryTextColor
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let timerHint: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.regular(size: 14)
        view.textColor = Theme.current.secondaryTextColor
        view.text = "ENTER_PIN_HINT".localized
        view.numberOfLines = 0
        view.isHidden = true
        view.lineBreakMode = .byWordWrapping
        view.textAlignment = .center
        return view
    }()
    let keyPadView: KeyPadView = {
        let view = KeyPadView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let continueButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.radius = 14
        view.setTitle("CONTINUE".localized, for: .normal)
        view.isEnabled = false
        return view
    }()
    let validDigitsSet: CharacterSet = {
        return CharacterSet(charactersIn: "0".unicodeScalars.first! ... "9".unicodeScalars.first!)
    }()
    var dialedNumbersDisplayString = "" {
        didSet {
            let text = self.dialedNumbersDisplayString
            self.passcodeDotView.inputDotCount = text.count
        }
    }
    weak var coordinator: CardsCoordinator?
    let hapticFeedback = HapticFeedback()
    let viewModel: CardsViewModel
    let card: AppStructs.CreditDebitCard
    let passcodeMinLength: Int = 4
    let passcodeMaxLength: Int = 4
    var step: ChangeSteps = .first
    
    
    init(viewModel: CardsViewModel, card: AppStructs.CreditDebitCard) {
        self.viewModel = viewModel
        self.card = card
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.numberHint)
        self.view.addSubview(self.passcodeDotView)
        self.view.addSubview(self.timerHint)
        self.view.addSubview(self.keyPadView)
        self.view.addSubview(self.continueButton)
        NSLayoutConstraint.activate([
            self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24),
            self.backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIApplication.statusBarHeight + 10),
            self.backButton.heightAnchor.constraint(equalToConstant: 28),
            self.backButton.widthAnchor.constraint(equalToConstant: 28),
            self.numberHint.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 27),
            self.numberHint.topAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            self.numberHint.rightAnchor.constraint(lessThanOrEqualTo: self.view.rightAnchor, constant: -27),
            self.passcodeDotView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 27),
            self.passcodeDotView.topAnchor.constraint(equalTo: self.numberHint.bottomAnchor, constant: 28),
            self.passcodeDotView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -27),
            self.passcodeDotView.heightAnchor.constraint(equalToConstant: 24),
            self.timerHint.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 27),
            self.timerHint.topAnchor.constraint(equalTo: self.passcodeDotView.bottomAnchor, constant: 20),
            self.timerHint.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -27),
            self.keyPadView.topAnchor.constraint(equalTo: self.timerHint.bottomAnchor, constant: 20),
            self.keyPadView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            self.keyPadView.heightAnchor.constraint(equalTo: self.keyPadView.widthAnchor, multiplier: 1.2),
            self.keyPadView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            self.continueButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 27),
            self.continueButton.topAnchor.constraint(equalTo: self.keyPadView.bottomAnchor, constant: 10),
            self.continueButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -27),
            self.continueButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            self.continueButton.heightAnchor.constraint(equalToConstant: Theme.current.mainButtonHeight),
        ])
        self.keyPadView.delegate = self
        self.backButton.rx.tap.subscribe { [weak self] _ in
            if let coo = self?.coordinator {
                coo.navigateBack()
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }.disposed(by: self.viewModel.disposeBag)
        self.continueButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.next(text: self.dialedNumbersDisplayString)
        }.disposed(by: self.viewModel.disposeBag)
        self.navigationItem.title = "CARD_PIN_CHANGE".localized
        self.dialedNumbersDisplayString = ""
        self.passcodeDotView.totalDotCount = 4
        self.passcodeDotView.inputDotCount = 0
        self.numberHint.text = "CARD_PIN_HINT".localized
    }
    
    func keyTapped(digit: String) {
        if digit == "." {
            return
        } else {
            self.hapticFeedback.tap()
            var text = self.dialedNumbersDisplayString
            if digit == "<" {
                if !text.isEmpty {
                    text = String(text.dropLast())
                }
            } else {
                text = text + digit
            }
            if let _ = text.rangeOfCharacter(from: self.validDigitsSet.inverted) {
                return
            }
            switch self.step {
            case .first:
                if text.count > self.passcodeMaxLength {
                    return
                }
                self.passcodeDotView.totalDotCount = max(self.passcodeMinLength, text.count)
            case .second(let new):
                if text.count > new.count {
                    return
                }
            }
            self.dialedNumbersDisplayString = text
            self.passcodeDotView.inputDotCount = text.count
            self.continueButton.isEnabled = self.dialedNumbersDisplayString.count >= self.passcodeMinLength && self.dialedNumbersDisplayString.count <= self.passcodeMaxLength
        }
    }
    
    func next(text: String) {
        switch self.step {
        case .first:
            self.step = .second(new: text)
            self.passcodeDotView.slideInFromLeft()
            self.numberHint.slideInFromLeft()
            self.dialedNumbersDisplayString = ""
            self.passcodeDotView.totalDotCount = 4
            self.passcodeDotView.inputDotCount = 0
            self.numberHint.text = "CARD_PIN_AGAIN".localized
        case .second(let new):
            if new == text {
                self.showProgressView()
                self.viewModel.cardService.updateUserCard(PINOnPay: nil, block: nil, colorID: nil, id: self.card.id, internetPay: nil, newPin: new)
                    .observe(on: MainScheduler.instance)
                    .subscribe { [weak self] _ in
                        guard let self = self else { return }
                        self.successProgress(text: "CHANGE_SUCCESS".localized)
                        self.coordinator?.navigateBack()
                    } onFailure: { [weak self] _ in
                        guard let self = self else { return }
                        self.hideProgressView()
                    }.disposed(by: self.viewModel.disposeBag)
            } else {
                self.step = .first
                self.passcodeDotView.slideInFromLeft()
                self.numberHint.slideInFromLeft()
                self.dialedNumbersDisplayString = ""
                self.passcodeDotView.totalDotCount = 4
                self.passcodeDotView.inputDotCount = 0
                self.numberHint.text = "CARD_PIN_HINT".localized
                self.showErrorAlert(title: "ERROR".localized, message: "PASSCODE_DONT_MATCH".localized)
            }
        }
    }
}
