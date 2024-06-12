//
//  HomeNavigationCoordinator.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 30.05.2024.
//

import Combine
import os
import UIKit

final class HomeNavigationCoordinator: NavigationControllerCoordinator, CancellablesContaining, SwipingViewFactory {
    // MARK: Private properties
    private(set) lazy var navigationController: UINavigationController = CustomNavigationController()
    private let logger = Logger()
    private let eventSubject = PassthroughSubject<HomeNavigationCoordinatorEvent, Never>()
    
    // MARK: Public properties
    var childCoordinators = [Coordinator]()
    var cancellables = Set<AnyCancellable>()
    
    deinit {
        logger.info("Deinit HomeNavigationCoordinator")
    }
}

// MARK: - EventEmitting
extension HomeNavigationCoordinator: EventEmitting {
    var eventPublisher: AnyPublisher<HomeNavigationCoordinatorEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
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
        let homeView = HomeViewController()
        homeView.eventPublisher.sink { [weak self] event in
            self?.handle(event)
        }
        .store(in: &cancellables)
        return homeView
    }
}

// MARK: - Handling events
private extension HomeNavigationCoordinator {
    func handle(_ event: HomeViewEvent) {
        switch event {
        case let .itemTapped(joke):
            logger.info("Joke on home screen was tapped \(joke.text)")
            navigationController.pushViewController(makeSwipingView(with: joke), animated: true)
        }
    }
}
