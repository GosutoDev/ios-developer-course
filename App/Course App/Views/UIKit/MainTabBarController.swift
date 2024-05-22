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
        setupTabBarControllers()
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

    func setupTabBarControllers() {
        viewControllers = [setupCategoriesView(), setupSwipingCardView()]
    }

    func setupCategoriesView() -> UIViewController {
        let categoriesNavigationController = UINavigationController(rootViewController: HomeViewController())
        categoriesNavigationController.tabBarItem = UITabBarItem(
            title: "Categories",
            image: UIImage(systemName: "list.dash.header.rectangle"),
            tag: 0
        )

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .brown
        appearance.shadowImage = UIImage()

        categoriesNavigationController.navigationBar.standardAppearance = appearance
        categoriesNavigationController.navigationBar.compactAppearance = appearance
        categoriesNavigationController.navigationBar.scrollEdgeAppearance = appearance

        return categoriesNavigationController
    }

    func setupSwipingCardView() -> UIViewController {
        let swipingNavigationController = UINavigationController(rootViewController: UIHostingController(rootView: SwipingView()))

        swipingNavigationController.tabBarItem = UITabBarItem(title: "Random", image: UIImage(systemName: "switch.2"), tag: 1)

        return swipingNavigationController
    }
}
