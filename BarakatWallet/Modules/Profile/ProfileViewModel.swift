//
//  ProfileViewModel.swift
//  BarakatWallet
//
//  Created by km1tj on 30/10/23.
//

import Foundation
import RxSwift

class ProfileViewModel {
    
    let disposeBag = DisposeBag()
    let accountInfo: AppStructs.AccountInfo
    let profileService: ProfileService
    let identifyService: IdentifyService
    
    let didProfileUpdate = PublishSubject<Void>()
    let didIdentifyUpdate = PublishSubject<AppMethods.Client.IdentifyGet.IdentifyResult>()
    let didUpdateFailed = PublishSubject<String>()
    let didUploadFailed = PublishSubject<Void>()
    
    let isSendActive = PublishSubject<Bool>()
    
    init(accountInfo: AppStructs.AccountInfo, profileService: ProfileService, identifyService: IdentifyService) {
        self.accountInfo = accountInfo
        self.profileService = profileService
        self.identifyService = identifyService
        self.accountInfo.didUpdateClient.observe(on: MainScheduler.instance).subscribe(onNext: { _ in
            self.didProfileUpdate.onNext(())
        }).disposed(by: self.disposeBag)
    }
    
    func uploadAvatarImage(url: URL) {
        APIManager.instance.startUpload(file: url) { result in
            if let ava = result {
                self.setAvatar(avatar: ava)
            } else {
                self.didUploadFailed.onNext(())
            }
        }
    }
    
    func setProfile(birthDate: String, email: String, firstName: String, lastName: String, midName: String, gender: String) {
        self.profileService.setProfile(birthDate: birthDate, email: email, firstName: firstName, lastName: lastName, midName: midName, gender: gender)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { _ in
                self.didProfileUpdate.onNext(())
            }, onFailure: { error in
                if let error = error as? NetworkError {
                    self.didUpdateFailed.onNext((error.message ?? error.error) ?? error.localizedDescription)
                } else {
                    self.didUpdateFailed.onNext(error.localizedDescription)
                }
        }).disposed(by: self.disposeBag)
    }
    
    func setAvatar(avatar: String) {
        self.profileService.setAvatar(avatar: avatar).observe(on: MainScheduler.instance).subscribe(onSuccess: { _ in
            self.didProfileUpdate.onNext(())
        }, onFailure: { error in
            if let error = error as? NetworkError {
                self.didUpdateFailed.onNext((error.message ?? error.error) ?? error.localizedDescription)
            } else {
                self.didUpdateFailed.onNext(error.localizedDescription)
            }
        }).disposed(by: self.disposeBag)
    }
    
    func setSettings(pushNotify: Bool, smsPush: Bool) {
        self.profileService.setSettings(pushNotify: pushNotify, smsPush: smsPush).subscribe(onSuccess: { _ in
            self.didProfileUpdate.onNext(())
        }, onFailure: { error in
            if let error = error as? NetworkError {
                self.didUpdateFailed.onNext((error.message ?? error.error) ?? error.localizedDescription)
            } else {
                self.didUpdateFailed.onNext(error.localizedDescription)
            }
        }).disposed(by: self.disposeBag)
    }
    
    func updateDevice(device: AppStructs.Device) {
        self.profileService.updateDevice(device: device)
    }
    
    func loadIdentifyStatus() {
        self.identifyService.getIdentify().subscribe(onSuccess: { [weak self] result in
            self?.didIdentifyUpdate.onNext(result)
        }).disposed(by: self.disposeBag)
    }
    
    func account() -> CoreAccount? {
        return self.profileService.getAccount()
    }
}
