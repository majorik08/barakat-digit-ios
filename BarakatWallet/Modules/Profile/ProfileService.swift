//
//  ProfileService.swift
//  BarakatWallet
//
//  Created by km1tj on 31/10/23.
//

import Foundation
import RxSwift

protocol ProfileService: Service {
    
    var clientInfo: AppStructs.ClientInfo { get }
    
    func setProfile(avatar: String?, birthDate: String?, email: String?, firstName: String?, lastName: String?, midName: String?, gender: String?, inn: String?, pushNotify: Bool?, smsPush: Bool?) -> Single<Bool>
    
    func updateDevice(device: AppStructs.Device)
    
    func logout() -> Bool
    
    func getAccount() -> CoreAccount?
}

final class ProfileServiceImpl: ProfileService {
  
    let clientInfo: AppStructs.ClientInfo
    
    init(clientInfo: AppStructs.ClientInfo) {
        self.clientInfo = clientInfo
    }
    
    func setProfile(avatar: String? = nil, birthDate: String? = nil, email: String? = nil, firstName: String? = nil, lastName: String? = nil, midName: String? = nil, gender: String? = nil, inn: String? = nil, pushNotify: Bool? = nil, smsPush: Bool? = nil) -> Single<Bool> {
        return Single<Bool>.create { single in
            APIManager.instance.request(.init(AppMethods.Client.InfoSet(.init(avatar: avatar, birthDate: birthDate, email: email, firstName: firstName, gender: gender, inn: inn, lastName: lastName, midName: midName, pushNotify: pushNotify, smsPush: smsPush))), auth: .auth) { response in
                switch response.result {
                case .success(_):
                    single(.success(true))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func updateDevice(device: AppStructs.Device) {
        APIManager.instance.request(.init(AppMethods.Auth.DeviceUpdate(device))) { _ in }
    }
    
    func logout() -> Bool {
        guard let first = CoreAccount.accounts().first else { return false }
        return CoreAccount.logout(account: first)
    }
    
    func getAccount() -> CoreAccount? {
        return CoreAccount.accounts().first
    }
}
