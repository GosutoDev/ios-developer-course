//
//  JokeResponse.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 06.06.2024.
//

import Foundation

struct JokeResponse: Codable {
    let id: String
    let categories: [String]
    let createdAt: Date
    let url: URL
    let value: String
}
