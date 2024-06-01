//
//  OnboardingNavigationCoordinator.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 01.06.2024.
//

import SwiftUI
import UIKit

class OnboardingNavigationCoordinator: NavigationControllerCoordinator {
    // MARK: Private properties
    private(set) lazy var navigationController: UINavigationController = makeNavigationController()
    
    // MARK: Public properties
    var childCoordinators = [Coordinator]()
}

// MARK: - Start coordinator
extension OnboardingNavigationCoordinator {
    func start() {
        navigationController.setViewControllers([makeOnboardingView(), makeOnboardingView()], animated: true)
    }
}

// MARK: - Factory methods
private extension OnboardingNavigationCoordinator {
    func makeNavigationController() -> UINavigationController {
        let controller = CustomNavigationController()
        return controller
    }
    
    func makeOnboardingView() -> UIViewController {
        let controller = OnboardingView()
        return UIHostingController(rootView: OnboardingView())
    }
}
