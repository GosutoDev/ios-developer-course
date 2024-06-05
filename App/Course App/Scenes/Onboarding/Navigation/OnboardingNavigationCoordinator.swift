//
//  OnboardingNavigationCoordinator.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 01.06.2024.
//

import Combine
import os
import SwiftUI
import UIKit

final class OnboardingNavigationCoordinator: NavigationControllerCoordinator, CancellablesContaining {
    // MARK: Private properties
    private(set) lazy var navigationController: UINavigationController = makeNavigationController()
    private let logger = Logger()
    private let eventSubject = PassthroughSubject<OnboardingNavigationCoordinatorEvent, Never>()
    private var isPushNavigation = false
    
    // MARK: Public properties
    var cancellables = Set<AnyCancellable>()
    var childCoordinators = [Coordinator]()
    
    deinit {
        logger.info("Deinit OnboardingNavigationCoordinator")
    }
    
    init(navigationController: UINavigationController? = nil) {
        if let navigationController {
            isPushNavigation = true
            self.navigationController = navigationController
        }
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
        if isPushNavigation {
            navigationController.pushViewController(makeOnboardingView(page: OnboardingPage.welcome), animated: true)
        } else {
            navigationController.setViewControllers(
                [makeOnboardingView(page: OnboardingPage.welcome)],
                animated: false
            )
        }
    }
}

// MARK: - Factory methods
private extension OnboardingNavigationCoordinator {
    func makeNavigationController() -> UINavigationController {
        let controller = CustomNavigationController()
        controller.eventPublisher.sink { [weak self] _ in
            guard let self else {
                return
            }
            self.eventSubject.send(.dismiss(self))
        }
        .store(in: &cancellables)
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
                var newPage = OnboardingPage.welcome
                if from < OnboardingPage.allCases.count {
                    // swiftlint:disable:next force_unwrapping
                    newPage = OnboardingPage(rawValue: from + 1)!
                } else {
                    break
                }
                let viewController = self.makeOnboardingView(page: newPage)
                self.navigationController.pushViewController(viewController, animated: true)
            case .close:
                if navigationController.presentingViewController != nil {
                    self.navigationController.dismiss(animated: true)
                } else {
                    navigationController.popToRootViewController(animated: true)
                }
            }
        }
        .store(in: &cancellables)
        
        return UIHostingController(rootView: onboardingView)
    }
}
