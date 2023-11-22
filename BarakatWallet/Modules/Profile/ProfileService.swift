//
//  ProfileService.swift
//  BarakatWallet
//
//  Created by km1tj on 31/10/23.
//

import Foundation
import RxSwift

protocol ProfileService: Service {
    
    var accountInfo: AppStructs.AccountInfo { get }
    
    func setProfile(birthDate: String, email: String, firstName: String, lastName: String, midName: String, gender: String) -> Single<Bool>
    
    func setAvatar(avatar: String) -> Single<Bool>
    
    func setSettings(pushNotify: Bool, smsPush: Bool) -> Single<Bool>
    
    func updateDevice(device: AppStructs.Device)
    
    func logout() -> Bool
    
    func getAccount() -> CoreAccount?
}

final class ProfileServiceImpl: ProfileService {
  
    let accountInfo: AppStructs.AccountInfo
    
    init(accountInfo: AppStructs.AccountInfo) {
        self.accountInfo = accountInfo
    }
    
    func setProfile(birthDate: String, email: String, firstName: String, lastName: String, midName: String, gender: String) -> RxSwift.Single<Bool> {
        return Single<Bool>.create { single in
            APIManager.instance.request(.init(AppMethods.Client.InfoSet(.init(birthDate: birthDate, email: email, firstName: firstName, gender: gender, lastName: lastName, midName: midName))), auth: .auth) { response in
                switch response.result {
                case .success(_):
                    self.accountInfo.client.birthDate = birthDate
                    self.accountInfo.client.email = email
                    self.accountInfo.client.firstName = firstName
                    self.accountInfo.client.lastName = lastName
                    self.accountInfo.client.midName = midName
                    self.accountInfo.client.gender = gender
                    self.accountInfo.didUpdateClient.onNext(())
                    single(.success(true))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func setAvatar(avatar: String) -> RxSwift.Single<Bool> {
        return Single<Bool>.create { single in
            APIManager.instance.request(.init(AppMethods.Client.AvatarSet(.init(avatar: avatar))), auth: .auth) { response in
                switch response.result {
                case .success(_):
                    self.accountInfo.client.avatar = avatar
                    self.accountInfo.didUpdateClient.onNext(())
                    single(.success(true))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func setSettings(pushNotify: Bool, smsPush: Bool) -> RxSwift.Single<Bool> {
        return Single<Bool>.create { single in
            APIManager.instance.request(.init(AppMethods.Client.SettingsSet(.init(pushNotify: pushNotify, smsPush: smsPush))), auth: .auth) { response in
                switch response.result {
                case .success(_):
                    self.accountInfo.client.pushNotify = pushNotify
                    self.accountInfo.client.smsPush = smsPush
                    self.accountInfo.didUpdateClient.onNext(())
                    single(.success(true))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func updateDevice(device: AppStructs.Device) {
        APIManager.instance.request(.init(AppMethods.Auth.DeviceUpdate(device)), auth: .auth) { _ in }
    }
    
    func logout() -> Bool {
        guard let first = CoreAccount.accounts().first else { return false }
        return CoreAccount.logout(account: first)
    }
    
    func getAccount() -> CoreAccount? {
        return CoreAccount.accounts().first
    }
}
