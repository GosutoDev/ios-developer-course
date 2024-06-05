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

extension OnboardingCoordinatorPresenting where Self: Coordinator {
    func makeOnboardingFlow() -> ViewControllerCoordinator {
        let coordinator = OnboardingNavigationCoordinator()
        startChildCoordinator(coordinator)
        
        coordinator.eventPublisher.sink { [weak self] event in
            self?.handle(event: event)
        }
        .store(in: &anyCancellables)
        return coordinator
    }
    
    func handle(_ event: OnboardingNavigationCoordinatorEvent) {
        switch event {
        case .dismiss(let coordinator):
            release(coordinator)
        }
    }
}
