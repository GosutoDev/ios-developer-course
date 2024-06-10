//
//  MockDataProvider.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 14.05.2024.
//

import UIKit

struct SectionData: Identifiable, Hashable {
    let id = UUID()
    let title: String
    var jokes: [Joke]
    
    init(title: String, jokes: [JokeResponse], isLiked: Bool? = nil) {
        self.title = title
        self.jokes = jokes.map { Joke(jokeResponse: $0, isLiked: isLiked) }
    }
}

struct Joke: Identifiable, Hashable {
    let id = UUID()
    let jokeID: String
    let text: String
    let categories: [String]
    var isLiked: Bool?
    
    init(jokeResponse: JokeResponse, isLiked: Bool? = nil) {
        self.jokeID = jokeResponse.id
        self.text = jokeResponse.value
        self.categories = jokeResponse.categories
        self.isLiked = isLiked
    }
}

final class DataProvider: ObservableObject {
    @Published var data: [SectionData] = []
}
