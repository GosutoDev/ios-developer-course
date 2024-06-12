//
//  NavigationControllerCoordinator.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 30.05.2024.
//

import UIKit

protocol NavigationControllerCoordinator: ViewControllerCoordinator {
    var navigationController: UINavigationController { get }
}

extension NavigationControllerCoordinator {
    var rootViewController: UIViewController {
        navigationController
    }
}
