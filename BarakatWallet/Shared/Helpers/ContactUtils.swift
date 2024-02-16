//
//  ContactUtils.swift
//  BarakatWallet
//
//  Created by km1tj on 14/02/24.
//

import Foundation
import ContactsUI

public class ContactUtils {
    let contactFetchKeys = {
        return [CNContactIdentifierKey as CNKeyDescriptor,  CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactMiddleNameKey as CNKeyDescriptor, CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactImageDataKey as CNKeyDescriptor, CNContactThumbnailImageDataKey as CNKeyDescriptor,  CNContactImageDataAvailableKey as CNKeyDescriptor, CNContactTypeKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor]
    }()
    public let contactStore = CNContactStore()
    
    public static let instance = ContactUtils()
    
    private init() {}
    
    func isContactAccessSuccess() -> Bool {
        return CNContactStore.authorizationStatus(for: .contacts) == .authorized
    }
    
    func checkContactsAccess(_ completion: @escaping (_ accessGranted: Bool, _ deniedOrRestricted: Bool) -> Void) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completion(true, false)
        case .notDetermined:
            self.contactStore.requestAccess(for: .contacts, completionHandler: { (granted, error) in
                completion(granted, false)
            })
        case .restricted,.denied:
            completion(false, true)
        @unknown default: break
        }
    }
    
    func fetchPhoneContacts() -> [CNContact] {
        if CNContactStore.authorizationStatus(for: .contacts) != .authorized {
            return []
        }
        var contactParams = [CNContact]()
        do {
            let fetchRequest = CNContactFetchRequest(keysToFetch: self.contactFetchKeys)
            fetchRequest.mutableObjects = false
            fetchRequest.unifyResults = true
            fetchRequest.sortOrder = .userDefault
            try self.contactStore.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) in
                if contact.phoneNumbers.count >  0 {
                    contactParams.append(contact)
                }
            })
        } catch {
            Logger.log(tag: "ContactUtils:fetchPhoneContacts", error: error, send: true)
        }
        return contactParams
    }
}
