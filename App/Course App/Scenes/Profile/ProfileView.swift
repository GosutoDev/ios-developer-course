//
//  ProfileView.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 03.06.2024.
//

import Combine
import SwiftUI

struct ProfileView: View {
    @State private var emailField = ""
    @State private var passwordField = ""
    
    private let eventSubject = PassthroughSubject<ProfileViewEvent, Never>()
    
    var body: some View {
        VStack {
            Form {
                TextField("Email", text: $emailField)
                SecureField("password", text: $passwordField)
                Button("SignIn") {
                    eventSubject.send(.successful)
                }
            }
        }
        .navigationTitle("Profile")
    }
}

#Preview {
    ProfileView()
}
