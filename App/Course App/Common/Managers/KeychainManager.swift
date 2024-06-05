//
//  KeychainManager.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 05.06.2024.
//

import Foundation
import KeychainAccess

final class KeychainManager: KeychainManaging {
    private let keychain = Keychain()
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    func store(key: String, value: some Encodable) throws {
        keychain[data: key] = try encoder.encode(value)
    }

    func fetch<T>(key: String) throws -> T where T: Decodable {
        guard let data = try keychain.getData(key) else {
            throw KeychainManagerError.dataNotFound
        }

        return try decoder.decode(T.self, from: data)
    }

    func remove(key: String) throws {
        try keychain.remove(key)
    }
}
