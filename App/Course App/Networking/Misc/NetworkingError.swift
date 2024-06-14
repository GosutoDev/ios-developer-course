//
//  NetworkingError.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 06.06.2024.
//

import Foundation

enum NetworkingError: Error {
    case unacceptableStatusCode
    case noHttpResponse
    case decodingFailed(error: Error)
    case invalidUrlComponents
}
