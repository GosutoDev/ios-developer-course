//
//  ManagerRegistration.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 14.06.2024.
//

import DependencyInjection
import Foundation

enum ManagerRegistration {
    static func registerDependencies(to container: Container) {
        container.autoregister(
            type: StorageManaging.self,
            in: .shared,
            initializer: StorageManager.init
        )
        
        container.autoregister(
            type: KeychainManaging.self,
            in: .shared,
            initializer: KeychainManager.init
        )
        
        container.autoregister(
            type: APIManaging.self,
            in: .shared,
            initializer: APIManager.init
        )
        
        container.autoregister(
            type: FirebaseAuthManaging.self,
            in: .shared,
            initializer: FirebaseAuthManager.init
        )
    }
}
