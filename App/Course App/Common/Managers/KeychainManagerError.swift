//
//  KeychainManagerError.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 05.06.2024.
//

import Foundation

enum KeychainManagerError: LocalizedError {
    /// Couldn't find data under specified key.
    case dataNotFound

    var errorDescription: String? {
        switch self {
        case .dataNotFound:
            "Data for key not found"
        }
    }
}
