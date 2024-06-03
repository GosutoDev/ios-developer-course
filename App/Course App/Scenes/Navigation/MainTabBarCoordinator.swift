//
//  MainTabBarCoordinator.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 30.05.2024.
//

import os
import SwiftUI
import UIKit

class MainTabBarCoordinator: NSObject, TabBarControllerCoordinator {
    // MARK: Private properties
    private(set) lazy var tabBarController = makeTabBarController()
    private var logger = Logger()
    
    // MARK: Public Properties
    var childCoordinators = [Coordinator]()
}

// MARK: - Start the coordinator
extension MainTabBarCoordinator {
    func start() {
        tabBarController.viewControllers = [
            makeHomeFlow().rootViewController,
            makeSwipingFlow().rootViewController
        ]
    }
}

// MARK: - Handle Deeplinks
extension MainTabBarCoordinator {
    func handleDeeplink(_ deeplink: Deeplink) {
        switch deeplink {
        case let .onboarding(page):
            let coordinator = makeOnboardingFlow()
            startChildCoordinator(coordinator)
            tabBarController.present(coordinator.rootViewController, animated: true)
        default:
            break
        }
        
        childCoordinators.forEach { $0.handleDeeplink(deeplink) }
    }
}

// MARK: - Factory methods
private extension MainTabBarCoordinator {
    func makeOnboardingFlow() -> ViewControllerCoordinator {
        let coordinator = OnboardingNavigationCoordinator()
        return coordinator
    }
    
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
}

// MARK: - UITabBarControllerDelegate
extension MainTabBarCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        logger.info("MainTabBarDelegate on coordinator and didSelect tab with controller \(viewController) ")
    }
}
