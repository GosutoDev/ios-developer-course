//
//  KeychainServicing.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 05.06.2024.
//

import Foundation

protocol KeychainServicing {
    var keychainManager: KeychainManaging { get }
    func storeAuthData(authData: String) throws
}
