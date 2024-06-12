//
//  AppCoordinator.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 30.05.2024.
//

import Combine
import UIKit

final class AppCoordinator: ObservableObject, ViewControllerCoordinator {
    // MARK: Private properties
    private(set) lazy var rootViewController: UIViewController = {
        if isSignedIn {
            makeTabBarFlow().rootViewController
        } else {
            makeSignInFlow().rootViewController
        }
    }()
    private var anyCancellables = Set<AnyCancellable>()
    
    // MARK: Public properties
    var childCoordinators = [Coordinator]()
    @Published var isSignedIn = false
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
        mainTabBarCoordinator.eventPublisher.sink { [weak self] event in
            self?.handle(event)
        }
        .store(in: &anyCancellables)
        return mainTabBarCoordinator
    }
    
    func makeSignInFlow() -> ViewControllerCoordinator {
        let signInCoordinator = SignInNavigationCoordinator()
        startChildCoordinator(signInCoordinator)
        signInCoordinator.eventPublisher.sink { [weak self] event in
            self?.handle(event)
        }
        .store(in: &anyCancellables)
        return signInCoordinator
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
private extension AppCoordinator {
    func handle(_ event: SignInNavigationCoordinatorEvent) {
        switch event {
        case let .signedIn(coordinator):
            rootViewController = makeTabBarFlow().rootViewController
            release(coordinator)
            isSignedIn = true
        }
    }
    
    func handle(_ event: MainTabBarCoordinatorEvent) {
        switch event {
        case let .logout(coordinator):
            rootViewController = makeSignInFlow().rootViewController
            release(coordinator)
            isSignedIn = false
        }
    }
}
