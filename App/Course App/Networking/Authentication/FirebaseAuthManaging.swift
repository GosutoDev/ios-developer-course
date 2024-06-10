//
//  FirebaseAuthManaging.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 10.06.2024.
//

import Foundation

protocol FirebaseAuthManaging {
    func signUp(_ credentials: Credentials) async throws
    func signIn(_ entity: Credentials) async throws
    func signOut() async throws
}
