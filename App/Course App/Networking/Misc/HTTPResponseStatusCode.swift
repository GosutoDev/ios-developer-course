//
//  HTTPResponseStatusCode.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 07.06.2024.
//

import Foundation

// swiftlint:disable no_magic_numbers
enum HTTPResponseStatusCode {
    case informational
    case successful
    case redirection
    case clientError
    case serverError
    
    var range: CountableClosedRange<Int> {
        switch self {
        case .informational:
            100...199
        case .successful:
            200...299
        case .redirection:
            300...399
        case .clientError:
            400...499
        case .serverError:
            500...599
        }
    }
}
// swiftlint:enable no_magic_numbers
