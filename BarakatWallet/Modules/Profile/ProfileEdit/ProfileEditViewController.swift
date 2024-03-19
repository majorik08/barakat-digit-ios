//
//  ProfileEdit.swift
//  BarakatWallet
//
//  Created by km1tj on 30/10/23.
//

import Foundation
import UIKit
import MobileCoreServices
import RxSwift

class ProfileEditViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let topBar: EditTopBar = {
        let view = EditTopBar(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.statusView.layer.cornerRadius = 14
        view.statusView.clipsToBounds = true
        view.statusView.backgroundColor = Theme.current.plainTableCellColor
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
    private let firstNameField: LabeledField = {
        let view = LabeledField(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.labelView.text = "FIRSTNAME".localized
        return view
    }()
    private let lastNameField: LabeledField = {
        let view = LabeledField(frame: .zero)
        view.labelView.text = "LASTNAME".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let surNameField: LabeledField = {
        let view = LabeledField(frame: .zero)
        view.labelView.text = "SURNAME".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let docBirthdayField: LabeledField = {
        let view = LabeledField(frame: .zero)
        view.labelView.text = "DOCUMENT_BIRTHDAY".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let emailField: LabeledField = {
        let view = LabeledField(frame: .zero)
        view.labelView.text = "ENTER_NEW_EMAIL".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        view.fieldView.textContentType = UITextContentType.emailAddress
        view.fieldView.keyboardType = .emailAddress
        return view
    }()
    let maleButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(name: .checked), for: .selected)
        view.setImage(UIImage(name: .unchecked), for: .normal)
        view.tintColor = Theme.current.tintColor
        view.setTitle("MALE".localized, for: .normal)
        view.setTitleColor(Theme.current.primaryTextColor, for: .normal)
        view.titleLabel?.font = UIFont.bold(size: 12)
        view.titleEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 0)
        view.isSelected = true
        return view
    }()
    let femaleButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(name: .checked), for: .selected)
        view.setImage(UIImage(name: .unchecked), for: .normal)
        view.tintColor = Theme.current.tintColor
        view.setTitle("FEMALE".localized, for: .normal)
        view.setTitleColor(Theme.current.primaryTextColor, for: .normal)
        view.titleLabel?.font = UIFont.bold(size: 12)
        view.isSelected = false
        view.titleEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 0)
        return view
    }()
    let nextButton: BaseButtonView = {
        let view = BaseButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.radius = 14
        view.setTitle("SAVE".localized, for: .normal)
        view.titleLabel?.font = UIFont.medium(size: 17)
        view.isEnabled = false
        return view
    }()
    let toolbar: UIToolbar = {
        let view = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        view.backgroundColor = Theme.current.plainTableBackColor
        return view
    }()
    let dobPicker = UIDatePicker()
    var isExpand:Bool = false
    
    let viewModel: ProfileViewModel
    lazy var imagePickerController = UIImagePickerController()
    weak var coordinator: ProfileCoordinator?
    
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
        self.navigationItem.title = "PROFILE_TITLE".localized
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.rootView)
        self.rootView.addSubview(self.topBar)
        self.rootView.addSubview(self.firstNameField)
        self.rootView.addSubview(self.lastNameField)
        self.rootView.addSubview(self.surNameField)
        self.rootView.addSubview(self.docBirthdayField)
        self.rootView.addSubview(self.emailField)
        self.rootView.addSubview(self.maleButton)
        self.rootView.addSubview(self.femaleButton)
        self.rootView.addSubview(self.nextButton)
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
            self.topBar.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: 0),
            self.topBar.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 20),
            self.topBar.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: 0),
            self.firstNameField.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.firstNameField.topAnchor.constraint(equalTo: self.topBar.bottomAnchor, constant: 10),
            self.firstNameField.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.firstNameField.heightAnchor.constraint(equalToConstant: 72),
            self.lastNameField.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.lastNameField.topAnchor.constraint(equalTo: self.firstNameField.bottomAnchor, constant: 16),
            self.lastNameField.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.lastNameField.heightAnchor.constraint(equalToConstant: 72),
            self.surNameField.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.surNameField.topAnchor.constraint(equalTo: self.lastNameField.bottomAnchor, constant: 16),
            self.surNameField.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.surNameField.heightAnchor.constraint(equalToConstant: 72),
            self.docBirthdayField.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.docBirthdayField.topAnchor.constraint(equalTo: self.surNameField.bottomAnchor, constant: 16),
            self.docBirthdayField.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.docBirthdayField.heightAnchor.constraint(equalToConstant: 72),
            self.emailField.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.emailField.topAnchor.constraint(equalTo: self.docBirthdayField.bottomAnchor, constant: 16),
            self.emailField.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.emailField.heightAnchor.constraint(equalToConstant: 72),
            self.maleButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.maleButton.topAnchor.constraint(equalTo: self.emailField.bottomAnchor, constant: 16),
            self.maleButton.rightAnchor.constraint(equalTo: self.rootView.centerXAnchor, constant: -Theme.current.mainPaddings),
            self.maleButton.heightAnchor.constraint(equalToConstant: 22),
            self.femaleButton.leftAnchor.constraint(equalTo: self.rootView.centerXAnchor, constant: Theme.current.mainPaddings),
            self.femaleButton.topAnchor.constraint(equalTo: self.emailField.bottomAnchor, constant: 16),
            self.femaleButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.femaleButton.heightAnchor.constraint(equalToConstant: 22),
            self.nextButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.nextButton.topAnchor.constraint(greaterThanOrEqualTo: self.maleButton.bottomAnchor, constant: 20),
            self.nextButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -30),
            self.nextButton.heightAnchor.constraint(equalToConstant: 56),
        ])
        let space: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.topBar.statusView.addTarget(self, action: #selector(self.goIdentify), for: .touchUpInside)
        self.toolbar.items = [space,UIBarButtonItem(title: "DONE".localized, style: .plain, target: self, action: #selector(self.hideKeyboard(_:)))]
        self.topBar.buttonView.addTarget(self, action: #selector(self.imagePicker), for: .touchUpInside)
        self.dobPicker.datePickerMode = .date
        self.dobPicker.date = Date()
        if #available(iOS 13.4, *) {
            self.dobPicker.preferredDatePickerStyle = .wheels
            self.dobPicker.sizeToFit()
        }
        self.docBirthdayField.fieldView.inputView = self.dobPicker
        self.docBirthdayField.fieldView.inputAccessoryView = self.toolbar
        self.firstNameField.fieldView.inputAccessoryView = self.toolbar
        self.lastNameField.fieldView.inputAccessoryView = self.toolbar
        self.surNameField.fieldView.inputAccessoryView = self.toolbar
        self.emailField.fieldView.inputAccessoryView = self.toolbar
        switch self.viewModel.accountInfo.client.limit.identifyed {
        case .noIdentified:
            self.firstNameField.fieldView.isEnabled = true
            self.lastNameField.fieldView.isEnabled = true
            self.surNameField.fieldView.isEnabled = true
            self.docBirthdayField.fieldView.isEnabled = true
            self.maleButton.isUserInteractionEnabled = true
            self.femaleButton.isUserInteractionEnabled = true
        case .onlineIdentified, .identified:
            self.firstNameField.fieldView.isEnabled = false
            self.lastNameField.fieldView.isEnabled = false
            self.surNameField.fieldView.isEnabled = false
            self.docBirthdayField.fieldView.isEnabled = false
            self.maleButton.isUserInteractionEnabled = false
            self.femaleButton.isUserInteractionEnabled = false
        }
        self.maleButton.addTarget(self, action: #selector(self.maleFemaleChanged(_:)), for: .touchUpInside)
        self.femaleButton.addTarget(self, action: #selector(self.maleFemaleChanged(_:)), for: .touchUpInside)
        self.nextButton.addTarget(self, action: #selector(self.setInfo(_:)), for: .touchUpInside)
        
        self.viewModel.didUpdateFailed.subscribe(onNext: { [weak self] message in
            self?.topBar.avatarView.progressView.stopAnimating()
            self?.hideProgressView()
            self?.showErrorAlert(title: "ERROR".localized, message: message)
        }).disposed(by: self.viewModel.disposeBag)
        self.viewModel.didUploadFailed.subscribe(onNext: { [weak self] _ in
            self?.topBar.avatarView.progressView.stopAnimating()
            self?.topBar.avatarView.image = nil
            self?.hideProgressView()
            self?.showErrorAlert(title: "ERROR".localized, message: "AVATAR_UPLOAD_ERROR".localized)
        }).disposed(by: self.viewModel.disposeBag)
        self.viewModel.didProfileUpdate.subscribe(onNext: { [weak self] _ in
            self?.topBar.avatarView.progressView.stopAnimating()
            self?.hideProgressView()
            self?.setInfo()
        }).disposed(by: self.viewModel.disposeBag)
        self.setInfo()
        
        let validEmail = self.emailField.fieldView.rx.text.orEmpty.map({ $0 == "" || self.isValid($0) }).share(replay: 1)
        let birthdate = self.docBirthdayField.fieldView.rx.text.orEmpty.map({ $0 == "" || self.isValidDate($0) }).share(replay: 1)
        if self.viewModel.accountInfo.client.limit.identifyed == .noIdentified {
            let enableButton = Observable.combineLatest(validEmail, birthdate) { $0 && $1 }.share(replay: 1)
            enableButton.bind(to: self.nextButton.rx.isEnabled).disposed(by: self.viewModel.disposeBag)
        } else {
            let enableButton = Observable.combineLatest(validEmail, birthdate) { $0 && $1 }.share(replay: 1)
            enableButton.bind(to: self.viewModel.isSendActive).disposed(by: self.viewModel.disposeBag)
        }
        self.viewModel.isSendActive.bind(to: self.nextButton.rx.isEnabled).disposed(by: self.viewModel.disposeBag)
    }
    
    override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
        self.view.backgroundColor = Theme.current.plainTableBackColor
    }
    
    @objc func goIdentify() {
        switch self.viewModel.accountInfo.client.limit.identifyed {
        case .noIdentified:
            self.showProgressView()
            self.viewModel.identifyService.getIdentify().subscribe { [weak self] result in
                self?.hideProgressView()
                self?.coordinator?.navigateToIdentify(identify: result)
            } onFailure: { [weak self] _ in
                self?.hideProgressView()
            }.disposed(by: self.viewModel.disposeBag)
        case .identified, .onlineIdentified:
            self.coordinator?.navigateToIdentify(identify: nil)
        }
    }
    
    @objc func maleFemaleChanged(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender === self.maleButton {
            if self.femaleButton.isSelected && sender.isSelected {
                self.femaleButton.isSelected = false
            }
        } else if sender === self.femaleButton {
            if self.maleButton.isSelected && sender.isSelected {
                self.maleButton.isSelected = false
            }
        }
    }
    
    @objc func setInfo(_ sender: UIButton) {
        self.showProgressView()
        switch self.viewModel.accountInfo.client.limit.identifyed {
        case .noIdentified:
            let gender = self.maleButton.isSelected ? "male" : "female"
            self.viewModel.setProfile(birthDate: self.docBirthdayField.fieldView.text ?? self.viewModel.accountInfo.client.birthDate, email: self.emailField.fieldView.text ?? self.viewModel.accountInfo.client.email, firstName: self.firstNameField.fieldView.text ?? self.viewModel.accountInfo.client.firstName, lastName: self.lastNameField.fieldView.text ?? self.viewModel.accountInfo.client.lastName, midName: self.surNameField.fieldView.text ?? self.viewModel.accountInfo.client.midName, gender: gender)
        case .onlineIdentified, .identified:
            self.viewModel.setProfile(birthDate: self.viewModel.accountInfo.client.birthDate, email: self.emailField.fieldView.text ?? self.viewModel.accountInfo.client.email, firstName: self.viewModel.accountInfo.client.firstName, lastName: self.viewModel.accountInfo.client.lastName, midName: self.viewModel.accountInfo.client.midName, gender: self.viewModel.accountInfo.client.gender)
        }
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
    
    @objc func hideKeyboard(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        self.docBirthdayField.fieldView.text = DateUtils.stringFullDate(date: self.dobPicker.date)
    }
    
    func setInfo() {
        self.topBar.statusView.configure(limits: self.viewModel.accountInfo.client.limit)
        APIManager.instance.loadImage(into: self.topBar.avatarView, filePath: self.viewModel.accountInfo.client.avatar)
        self.firstNameField.fieldView.text = self.viewModel.accountInfo.client.firstName
        self.lastNameField.fieldView.text = self.viewModel.accountInfo.client.lastName
        self.surNameField.fieldView.text = self.viewModel.accountInfo.client.midName
        self.docBirthdayField.fieldView.text = self.viewModel.accountInfo.client.birthDate
        self.emailField.fieldView.text = self.viewModel.accountInfo.client.email
        if self.viewModel.accountInfo.client.gender == "female" {
            self.femaleButton.isSelected = true
            self.maleButton.isSelected = false
        } else {
            self.femaleButton.isSelected = false
            self.maleButton.isSelected = true
        }
    }
    
    @objc func imagePicker() {
        self.imagePickerController.delegate = self
        if #available(iOS 13.0, *) {
            self.imagePickerController.overrideUserInterfaceStyle = Theme.current.dark ? .dark : .light
        }
        let mediaAlert = self.getActionSheet(popOver: self.topBar.avatarView, barButton: nil)
        let cameraAction = UIAlertAction(title: "CAMERA".localized, style: .default) { (_) in
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .camera
            self.imagePickerController.mediaTypes = [kUTTypeImage as String]
            self.imagePickerController.cameraCaptureMode = .photo
            self.imagePickerController.videoQuality = .typeMedium
            self.imagePickerController.showsCameraControls = true
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let photoAction = UIAlertAction(title: "PHOTOS".localized, style: .default) { (_) in
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .photoLibrary
            self.imagePickerController.mediaTypes = [kUTTypeImage as String]
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let deleteAvatar = UIAlertAction(title: "DELETE_PHOTO".localized, style: .destructive) { (_) in
            self.showProgressView()
            self.viewModel.setAvatar(avatar: "")
        }
        mediaAlert.addAction(cameraAction)
        mediaAlert.addAction(photoAction)
        if !self.viewModel.accountInfo.client.avatar.isEmpty {
            mediaAlert.addAction(deleteAvatar)
        }
        mediaAlert.addAction(UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: nil))
        self.present(mediaAlert, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
            if mediaType == kUTTypeImage as String {
                if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage ?? info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    let scaledImage = editedImage.scaleImage()
                    let name = APIManager.instance.getNewFileName(type: .image, mimeType: "image/jpeg")
                    let urlForLocalAvatar = APIManager.instance.getFileUrl(type: .image, name: name)
                    APIManager.saveImageLocal(scaledImage: scaledImage, compress: true, url: urlForLocalAvatar)
                    if APIManager.instance.fileExist(url: urlForLocalAvatar) {
                        self.topBar.avatarView.image = scaledImage
                        self.topBar.avatarView.progressView.startAnimating()
                        self.viewModel.uploadAvatarImage(url: urlForLocalAvatar)
                    }
                }
            }
        }
    }
    
    private func isValid(_ email: String) -> Bool {
        let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    private func isValidDate(_ birthdate: String) -> Bool {
        let datePattern = "^\\d{2}-\\d{2}-\\d{4}"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", datePattern)
        let result = emailTest.evaluate(with: birthdate.trimmingCharacters(in: .whitespacesAndNewlines))
        return result
    }
}
