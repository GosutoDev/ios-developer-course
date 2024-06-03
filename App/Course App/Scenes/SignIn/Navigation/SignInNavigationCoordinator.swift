//
//  SignInNavigationCoordinator.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 03.06.2024.
//

import SwiftUI
import UIKit

final class SignInNavigationCoordinator: NavigationControllerCoordinator {
    // MARK: Private properties
    private(set) lazy var navigationController = makeNavigationController()
    
    // MARK: Public properties
    var childCoordinators = [Coordinator]()
}

// MARK: - Start coordinator
extension SignInNavigationCoordinator {
    func start() {
        navigationController.setViewControllers([], animated: false)
    }
}

// MARK: - Factory methods
private extension SignInNavigationCoordinator {
    func makeNavigationController() -> UINavigationController {
        CustomNavigationController()
    }
    
    func makeSignInView() -> UIViewController {
        UIHostingController(rootView: SignInView())
    }
}
