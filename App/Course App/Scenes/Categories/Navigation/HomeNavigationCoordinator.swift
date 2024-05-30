//
//  HomeNavigationCoordinator.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 30.05.2024.
//

import UIKit

final class HomeNavigationCoordinator: NavigationControllerCoordinator {
    // MARK: Private properties
    private(set) lazy var navigationController: UINavigationController = CustomNavigationController()
    
    // MARK: Public properties
    var childCoordinators = [Coordinator]()
}

// MARK: - Start coordinator
extension HomeNavigationCoordinator {
    func start() {
        navigationController.setViewControllers([makeHomeView()], animated: false)
    }
}

// MARK: - Factory methods
private extension HomeNavigationCoordinator {
    func makeHomeView() -> UIViewController {
        HomeViewController()
    }
}
