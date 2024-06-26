//
//  SwipingCard.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 22.05.2024.
//

import SwiftUI

typealias Action<T> = (T) -> Void

struct SwipingCard: View {
    // MARK: - SwipeDirection
    enum SwipeDirection {
        case left
        case right
    }
    
    // MARK: - SwipeState
    enum SwipeState {
        case swiping(direction: SwipeDirection)
        case finished(direction: SwipeDirection)
        case cancelled
    }
    
    // MARK: - Configuration
    struct Configuration: Equatable {
        let image: Image
        let title: String
        let description: String
    }
    
    // MARK: UI constant {
    enum UIConstants {
        static let offsetMultiplicator = 0.5
        static let degreesDivider: CGFloat = 40
        static let bgOpacity: CGFloat = 0.7
    }
    
    // MARK: Private variables
    private let swipingAction: Action<SwipeState>
    private let configuration: Configuration
    @State private var offset: CGSize = .zero
    @State private var color: Color = .bg.opacity(UIConstants.bgOpacity)
    
    init(
        configuration: Configuration,
        swipeStateAction: @escaping (Action<SwipeState>)
    ) {
        self.configuration = configuration
        self.swipingAction = swipeStateAction
    }
    
    // MARK: View
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                ScratchView(
                    image: configuration.image,
                    text: configuration.description
                )
                Spacer()
                cardDescription
            }
            Spacer()
        }
        .background(color)
        .cornerRadius(CornerRadiusSize.default.rawValue)
        .offset(x: offset.width, y: offset.height * UIConstants.offsetMultiplicator)
        .rotationEffect(.degrees(Double(offset.width / UIConstants.degreesDivider)))
        .gesture(dragGesture)
    }
    
    
    // MARK: Drag gesture
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                offset = gesture.translation
                withAnimation {
                    swiping(translation: offset)
                }
            }
            .onEnded { _ in
                withAnimation {
                    finishSwipe(translation: offset)
                }
            }
    }
    
    // MARK: CardDescription
    private var cardDescription: some View {
        Text(configuration.title)
            .textStyle(textType: .sectionTitle)
            .padding(PaddingSize.default.rawValue)
            .cornerRadius(CornerRadiusSize.default.rawValue)
            .padding()
    }
}

// swiftlint:disable no_magic_numbers

// MARK: - Swipe logic
private extension SwipingCard {
    func finishSwipe(translation: CGSize) {
        // swipe left
        if -500...(-200) ~= translation.width {
            offset = CGSize(width: -500, height: 0)
            swipingAction(.finished(direction: .left))
        } else if 200...500 ~= translation.width {
            // swipe right
            offset = CGSize(width: 500, height: 0)
            swipingAction(.finished(direction: .right))
        } else {
            // re-center
            offset = .zero
            color = .bg.opacity(UIConstants.bgOpacity)
            swipingAction(.cancelled)
        }
    }
    
    func swiping(translation: CGSize) {
        // swipe left
        if translation.width < -60 {
            color = .green
                .opacity(Double(abs(translation.width) / 500) + 0.6)
            swipingAction(.swiping(direction: .left))
        } else if translation.width > 60 {
            // swipe right
            color = .red
                .opacity(Double(translation.width / 500) + 0.6)
            swipingAction(.swiping(direction: .right))
        } else {
            color = .bg.opacity(UIConstants.bgOpacity)
            swipingAction(.cancelled)
        }
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        SwipingCard(
            configuration: SwipingCard.Configuration(
                image: Image("nature"),
                title: "Card Title",
                description: "This is a short description. This is a short description. This is a short description. This is a short description. This is a short description."
            ),
            swipeStateAction: { _ in }
        )
        .previewLayout(.sizeThatFits)
        .frame(width: 220, height: 340)
    }
}

// swiftlint:enable no_magic_numbers
