//
//  SignInViewStore.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 17.06.2024.
//

import Combine
import Foundation
import os

final class SignInViewStore: Store, ObservableObject {
    // MARK: Private properties
    private let eventSubject = PassthroughSubject<SignInViewEvent, Never>()
    private let authManager: FirebaseAuthManaging
    private let logger = Logger()
    
    @Published var viewState: SignInViewState = .initial
    
    init(authManager: FirebaseAuthManaging) {
        self.authManager = authManager
    }
}

// MARK: - Event emitter
extension SignInViewStore: EventEmitting {
    var eventPublisher: AnyPublisher<SignInViewEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

// MARK: - Sending actions
extension SignInViewStore {
    @MainActor
    func send(action: SignInViewAction) {
        switch action {
        case .signInButtonTapped:
            signIn()
        case .viewDidLoad:
            viewState.emailField = "Test@test.test"
            viewState.passwordField = "test123"
        }
    }
}

// MARK: - Functions
private extension SignInViewStore {
    @MainActor
    func signIn() {
        Task {
            do {
                try await authManager.signIn(Credentials(email: viewState.emailField, password: viewState.passwordField))
                eventSubject.send(.signedIn)
            } catch {
                logger.info("ERROR: \(error)")
            }
        }
    }
}
