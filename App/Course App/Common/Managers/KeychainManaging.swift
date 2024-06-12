//
//  KeychainManaging.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 05.06.2024.
//

import Foundation

protocol KeychainManaging {
    func store<T: Encodable>(key: String, value: T) throws
    func fetch<T: Decodable>(key: String) throws -> T
    func remove(key: String) throws
}
