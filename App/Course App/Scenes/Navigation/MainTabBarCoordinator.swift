//
//  MainTabBarCoordinator.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 30.05.2024.
//

import Combine
import os
import SwiftUI
import UIKit

final class MainTabBarCoordinator: NSObject, TabBarControllerCoordinator, CancellablesContaining, OnboardingCoordinatorPresenting {
    // MARK: Private properties
    private(set) lazy var tabBarController = makeTabBarController()
    private var logger = Logger()
    private let eventSubject = PassthroughSubject<MainTabBarCoordinatorEvent, Never>()
    
    // MARK: Public Properties
    var cancellables = Set<AnyCancellable>()
    var childCoordinators = [Coordinator]()
}

// MARK: - Start the coordinator
extension MainTabBarCoordinator {
    func start() {
        tabBarController.viewControllers = [
            makeHomeFlow().rootViewController,
            makeSwipingFlow().rootViewController,
            makeProfileFlow().rootViewController
        ]
    }
}

// MARK: - Event Emitter
extension MainTabBarCoordinator: EventEmitting {
    var eventPublisher: AnyPublisher<MainTabBarCoordinatorEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

// MARK: - Handle Deeplinks
extension MainTabBarCoordinator {
    func handleDeeplink(_ deeplink: Deeplink) {
        switch deeplink {
        case let .onboarding(page):
            let coordinator = makeOnboardingFlow()
            tabBarController.present(coordinator.rootViewController, animated: true)
        default:
            break
        }
        
        childCoordinators.forEach { $0.handleDeeplink(deeplink) }
    }
}

// MARK: - Factory methods
private extension MainTabBarCoordinator {
    func makeTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.delegate = self
        return tabBarController
    }
    
    func makeHomeFlow() -> ViewControllerCoordinator {
        let homeViewCoordinator = HomeNavigationCoordinator()
        startChildCoordinator(homeViewCoordinator)
        homeViewCoordinator.rootViewController.tabBarItem = UITabBarItem(
            title: "Categories",
            image: UIImage(systemName: "list.dash.header.rectangle"),
            tag: 0
            )
        return homeViewCoordinator
    }

    func makeSwipingFlow() -> ViewControllerCoordinator {
        let swipingNavigationCoordinator = SwipingViewNavigationCoordinator()
        startChildCoordinator(swipingNavigationCoordinator)
        swipingNavigationCoordinator.rootViewController.tabBarItem = UITabBarItem(title: "Random", image: UIImage(systemName: "switch.2"), tag: 1)
        return swipingNavigationCoordinator
    }
    
    func makeProfileFlow() -> ViewControllerCoordinator {
        let profileNavigationCoordinator = ProfileNavigationCoordinator()
        startChildCoordinator(profileNavigationCoordinator)
        profileNavigationCoordinator.eventPublisher.sink { [weak self] event in
            self?.handle(event)
        }
        .store(in: &cancellables)
        // swiftlint:disable:next no_magic_numbers
        profileNavigationCoordinator.rootViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 2)
        return profileNavigationCoordinator
    }
}

// MARK: - Handling events
private extension MainTabBarCoordinator {
    func handle(event: OnboardingNavigationCoordinatorEvent) {
        switch event {
        case let .dismiss(coordinator):
            release(coordinator)
        }
    }
    
    func handle(_ event: ProfileNavigationCoordinatorEvent) {
        switch event {
        case .logout:
            eventSubject.send(.logout(self))
        }
    }
}

// MARK: - UITabBarControllerDelegate
extension MainTabBarCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        logger.info("MainTabBarDelegate on coordinator and didSelect tab with controller \(viewController) ")
    }
}

// MARK: - UINavigationControllerDelegate
extension MainTabBarCoordinator: UINavigationControllerDelegate {}
