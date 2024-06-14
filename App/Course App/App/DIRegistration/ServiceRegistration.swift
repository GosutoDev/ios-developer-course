//
//  ServiceRegistration.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 14.06.2024.
//

import DependencyInjection
import Foundation

enum ServiceRegistration {
    static func registerDependecies(to container: Container) {
        container.autoregister(
            type: KeychainServicing.self,
            in: .shared,
            initializer: KeychainService.init)
        
        container.autoregister(
            type: JokeServicing.self,
            in: .shared,
            initializer: JokeService.init)
    }
}
