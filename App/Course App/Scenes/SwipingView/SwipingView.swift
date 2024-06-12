//
//  SwipingView.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 22.05.2024.
//

import os
import SwiftUI

struct SwipingView: View {
    private let logger = Logger()
    private let dataProvider = MockDataProvider()
    
    enum Constants {
        static let paddingDivider: CGFloat = 20
        static let sizeDivider = 1.2
        static let sizeWidthMultiplicator = 1.5
    }

    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()

                VStack {
                    if let jokes = dataProvider.data.first?.jokes {
                        ZStack {
                            ForEach(jokes, id: \.self) { joke in
                                SwipingCard(
                                    configuration: SwipingCard.Configuration(
                                        image: Image(uiImage: joke.image ?? UIImage()),
                                        title: "Category",
                                        description: joke.text
                                    ),
                                    swipeStateAction: { _ in }
                                )
                            }
                        }
                        .padding(.top, geometry.size.height / Constants.paddingDivider)
                        .frame(width: geometry.size.width / Constants.sizeDivider, height: (geometry.size.width / Constants.sizeDivider) * Constants.sizeWidthMultiplicator)
                    } else {
                        Text("Empty data!")
                    }

                    Spacer()
                }

                Spacer()
            }
        }
        .navigationTitle("Random")
    }
}

#Preview {
    SwipingView()
}
