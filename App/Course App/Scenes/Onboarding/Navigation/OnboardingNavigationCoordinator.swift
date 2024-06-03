//
//  OnboardingNavigationCoordinator.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 01.06.2024.
//

import os
import Combine
import SwiftUI
import UIKit

class OnboardingNavigationCoordinator: NavigationControllerCoordinator {
    // MARK: Private properties
    private(set) lazy var navigationController: UINavigationController = makeNavigationController()
    private let logger = Logger()
    private var anyCancellables = Set<AnyCancellable>()
    private let eventSubject = PassthroughSubject<OnboardingNavigationCoordinatorEvent, Never>()
    
    // MARK: Public properties
    var childCoordinators = [Coordinator]()
    
    deinit {
        logger.info("Deinit OnboardingNavigationCoordinator")
    }
}

// MARK: - Event emitter
extension OnboardingNavigationCoordinator: EventEmitting {
    var eventPublisher: AnyPublisher<OnboardingNavigationCoordinatorEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

// MARK: - Start coordinator
extension OnboardingNavigationCoordinator {
    func start() {
        navigationController.setViewControllers([makeOnboardingView(page: OnboardingPage.welcome)], animated: false)
    }
}

// MARK: - Factory methods
private extension OnboardingNavigationCoordinator {
    func makeNavigationController() -> UINavigationController {
        let controller = CustomNavigationController()
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        return controller
    }
    
    func makeOnboardingView(page: OnboardingPage) -> UIViewController {
        let onboardingView = OnboardingView(page: page)
        onboardingView.eventPublisher.sink { [weak self] event in
            guard let self else {
                return
            }
            
            switch event {
            case let .nextPage(from):
                var newPage: OnboardingPage = OnboardingPage.welcome
                if from < OnboardingPage.allCases.count {
                    newPage = OnboardingPage(rawValue: from + 1)!
                }
                let viewController = self.makeOnboardingView(page: newPage)
                self.navigationController.pushViewController(viewController, animated: true)
            case .close:
                self.navigationController.dismiss(animated: true)
            }
        }
        .store(in: &anyCancellables)
        
        return UIHostingController(rootView: onboardingView)
    }
}
