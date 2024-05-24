//
//  CustomNavigationController.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 24.05.2024.
//

import UIKit

class CustomNavigationController: UINavigationController {
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarAppearance()
    }
}
