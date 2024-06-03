//
//  OnboardingNavigationCoordinator.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 01.06.2024.
//

import os
import SwiftUI
import UIKit

class OnboardingNavigationCoordinator: NavigationControllerCoordinator {
    // MARK: Private properties
    private(set) lazy var navigationController: UINavigationController = makeNavigationController()
    private let logger = Logger()
    
    // MARK: Public properties
    var childCoordinators = [Coordinator]()
    
    deinit {
        logger.info("Deinit OnboardingNavigationCoordinator")
    }
}

// MARK: - Start coordinator
extension OnboardingNavigationCoordinator {
    func start() {
        navigationController.setViewControllers([makeOnboardingView()], animated: false)
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
    
    func makeOnboardingView() -> UIViewController {
        UIHostingController(rootView: OnboardingView(page: .about))
    }
}
