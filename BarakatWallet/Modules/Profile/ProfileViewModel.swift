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
    let clientInfo: AppStructs.ClientInfo
    let profileService: ProfileService
    
    let didProfileUpdate = PublishSubject<Void>()
    let didUpdateFailed = PublishSubject<String>()
    let didUploadFailed = PublishSubject<Void>()
    
    init(clientInfo: AppStructs.ClientInfo, profileService: ProfileService) {
        self.clientInfo = clientInfo
        self.profileService = profileService
    }
    
    func uploadAvatarImage(url: URL) {
        APIManager.instance.startUpload(file: url) { result in
            if let ava = result {
                self.setProfile(avatar: ava)
            } else {
                self.didUploadFailed.onNext(())
            }
        }
    }
    
    func setProfile(avatar: String? = nil, birthDate: String? = nil, email: String? = nil, firstName: String? = nil, lastName: String? = nil, midName: String? = nil, gender: String? = nil, inn: String? = nil, pushNotify: Bool? = nil, smsPush: Bool? = nil) {
        self.profileService.setProfile(avatar: avatar, birthDate: birthDate, email: email, firstName: firstName, lastName: lastName, midName: midName, gender: gender, inn: inn, pushNotify: pushNotify, smsPush: smsPush)
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
    
    func updateDevice(device: AppStructs.Device) {
        self.profileService.updateDevice(device: device)
    }
    
    func logout() -> Bool {
        return self.profileService.logout()
    }
    
    func account() -> CoreAccount? {
        return self.profileService.getAccount()
    }
}
