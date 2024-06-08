//
//  JokeService.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 08.06.2024.
//

import Foundation

final class JokeService: JokeServicing {
    let apiManager: APIManaging
    
    init(apiManager: APIManaging) {
        self.apiManager = apiManager
    }
}

// MARK: - Functions
extension JokeService {
    func loadRandomJoke() async throws -> JokeResponse {
        try await apiManager.request(JokesRoutes.getRandomJoke)
    }
    
    func loadCategories() async throws -> [String] {
        try await apiManager.request(JokesRoutes.getJokeCategories)
    }
    
    func loadJokeForCategory(_ category: String) async throws -> JokeResponse {
        try await apiManager.request(JokesRoutes.getJokeFor(category: category))
    }
}
