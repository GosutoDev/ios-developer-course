//
//  ViewControllerCoordinator.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 30.05.2024.
//

import UIKit

protocol ViewControllerCoordinator: Coordinator {
    var rootViewController: UIViewController { get }
}
