//
//  MockKeychainManager.swift
//  Course App UnitTests
//
//  Created by Tomáš Duchoslav on 20.06.2024.
//

@testable import App_Course_Dev
import Foundation
import KeychainAccess

final class MockKeychainManager: KeychainManaging {
    let keychain = Keychain()
    
    func store<T>(key: String, value: T) throws where T : Encodable {
        keychain[data: key] = try JSONEncoder().encode(value)
    }
    
    func fetch<T>(key: String) throws -> T where T : Decodable {
        guard let data = try keychain.getData(key) else {
            throw KeychainManagerError.dataNotFound
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func remove(key: String) throws {
        try keychain.remove(key)
    }
    
    
}
