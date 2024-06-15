//
//  SwipingViewStore.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 14.06.2024.
//

import os
import Foundation

final class SwipingViewStore: Store, ObservableObject {
    // MARK: Public properties
    @Published var viewState: SwipingViewState = .initial
    
    // MARK: Private properties
    private let jokeService = JokeService(apiManager: APIManager())
    private let storage = StorageManager()
    private let logger = Logger()
    private let category: String?
    
    init(joke: Joke? = nil) {
        self.category = joke?.categories.first
        if let joke {
            viewState.jokes.append(joke)
        }
    }
}


// MARK: - Action sender
extension SwipingViewStore {
    @MainActor
    func send(action: SwipingViewAction) {
        
    }
}

// MARK: - Functions
extension SwipingViewStore {
    // MARK: Loading random jokes
    func loadRandomJokes() {
        Task {
            try await withThrowingTaskGroup(of: JokeResponse.self) { [weak self] group in
                guard let self else {
                    return
                }
                
                // swiftlint:disable:next no_magic_numbers
                for _ in 1...10 {
                    group.addTask {
                        if let category = self.category {
                            try await self.jokeService.loadJokeForCategory(category)
                        } else {
                            try await self.jokeService.loadRandomJoke()
                        }
                    }
                }
                
                var jokes: [Joke] = []
                for try await jokeResponse in group {
                    let isLiked = try await storage.liked(jokeId: jokeResponse.id)
                    jokes.append(Joke(jokeResponse: jokeResponse, isLiked: isLiked))
                }
                self.viewState.jokes.append(contentsOf: jokes)
                logger.info("INFO: Count cards is \(self.viewState.jokes.count).")
            }
        }
    }
    
    // MARK: Storing joke like
    func storeJokeLike(jokeId: String, liked: Bool) {
        Task {
            try await storage.storeLike(jokeId: jokeId, liked: liked)
        }
    }
    
    // MARK: Check for jokes count
    func checkCardStack() {
        let fiveCards = 5
        if viewState.jokes.count <= fiveCards {
            loadRandomJokes()
        }
    }
    
    // MARK: Remove joke
    func removeCard(of joke: Joke) {
        if let index = viewState.jokes.firstIndex(of: joke) {
            loggerInfo(message: "INFO: Card number \(index) removed from Jokes array")
            viewState.jokes.remove(at: index)
            loggerInfo(message: "INFO: Cards count is \(viewState.jokes.count)")
        }
    }
    
    // MARK: Logger
    func loggerInfo(message: String) {
        logger.info("\(message)")
    }
}
