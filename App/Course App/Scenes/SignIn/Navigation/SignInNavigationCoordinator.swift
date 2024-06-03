//
//  SignInNavigationCoordinator.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 03.06.2024.
//

import Combine
import os
import SwiftUI
import UIKit

final class SignInNavigationCoordinator: NavigationControllerCoordinator {
    // MARK: Private properties
    private(set) lazy var navigationController = makeNavigationController()
    private let eventSubject = PassthroughSubject<SignInNavigationCoordinatorEvent, Never>()
    private var anyCancellables = Set<AnyCancellable>()
    private let logger = Logger()
    
    // MARK: Public properties
    var childCoordinators = [Coordinator]()
    
    deinit {
        logger.info("Deinit SignInVIew")
    }
}

// MARK: - Start coordinator
extension SignInNavigationCoordinator {
    func start() {
        navigationController.setViewControllers([makeSignInView()], animated: false)
    }
}

// MARK: - Event emitter
extension SignInNavigationCoordinator: EventEmitting {
    var eventPublisher: AnyPublisher<SignInNavigationCoordinatorEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

// MARK: - Factory methods
private extension SignInNavigationCoordinator {
    func makeNavigationController() -> UINavigationController {
        CustomNavigationController()
    }
    
    func makeSignInView() -> UIViewController {
        let signInView = SignInView()
        signInView.eventPublisher.sink { [weak self] event in
            self?.handle(event)
        }
        .store(in: &anyCancellables)
        return UIHostingController(rootView: signInView)
    }
}

// MARK: - Event handling
private extension SignInNavigationCoordinator {
    func handle(_ event: SignInViewEvent) {
        switch event {
        case .signedIn:
            eventSubject.send(.signedIn(self))
        }
    }
}
