//
//  CustomError.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 04.06.2024.
//

import Foundation

enum CustomError: Error, LocalizedError {
    case invalidEmail
    case invalidPassword
    case unknownError(error: Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            "Invalid email. Check if your email spell correctly."
        case .invalidPassword:
            "Invalid password. Try again."
        case let .unknownError(error):
            "Unkown error. (\(error.localizedDescription))"
        }
    }
}
