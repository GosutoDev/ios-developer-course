//
//  AppCoordinator.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 30.05.2024.
//

import Combine
import DependencyInjection
import UIKit

final class AppCoordinator: ObservableObject, ViewControllerCoordinator, CancellablesContaining {
    // MARK: Private properties
    private(set) lazy var rootViewController: UIViewController = {
        if isSignedIn {
            makeTabBarFlow().rootViewController
        } else {
            makeSignInFlow().rootViewController
        }
    }()
    
    // MARK: Public properties
    var cancellables = Set<AnyCancellable>()
    var childCoordinators = [Coordinator]()
    var container = Container()
    @Published var isSignedIn = false
}

// MARK: - Start coordinator
extension AppCoordinator {
    func start() {
        setupAppUI()
        assembleDependencyInjectionRegistration()
    }
}

// MARK: - Dependency injection registration
private extension AppCoordinator {
    func assembleDependencyInjectionRegistration() {
        ManagerRegistration.registerDependencies(to: container)
        ServiceRegistration.registerDependecies(to: container)
        StoreRegistration.registerDependencies(to: container)
    }
}

// MARK: - Factory Methods
private extension AppCoordinator {
    func makeTabBarFlow() -> ViewControllerCoordinator {
        let mainTabBarCoordinator = MainTabBarCoordinator(container: container)
        startChildCoordinator(mainTabBarCoordinator)
        mainTabBarCoordinator.eventPublisher.sink { [weak self] event in
            self?.handle(event)
        }
        .store(in: &cancellables)
        return mainTabBarCoordinator
    }
    
    func makeSignInFlow() -> ViewControllerCoordinator {
        let signInCoordinator = SignInNavigationCoordinator(container: container)
        startChildCoordinator(signInCoordinator)
        signInCoordinator.eventPublisher.sink { [weak self] event in
            self?.handle(event)
        }
        .store(in: &cancellables)
        return signInCoordinator
    }
}

// MARK: - Setup UI
private extension AppCoordinator {
    func setupAppUI() {
        UITabBar.appearance().tintColor = .white
        UITabBarItem.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font: TextType.caption.uiFont
            ],
            for: .normal
        )
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = .brown
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().standardAppearance = tabBarAppearance
        
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
