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
        tabBarController.viewControllers = [makeHomeFlow(), makeSwipingFlow()]
    }
}

// MARK: - Factory methods
private extension MainTabBarCoordinator {
    func makeTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.delegate = self
        return tabBarController
    }
    
    func makeHomeFlow() -> UIViewController {
        let homeViewController = CustomNavigationController(rootViewController: HomeViewController())
        homeViewController.tabBarItem = UITabBarItem(
            title: "Categories",
            image: UIImage(systemName: "list.dash.header.rectangle"),
            tag: 0
        )

        return homeViewController
    }

    func makeSwipingFlow() -> UIViewController {
        let swipingNavigationController = CustomNavigationController(rootViewController: UIHostingController(rootView: SwipingView()))
        swipingNavigationController.tabBarItem = UITabBarItem(title: "Random", image: UIImage(systemName: "switch.2"), tag: 1)
        return swipingNavigationController
    }
}

// MARK: - UITabBarControllerDelegate
extension MainTabBarCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        logger.info("MainTabBarDelegate on coordinator and didSelect tab with controller \(viewController) ")
    }
}
