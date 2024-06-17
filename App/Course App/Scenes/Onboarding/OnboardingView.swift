//
//  OnboardingView.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 01.06.2024.
//

import Combine
import DesignSystem
import SwiftUI

struct OnboardingView: View {
    let page: OnboardingPage
    private let eventSubject = PassthroughSubject<OnboardingViewEvent, Never>()
    
    init(page: OnboardingPage) {
        self.page = page
    }
    
    var body: some View {
        VStack(spacing: PaddingSize.default.rawValue) {
            Text("This page name is \(page.title).")
                .foregroundStyle(.black)
                .textStyle(textType: .baseText)
                .underline()
            Text("Page number: \(page.rawValue)")
                .foregroundStyle(.black)
                .textStyle(textType: .caption)
            
            if page != .diveIn {
                Button("Next page") {
                    eventSubject.send(.nextPage(from: page.rawValue))
                }
                .buttonStyle(.navigationButtonStyle)
            }
            
            Button("Close") {
                eventSubject.send(.close)
            }
            .buttonStyle(.navigationButtonStyle)
        }
        .navigationTitle("Onboarding")
    }
}

// MARK: - Event Emitter
extension OnboardingView: EventEmitting {
    var eventPublisher: AnyPublisher<OnboardingViewEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

#Preview {
    NavigationStack {
        OnboardingView(page: .welcome)
    }
}
