//
//  ProfileNavigationCoordinator.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 03.06.2024.
//

import SwiftUI
import UIKit

final class ProfileNavigationCoordinator: NavigationControllerCoordinator {
    private(set) lazy var navigationController = makeNavigationController()
    
    var childCoordinators = [Coordinator]()
}

// MARK: - Start coordinator
extension ProfileNavigationCoordinator {
    func start() {
        navigationController.setViewControllers([makeProfileView()], animated: false)
    }
}

// MARK: - Factory methods
private extension ProfileNavigationCoordinator {
    func makeNavigationController() -> UINavigationController {
        CustomNavigationController()
    }
    
    func makeProfileView() -> UIViewController {
        UIHostingController(rootView: ProfileView())
    }
}
