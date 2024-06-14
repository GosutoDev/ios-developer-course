//
//  FirebaseAuthManager.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 10.06.2024.
//

import FirebaseAuth
import Foundation

final class FirebaseAuthManager: FirebaseAuthManaging {
    // MARK: Private properties
    private let authService = Auth.auth()
    private let keychainService: KeychainServicing = KeychainService(keychainManager: KeychainManager())
    
    // MARK: Functions
    func signUp(_ credentials: Credentials) async throws {
        let result = try await authService.createUser(withEmail: credentials.email, password: credentials.password)
        
        guard let accessToken = try? await result.user.getIDToken() else {
            return
        }
        
        try keychainService.storeAuthData(authData: accessToken)
    }
    
    func signIn(_ entity: Credentials) async throws {
        let result = try await authService.signIn(withEmail: entity.email, password: entity.password)
        guard let accessToken = try? await result.user.getIDToken() else {
            return
        }
        
        try keychainService.storeAuthData(authData: accessToken)
    }
    
    func signOut() async throws {
        try authService.signOut()
    }
}
