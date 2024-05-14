//
//  Course_AppApp.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 26.04.2024.
//

import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
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
    private var isUIKit = true
    var body: some Scene {
        WindowGroup {
            homeView
        }
    }
    
    @ViewBuilder
    var homeView: some View {
        if isUIKit {
            //
        } else {
            //
        }
    }
}
