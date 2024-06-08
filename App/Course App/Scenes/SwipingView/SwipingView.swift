//
//  SwipingView.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 22.05.2024.
//

import os
import SwiftUI

struct SwipingView: View {
    enum Constants {
        static let paddingDivider: CGFloat = 20
        static let sizeDivider = 1.2
        static let sizeWidthMultiplicator = 1.5
    }
    
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
                                swipeStateAction: { _ in }
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
        .onAppear {
            loadRandomJokes()
        }
    }
    
    func loadRandomJokes() {
        Task {
            try await withThrowingTaskGroup(of: JokeResponse.self) { group in
                for _ in 1...5 {
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
            }
        }
    }
}

#Preview {
    SwipingView()
}
