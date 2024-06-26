//
//  KeychainService.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 05.06.2024.
//

import Foundation

final class KeychainService: KeychainServicing {
    enum KeychainKey: String {
        case authData = "com.course.app.authData"
    }

    private(set) var keychainManager: KeychainManaging

    init(keychainManager: KeychainManaging) {
        self.keychainManager = keychainManager
    }

    func storeAuthData(authData: String) throws {
        try keychainManager.store(key: KeychainKey.authData.rawValue, value: authData)
    }
}
