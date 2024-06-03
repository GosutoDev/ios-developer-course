//
//  AppCoordinator.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 30.05.2024.
//

import UIKit

final class AppCoordinator: ViewControllerCoordinator {
    // MARK: Private properties
    private(set) lazy var rootViewController = makeTabBarFlow().rootViewController
    
    // MARK: Public properties
    var childCoordinators = [Coordinator]()
}

// MARK: - Start coordinator
extension AppCoordinator {
    func start() {
        setupAppUI()
    }
}

// MARK: - Factory Methods
private extension AppCoordinator {
    func makeTabBarFlow() -> ViewControllerCoordinator {
        let mainTabBarCoordinator = MainTabBarCoordinator()
        startChildCoordinator(mainTabBarCoordinator)
        return mainTabBarCoordinator
    }
}

// MARK: - Setup UI
private extension AppCoordinator {
    func setupAppUI() {
        UITabBar.appearance().backgroundColor = .brown
        UITabBar.appearance().tintColor = .white
        UITabBarItem.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font: TextType.caption.uiFont
            ],
            for: .normal
        )
        UINavigationBar.appearance().tintColor = .white
    }
}

// MARK: - Handle Events

