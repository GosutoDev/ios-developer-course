//
//  APIManaging.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 06.06.2024.
//

import Foundation

protocol APIManaging {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}
