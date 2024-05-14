//  HomeView.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 14.05.2024.
//

import SwiftUI

// HELPER
struct HomeView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> HomeViewController {
        HomeViewController()
    }
    
    func updateUIViewController(_ uiViewController: HomeViewController, context: Context) {
    }
}
