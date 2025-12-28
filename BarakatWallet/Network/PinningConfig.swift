//
//  PinningConfig.swift
//  BarakatWallet
//
//  Created by Codex on 2024-xx-xx.
//

import Foundation

struct PinningConfig {
    
    // Список доменов и разрешённых хэшей публичных ключей (base64(SHA256(pubkey))).
    // TODO: заполнить реальными значениями primary и backup ключей сервера.
    static let allowedKeyHashes: [String: [String]] = [
        "mobile.barakatmoliya.tj": [
            "BASE64_HASH_PRIMARY_PUBKEY",
            "BASE64_HASH_BACKUP_PUBKEY"
        ]
    ]
}
