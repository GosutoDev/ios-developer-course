//
//  JokesRoutes.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 06.06.2024.
//

import Foundation

enum JokesRoutes: Endpoint {
    case getJokeCategories
    case getRandomJoke
    case getJokeFor(category: String)
    
    var host: URL {
        BuildConfiguration.default.jokesBaseURL
    }
    
    var path: String {
        switch self {
        case .getJokeCategories:
            "jokes/categories"
        case .getRandomJoke, .getJokeFor:
            "jokes/random"
        }
    }
    
    var urlParameters: [String: String] {
        switch self {
        case let .getJokeFor(category):
            ["category": category]
        default:
            [String: String]()
        }
    }
}
