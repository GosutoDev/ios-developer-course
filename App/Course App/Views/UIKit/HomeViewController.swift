//
//  HomeViewController.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 14.05.2024.
//

import os
import SwiftUI
import UIKit

final class HomeViewController: UIViewController {
    @IBOutlet private var categoriesCollectionView: UICollectionView!
    
    private let logger = Logger()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        logger.info("I have tapped \(indexPath)")
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        logger.info("will display \(indexPath)")
    }
}

// MARK: - UI SETUP
private extension HomeViewController {
    func setup() {
        setupCollectionView()
    }
    func setupCollectionView() {
        categoriesCollectionView.backgroundColor = UIColor.black
        categoriesCollectionView.isPagingEnabled = true
        categoriesCollectionView.showsHorizontalScrollIndicator = false
        categoriesCollectionView.contentInsetAdjustmentBehavior = .never
        categoriesCollectionView.delegate = self
    }
}


// HELPER
struct HomeView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> HomeViewController {
        HomeViewController()
    }
    
    func updateUIViewController(_ uiViewController: HomeViewController, context: Context) {
    }
}
