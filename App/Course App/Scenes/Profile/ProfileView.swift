//
//  ProfileView.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 03.06.2024.
//

import Combine
import os
import SwiftUI

struct ProfileView: View {
    // MARK: Private properties
    private let eventSubject = PassthroughSubject<ProfileViewEvent, Never>()
    private let authManager = FirebaseAuthManager()
    private let logger = Logger()
    
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
                signOut()
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

// MARK: - Functions
private extension ProfileView {
    @MainActor
    func signOut() {
        Task {
            do {
                try await authManager.signOut()
                eventSubject.send(.logout)
            } catch {
                logger.info("\(error)")
            }
        }
    }
}

#Preview {
    ProfileView()
}
