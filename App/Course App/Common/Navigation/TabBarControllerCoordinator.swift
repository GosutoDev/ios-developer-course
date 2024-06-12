//
//  TabBarControllerCoordinator.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 30.05.2024.
//

import UIKit

protocol TabBarControllerCoordinator: ViewControllerCoordinator {
    var tabBarController: UITabBarController { get }
}

extension TabBarControllerCoordinator {
    var rootViewController: UIViewController {
        tabBarController
    }
}
