//
//  MainTabBarController.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 22.05.2024.
//

import SwiftUI
import UIKit

struct MainTabView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MainTabBarController {
        MainTabBarController()
    }

    func updateUIViewController(_ uiViewController: MainTabBarController, context: Context) {}
}

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupGlobalTabBarUI()
        // setupTabBar()

    }
}

// MARK: UI Setup
private extension MainTabBarController {
    func setupTabBar() {
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.backgroundColor = .red
        tabBar.tintColor = .blue
    }

    func setupGlobalTabBarUI() {
        UITabBar.appearance().backgroundColor = .brown
        UITabBar.appearance().tintColor = .white
    }
}
