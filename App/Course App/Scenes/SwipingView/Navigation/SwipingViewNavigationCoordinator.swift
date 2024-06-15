//
//  SwipingViewNavigationCoordinator.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 30.05.2024.
//

import Combine
import DependencyInjection
import os
import SwiftUI
import UIKit

final class SwipingViewNavigationCoordinator: NavigationControllerCoordinator, CancellablesContaining {
    // MARK: Private properties
    private(set) lazy var navigationController: UINavigationController = CustomNavigationController()
    private let logger = Logger()
    
    // MARK: Public Properties
    var childCoordinators = [Coordinator]()
    var container: Container
    var cancellables = Set<AnyCancellable>()
    
    // MARK: Lifecycle
    deinit {
        logger.info("Deinit SwipingViewNavigationCoordinator")
    }
    
    init(container: Container) {
        self.container = container
    }
}

// MARK: - Start coordinator
extension SwipingViewNavigationCoordinator {
    func start() {
        navigationController.setViewControllers([makeSwipingView()], animated: false)
    }
}

// MARK: - Factory methods
extension SwipingViewNavigationCoordinator: SwipingViewFactory {
    func makeSwipingView(with joke: Joke? = nil, isChildCoordinator: Bool = false) -> UIViewController {
        let store = SwipingViewStore(isChildCoordinator: isChildCoordinator)
        return UIHostingController(rootView: SwipingView(store: store))
    }
}
