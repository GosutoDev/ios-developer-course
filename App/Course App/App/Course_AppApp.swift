//
//  Course_AppApp.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 26.04.2024.
//

import FirebaseCore
import os
import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate {
    weak var deeplinkHandler: DeeplinkHandling?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        deeplinkFromService()
        return true
    }
    
    func deeplinkFromService() {
        // swiftlint:disable:next no_magic_numbers
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.deeplinkHandler?.handleDeeplink(.onboarding(page: 1))
        }
    }
}

@main
// swiftlint:disable:next type_name
struct Course_AppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject private var appCordinator = AppCoordinator()
    
    private let logger = Logger()
    
    init() {
        appCordinator.start()
        delegate.deeplinkHandler = appCordinator
    }
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView(coordinator: appCordinator)
                .id(appCordinator.isSignedIn)
                .ignoresSafeArea(edges: .all)
                .onAppear {
                    logger.info("Content view has appeared")
                }
        }
    }
}
