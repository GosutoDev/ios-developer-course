//
//  Course_AppApp.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 26.04.2024.
//

import FirebaseCore
import os
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    let appCoordinator = {
        let coordinator = AppCoordinator()
        coordinator.start()
        return coordinator
    }()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
// swiftlint:disable:next type_name
struct Course_AppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    private let logger = Logger()
    var body: some Scene {
        WindowGroup {
            CoordinatorView(coordinator: delegate.appCoordinator)
                .ignoresSafeArea(edges: .all)
                .onAppear {
                    logger.info("Content view has appeared")
                }
        }
    }
}
