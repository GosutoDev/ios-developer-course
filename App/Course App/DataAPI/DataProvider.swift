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
    
    init(title: String, jokes: [JokeResponse]) {
        self.title = title
        self.jokes = jokes.map { Joke(jokeResponse: $0) }
    }
}

struct Joke: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let categories: [String]
    
    init(jokeResponse: JokeResponse) {
        self.text = jokeResponse.value
        self.categories = jokeResponse.categories
    }
}

final class DataProvider: ObservableObject {
    @Published var data: [SectionData] = []
}
