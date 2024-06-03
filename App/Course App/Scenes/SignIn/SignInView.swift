//
//  SignInView.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 03.06.2024.
//

import Combine
import SwiftUI

struct SignInView: View {
    // MARK: Private properties
    @State private var emailField = ""
    @State private var passwordField = ""
    private let eventSubject = PassthroughSubject<SignInViewEvent, Never>()
    
    var body: some View {
        Form {
            TextField("Email", text: $emailField)
            SecureField("password", text: $passwordField)
            Button("SignIn") {
                eventSubject.send(.signedIn)
            }
        }
        .navigationTitle("Profile")
    }
}

// MARK: - Event emitter
extension SignInView: EventEmitting {
    var eventPublisher: AnyPublisher<SignInViewEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

#Preview {
    SignInView()
}
