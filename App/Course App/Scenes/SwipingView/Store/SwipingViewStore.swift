//
//  SwipingViewStore.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 14.06.2024.
//

import Combine
import Foundation
import os

final class SwipingViewStore: Store, ObservableObject {
    // MARK: Public properties
    @Published var viewState: SwipingViewState = .initial
    
    // MARK: Private properties
    private let jokeService = JokeService(apiManager: APIManager())
    private let storage = StorageManager()
    private let logger = Logger()
    private let category: String?
    private let eventSubject = PassthroughSubject<SwipingViewEvent, Never>()
    private var isChildCoordinator = false
    
    init(joke: Joke? = nil, isChildCoordinator: Bool = false) {
        self.isChildCoordinator = isChildCoordinator
        self.category = joke?.categories.first
        if let joke {
            viewState.jokes.append(joke)
        }
    }
}

// MARK: - Event emitter
extension SwipingViewStore: EventEmitting {
    var eventPublisher: AnyPublisher<SwipingViewEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}


// MARK: - Action sender
extension SwipingViewStore {
    @MainActor
    func send(action: SwipingViewAction) {
        switch action {
        case .viewDidLoad:
            viewState.status = .loading
            loadRandomJokes()
        case let .dataLoaded(jokes):
            viewState.jokes.append(contentsOf: jokes)
            viewState.status = .ready
        case let .didLike(joke, liked):
            storeJokeLike(joke: joke, liked: liked)
            removeCard(of: joke)
            if viewState.jokes.isEmpty {
                send(action: .noMoreJokes)
            }
        case .noMoreJokes:
            if isChildCoordinator {
                eventSubject.send(.dismiss)
            } else {
                viewState.status = .loading
                loadRandomJokes()
            }
        }
    }
}

// MARK: - Functions
private extension SwipingViewStore {
    // MARK: Loading random jokes
    func loadRandomJokes() {
        Task {
            try await withThrowingTaskGroup(of: JokeResponse.self) { [weak self] group in
                guard let self else {
                    return
                }
                
                // swiftlint:disable:next no_magic_numbers
                for _ in 1...5 {
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
                
                await send(action: .dataLoaded(jokes))
            }
        }
    }
    
    // MARK: Storing joke like
    func storeJokeLike(joke: Joke, liked: Bool) {
        Task {
            try await storage.storeLike(jokeId: joke.jokeID, liked: liked)
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
