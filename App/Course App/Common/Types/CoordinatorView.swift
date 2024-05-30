//
//  CoordinatorView.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 30.05.2024.
//

import os
import SwiftUI
import UIKit

struct CoordinatorView<T: ViewControllerCoordinator>: UIViewControllerRepresentable {
    let coordinator: T
    private let logger = Logger()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        coordinator.rootViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
