//
//  OnboardingCoordinatorPresenting.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 05.06.2024.
//

import Combine
import UIKit

protocol OnboardingCoordinatorPresenting {
    func handle(_ event: OnboardingNavigationCoordinatorEvent)
}

extension OnboardingCoordinatorPresenting where Self: Coordinator, Self: CancellablesContaining, Self: UINavigationControllerDelegate {
    func makeOnboardingFlow(navigationController: UINavigationController? = nil) -> ViewControllerCoordinator {
        let coordinator = OnboardingNavigationCoordinator(container: container, navigationController: navigationController)
        startChildCoordinator(coordinator)
        
        if navigationController != nil {
            coordinator.navigationController.delegate = self
        }
        
        coordinator.eventPublisher.sink { [weak self] event in
            self?.handle(event)
        }
        .store(in: &cancellables)
        return coordinator
    }
    
    func handle(_ event: OnboardingNavigationCoordinatorEvent) {
        switch event {
        case .dismiss(let coordinator):
            release(coordinator)
        }
    }
}
