//
//  SwipingViewNavigationCoordinator.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 30.05.2024.
//

import os
import SwiftUI
import UIKit

final class SwipingViewNavigationCoordinator: NavigationControllerCoordinator {
    // MARK: Private properties
    private(set) lazy var navigationController: UINavigationController = CustomNavigationController()
    private let logger = Logger()
    
    // MARK: Public Properties
    var childCoordinators = [Coordinator]()
    
    // MARK: Lifecycle
    deinit {
        logger.info("Deinit SwipingViewNavigationCoordinator")
    }
}

// MARK: - Start coordinator
extension SwipingViewNavigationCoordinator {
    func start() {
        navigationController.setViewControllers([makeSwipingView()], animated: false)
    }
}

// MARK: - Factory methods
private extension SwipingViewNavigationCoordinator {
    func makeSwipingView() -> UIViewController {
        UIHostingController(rootView: SwipingView())
    }
}
