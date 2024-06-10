//
//  SwipingView.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 22.05.2024.
//

import os
import SwiftUI

struct SwipingView: View {
    // MARK: Constants
    enum Constants {
        static let paddingDivider: CGFloat = 20
        static let sizeDivider = 1.2
        static let sizeWidthMultiplicator = 1.5
        static let fiveCard = 5
    }
    
    // MARK: Private properties
    private let logger = Logger()
    private let jokeService = JokeService(apiManager: APIManager())
    private let category: String?
    @State private var jokes: [Joke] = []
    
    init(joke: Joke? = nil) {
        self.category = joke?.categories.first
        if let joke {
            self.jokes.append(joke)
        }
    }
    
    // MARK: View
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                
                VStack {
                    ZStack {
                        ForEach(jokes, id: \.self) { joke in
                            SwipingCard(
                                configuration: SwipingCard.Configuration(
                                    title: joke.categories.first ?? "",
                                    description: joke.text
                                ),
                                swipeStateAction: { action in
                                    switch action {
                                    case .finished(direction: .left), .finished(direction: .right):
                                        removeCard(of: joke)
                                        checkCardStack()
                                    default:
                                        break
                                    }
                                }
                            )
                        }
                    }
                    .padding(.top, geometry.size.height / Constants.paddingDivider)
                    .frame(width: geometry.size.width / Constants.sizeDivider, height: (geometry.size.width / Constants.sizeDivider) * Constants.sizeWidthMultiplicator)
                    
                    Spacer()
                }
                Spacer()
            }
        }
        .navigationTitle("Random")
        .onFirstAppear {
            loadRandomJokes()
        }
    }
}

#Preview {
    SwipingView()
}

// MARK: - Functions
extension SwipingView {
    // MARK: Loading jokes
    func loadRandomJokes() {
        Task {
            try await withThrowingTaskGroup(of: JokeResponse.self) { group in
                // swiftlint:disable:next no_magic_numbers
                for _ in 1...10 {
                    group.addTask {
                        if let category {
                            try await jokeService.loadJokeForCategory(category)
                        } else {
                            try await jokeService.loadRandomJoke()
                        }
                    }
                }
                
                for try await jokeResponse in group {
                    jokes.append(Joke(jokeResponse: jokeResponse))
                }
                logger.info("INFO: Count cards is \(jokes.count).")
            }
        }
    }
    
    // MARK: Check for jokes count
    func checkCardStack() {
        if jokes.count <= Constants.fiveCard {
            loadRandomJokes()
        }
    }
    
    // MARK: Remove joke
    func removeCard(of joke: Joke) {
        if let index = jokes.firstIndex(of: joke) {
            loggerInfo(message: "INFO: Card number \(index) removed from Jokes array")
            jokes.remove(at: index)
            loggerInfo(message: "INFO: Cards count is \(jokes.count)")
        }
    }
    
    // MARK: Logger
    func loggerInfo(message: String) {
        logger.info("\(message)")
    }
}
