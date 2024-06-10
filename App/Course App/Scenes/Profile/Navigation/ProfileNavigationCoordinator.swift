//
//  ProfileNavigationCoordinator.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 03.06.2024.
//

import Combine
import SwiftUI
import UIKit

final class ProfileNavigationCoordinator: NSObject, NavigationControllerCoordinator, CancellablesContaining, OnboardingCoordinatorPresenting {
    // MARK: Private properties
    private(set) lazy var navigationController = makeNavigationController()
    private let eventSubject = PassthroughSubject<ProfileNavigationCoordinatorEvent, Never>()
    
    // MARK: Public properties
    var cancellables = Set<AnyCancellable>()
    var childCoordinators = [Coordinator]()
}

// MARK: - Start coordinator
extension ProfileNavigationCoordinator {
    func start() {
        navigationController.setViewControllers([makeProfileView()], animated: false)
    }
}

// MARK: - Event Emitter
extension ProfileNavigationCoordinator: EventEmitting {
    var eventPublisher: AnyPublisher<ProfileNavigationCoordinatorEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

// MARK: - Factory methods
private extension ProfileNavigationCoordinator {
    func makeNavigationController() -> UINavigationController {
        CustomNavigationController()
    }
    
    func makeProfileView() -> UIViewController {
        let profileView = ProfileView()
        profileView.eventPublisher.sink { [weak self] event in
            guard let self else {
                return
            }
            
            switch event {
            case .logout:
                eventSubject.send(.logout)
            case .onboardingModal:
                navigationController.present(makeOnboardingFlow().rootViewController, animated: true)
            case .onboarding:
                _ = makeOnboardingFlow(navigationController: self.navigationController)
            }
        }
        .store(in: &cancellables)
        
        return UIHostingController(rootView: profileView)
    }
}



// MARK: - UINavigationControllerDelegate
extension ProfileNavigationCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if navigationController.viewControllers.count == 1 {
            if let onboardingCoordinator = childCoordinators.first(where: { $0 is OnboardingNavigationCoordinator }) {
                release(onboardingCoordinator)
            }
        }
    }
}
