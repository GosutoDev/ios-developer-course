//
//  ProfileNavigationCoordinator.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 03.06.2024.
//

import Combine
import SwiftUI
import UIKit

final class ProfileNavigationCoordinator: NavigationControllerCoordinator, CancellablesContaining, OnboardingCoordinatorPresenting {
    private(set) lazy var navigationController = makeNavigationController()
    private let eventSubject = PassthroughSubject<ProfileNavigationCoordinatorEvent, Never>()
    
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
            default:
                break
            }
        }
        .store(in: &cancellables)
        
        return UIHostingController(rootView: profileView)
    }
}
