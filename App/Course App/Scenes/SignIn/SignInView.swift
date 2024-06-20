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
    @StateObject private var store: SignInViewStore
    
    init(store: SignInViewStore) {
        _store = .init(wrappedValue: store)
    }
    
    var body: some View {
        Form {
            TextField("Email", text: $store.viewState.emailField)
            SecureField("password", text: $store.viewState.passwordField)
            Button("SignIn") {
                store.send(action: .signInButtonTapped)
            }
        }
        .navigationTitle("SignIn")
        .onFirstAppear {
            store.send(action: .viewDidLoad)
        }
    }
}

#Preview {
    SignInView(store: SignInViewStore(authManager: FirebaseAuthManager()))
}
