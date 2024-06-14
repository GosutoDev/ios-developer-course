//
//  JokeServicing.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 08.06.2024.
//

import Foundation
 
protocol JokeServicing {
    var apiManager: APIManaging { get }
    
    func loadCategories() async throws -> [String]
    func loadRandomJoke() async throws -> JokeResponse
    func loadJokeForCategory(_ category: String) async throws -> JokeResponse
}
