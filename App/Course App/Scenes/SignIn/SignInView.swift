//
//  SignInView.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 03.06.2024.
//

import Combine
import os
import SwiftUI

struct SignInView: View {
    // MARK: Private properties
    @State private var emailField: String
    @State private var passwordField: String
    private let eventSubject = PassthroughSubject<SignInViewEvent, Never>()
    private let authManager = FirebaseAuthManager()
    private let logger = Logger()
    
    // MARK: Lifecycle
    init(emailField: String = "Test@test.test", passwordField: String = "test123") {
        self.emailField = emailField
        self.passwordField = passwordField
    }
    
    var body: some View {
        Form {
            TextField("Email", text: $emailField)
            SecureField("password", text: $passwordField)
            Button("SignIn") {
                signIn()
            }
        }
        .navigationTitle("SignIn")
    }
}

// MARK: - Event emitter
extension SignInView: EventEmitting {
    var eventPublisher: AnyPublisher<SignInViewEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

// MARK: - Functions
private extension SignInView {
    @MainActor
    func signIn() {
        Task {
            do {
                try await authManager.signIn(Credentials(email: emailField, password: passwordField))
                eventSubject.send(.signedIn)
            } catch {
                logger.info("ERROR: \(error)")
            }
        }
    }
}

#Preview {
    SignInView()
}
