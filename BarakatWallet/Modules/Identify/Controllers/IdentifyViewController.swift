//
//  IdentifyViewController.swift
//  BarakatWallet
//
//  Created by km1tj on 30/10/23.
//

import Foundation
import UIKit
import MobileCoreServices

class IdentifyViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        view.titleLabel?.font = UIFont.medium(size: 17)
        view.radius = 14
        view.setTitle("SEND".localized, for: .normal)
        view.isEnabled = false
        return view
    }()
    let frontLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = UIFont.regular(size: 17)
        view.textColor = Theme.current.primaryTextColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "FRONT_PASSPORT_HELP".localized
        view.numberOfLines = 0
        return view
    }()
    let frontPick: ImageControl = {
        let view = ImageControl(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let backLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = UIFont.regular(size: 17)
        view.textColor = Theme.current.primaryTextColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "BACK_PASSPORT_HELP".localized
        view.numberOfLines = 0
        return view
    }()
    let backPick: ImageControl = {
        let view = ImageControl(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let selfieLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = UIFont.regular(size: 17)
        view.textColor = Theme.current.primaryTextColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "SELFIE_HELP".localized
        view.numberOfLines = 0
        return view
    }()
    let selfieInfoLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = UIFont.regular(size: 14)
        view.textColor = Theme.current.secondaryTextColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "SELFIE_INFO_HELP".localized
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    let selfiePick: ImageControl = {
        let view = ImageControl(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let infoView: PassportInfoView = {
        let view = PassportInfoView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.current.plainTableCellColor
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    lazy var imagePickerController = UIImagePickerController()
    let viewModel: IdentifyViewModel
    weak var coordinator: IdentifyCoordinator?
    
    init(viewModel: IdentifyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "IDENTIFICATION".localized
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.rootView)
        self.rootView.addSubview(self.frontLabel)
        self.rootView.addSubview(self.frontPick)
        self.rootView.addSubview(self.backLabel)
        self.rootView.addSubview(self.backPick)
        self.rootView.addSubview(self.selfieLabel)
        self.rootView.addSubview(self.selfieInfoLabel)
        self.rootView.addSubview(self.selfiePick)
        self.rootView.addSubview(self.infoView)
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
            self.frontLabel.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.frontLabel.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 20),
            self.frontLabel.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.frontPick.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.frontPick.topAnchor.constraint(equalTo: self.frontLabel.bottomAnchor, constant: 10),
            self.frontPick.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.frontPick.heightAnchor.constraint(equalTo: self.frontPick.widthAnchor, multiplier: 0.5),
            self.backLabel.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.backLabel.topAnchor.constraint(equalTo: self.frontPick.bottomAnchor, constant: 20),
            self.backLabel.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.backPick.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.backPick.topAnchor.constraint(equalTo: self.backLabel.bottomAnchor, constant: 10),
            self.backPick.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.backPick.heightAnchor.constraint(equalTo: self.backPick.widthAnchor, multiplier: 0.5),
            self.selfieLabel.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.selfieLabel.topAnchor.constraint(equalTo: self.backPick.bottomAnchor, constant: 20),
            self.selfieLabel.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.selfieInfoLabel.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.selfieInfoLabel.topAnchor.constraint(equalTo: self.selfieLabel.bottomAnchor, constant: 10),
            self.selfieInfoLabel.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.selfiePick.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.selfiePick.topAnchor.constraint(equalTo: self.selfieInfoLabel.bottomAnchor, constant: 10),
            self.selfiePick.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.selfiePick.heightAnchor.constraint(equalTo: self.selfiePick.widthAnchor, multiplier: 0.5),
            self.infoView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.infoView.topAnchor.constraint(equalTo: self.selfiePick.bottomAnchor, constant: 20),
            self.infoView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Theme.current.mainPaddings),
            self.nextButton.topAnchor.constraint(equalTo: self.infoView.bottomAnchor, constant: 30),
            self.nextButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Theme.current.mainPaddings),
            self.nextButton.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -30),
            self.nextButton.heightAnchor.constraint(equalToConstant: 56),
        ])
        self.frontPick.addTarget(self, action: #selector(self.frontTapped(_:)), for: .touchUpInside)
        self.backPick.addTarget(self, action: #selector(self.frontTapped(_:)), for: .touchUpInside)
        self.selfiePick.addTarget(self, action: #selector(self.frontTapped(_:)), for: .touchUpInside)
        self.nextButton.addTarget(self, action: #selector(self.sendTapped(_:)), for: .touchUpInside)
        
        self.viewModel.didSetFailed.subscribe { [weak self] error in
            self?.hideProgressView()
            if let er = error {
                self?.showApiError(title: "ERROR", error: er)
            }
            self?.checkSendStatus()
        }.disposed(by: self.viewModel.disposeBag)
        self.viewModel.didSetSuccess.subscribe(onNext: { [weak self] _ in
            self?.successProgress(text: "DONE".localized)
            self?.coordinator?.navigateBack()
        }).disposed(by: self.viewModel.disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setStatusBarStyle(dark: nil)
    }
    
    override func themeChanged(newTheme: Theme) {
        super.themeChanged(newTheme: newTheme)
        self.view.backgroundColor = Theme.current.plainTableBackColor
        self.nextButton.startColor = newTheme.mainGradientStartColor
        self.nextButton.endColor = newTheme.mainGradientEndColor
        self.frontLabel.textColor = Theme.current.primaryTextColor
        self.frontPick.setNeedsDisplay()
        self.backLabel.textColor = Theme.current.primaryTextColor
        self.backPick.setNeedsDisplay()
        self.backLabel.textColor = Theme.current.primaryTextColor
        self.backPick.setNeedsDisplay()
        self.selfieLabel.textColor = Theme.current.primaryTextColor
        self.selfieInfoLabel.textColor = Theme.current.secondaryTextColor
        self.selfiePick.setNeedsDisplay()
        self.infoView.themeChanged(newTheme: newTheme)
    }
    
    @objc func sendTapped(_ sender: UIButton) {
        if self.checkSendStatus() {
            self.showProgressView()
            self.viewModel.setIdentify()
        }
    }
    
    @objc func frontTapped(_ sender: ImageControl) {
        if sender === self.frontPick {
            self.imagePicker(type: .front, sender: sender)
        } else if sender === self.backPick {
            self.imagePicker(type: .back, sender: sender)
        } else if sender === self.selfiePick {
            self.imagePicker(type: .selfie, sender: sender)
        }
    }
    
    func imagePicker(type: IdentifyViewModel.PickerType, sender: ImageControl) {
        self.viewModel.pickerType = type
        self.imagePickerController.delegate = self
        if #available(iOS 13.0, *) {
            self.imagePickerController.overrideUserInterfaceStyle = Theme.current.dark ? .dark : .light
        }
        let mediaAlert = self.getActionSheet(popOver: sender, barButton: nil)
        let cameraAction = UIAlertAction(title: "CAMERA".localized, style: .default) { (_) in
            self.imagePickerController.allowsEditing = false
            self.imagePickerController.sourceType = .camera
            self.imagePickerController.mediaTypes = [kUTTypeImage as String]
            self.imagePickerController.cameraCaptureMode = .photo
            self.imagePickerController.videoQuality = .typeMedium
            self.imagePickerController.showsCameraControls = true
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let photoAction = UIAlertAction(title: "PHOTOS".localized, style: .default) { (_) in
            self.imagePickerController.allowsEditing = false
            self.imagePickerController.sourceType = .photoLibrary
            self.imagePickerController.mediaTypes = [kUTTypeImage as String]
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        mediaAlert.addAction(cameraAction)
        mediaAlert.addAction(photoAction)
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
                        switch self.viewModel.pickerType {
                        case .front:
                            self.frontPick.photoView.image = scaledImage
                        case .back:
                            self.backPick.photoView.image = scaledImage
                        case .selfie:
                            self.selfiePick.photoView.image = scaledImage
                        }
                        self.viewModel.setPhoto(result: urlForLocalAvatar)
                        self.checkSendStatus()
                    }
                }
            }
        }
    }
    
    @discardableResult
    func checkSendStatus() -> Bool {
        if self.viewModel.frontUrl != nil && self.viewModel.backUrl != nil && self.viewModel.selfieUrl != nil {
            self.nextButton.isEnabled = true
            return true
        }
        self.nextButton.isEnabled = false
        return false
    }
}
