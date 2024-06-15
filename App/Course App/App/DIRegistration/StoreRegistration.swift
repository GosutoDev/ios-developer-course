//
//  StoreRegistration.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 15.06.2024.
//

import DependencyInjection
import Foundation

enum StoreRegistration {
    static func registerDependencies(to container: Container) {
        container.autoregister(
            type: SwipingViewStore.self,
            in: .new,
            initializer: SwipingViewStore.init)
    }
}
