//
//  ProfileView.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 03.06.2024.
//

import Combine
import SwiftUI

struct ProfileView: View {
    private let eventSubject = PassthroughSubject<ProfileViewEvent, Never>()
    
    var body: some View {
        VStack {
            Text("Profile")
                .foregroundStyle(.black)
                .textStyle(textType: .baseText)
                .underline()
            
            Button("Onboarding") {
                eventSubject.send(.onboarding)
            }
            .buttonStyle(.navigationButtonStyle)
            
            Button("Onboarding modal") {
                eventSubject.send(.onboardingModal)
            }
            .buttonStyle(.navigationButtonStyle)
            
            Button("Logout") {
                eventSubject.send(.logout)
            }
            .buttonStyle(.navigationButtonStyle)
        }
    }
}

// MARK: - Event Emitter
extension ProfileView: EventEmitting {
    var eventPublisher: AnyPublisher<ProfileViewEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

#Preview {
    ProfileView()
}
