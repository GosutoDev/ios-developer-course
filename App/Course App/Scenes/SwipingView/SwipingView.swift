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
    }
    
    // MARK: Private properties
    @StateObject private var store: SwipingViewStore
    
    init(store: SwipingViewStore) {
        _store = .init(wrappedValue: store)
    }
    
    // MARK: View
    var body: some View {
        GeometryReader { geometry in
            if store.viewState.status == .loading {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                HStack {
                    Spacer()
                    
                    VStack {
                        ZStack {
                            ForEach(store.viewState.jokes, id: \.self) { joke in
                                SwipingCard(
                                    configuration: SwipingCard.Configuration(
                                        title: joke.categories.first ?? "",
                                        description: joke.text,
                                        isLiked: joke.isLiked ?? false
                                    ),
                                    swipeStateAction: { action in
                                        switch action {
                                        case let .finished(direction):
                                            store.send(action: .didLike(joke, direction == .left))
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
        }
        .navigationTitle("Random")
        .onFirstAppear {
            store.send(action: .viewDidLoad)
        }
    }
}

//#Preview {
//    SwipingView(store: SwipingViewStore())
//}
