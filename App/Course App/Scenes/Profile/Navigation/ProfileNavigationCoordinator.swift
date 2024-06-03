//
//  ProfileNavigationCoordinator.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 03.06.2024.
//

import Combine
import SwiftUI
import UIKit

final class ProfileNavigationCoordinator: NavigationControllerCoordinator {
    private(set) lazy var navigationController = makeNavigationController()
    private let eventSubject = PassthroughSubject<ProfileNavigationCoordinatorEvent, Never>()
    private var anyCancellables = Set<AnyCancellable>()
    
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
            guard let self else { return }
            
            switch event {
            case .logout:
                eventSubject.send(.logout)
            default:
                break
            }
        }
        .store(in: &anyCancellables)
        
        return UIHostingController(rootView: profileView)
    }
}
