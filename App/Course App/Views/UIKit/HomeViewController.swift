//
//  HomeViewController.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 14.05.2024.
//

import Combine
import os
import SwiftUI
import UIKit

final class HomeViewController: UIViewController {
    @IBOutlet private var categoriesCollectionView: UICollectionView!
    
    private let logger = Logger()
    
    // MARK: DataSources
    typealias DataSource = UICollectionViewDiffableDataSource<SectionData, Joke>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionData, Joke>
    private lazy var dataSource = makeDataSource()
    private lazy var dataProvider = MockDataProvider()
    private lazy var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController {
    func readData() {
        dataProvider.$data.sink { [weak self] data in
            print(data)
            self?.applySnapshot(data: data, animatingDifferences: true)
        }
        .store(in: &cancellables)
    }
    
    func applySnapshot(data: [SectionData], animatingDifferences: Bool = true) {
        guard dataSource.snapshot().numberOfSections == 0 else {
            
            var snapshot = dataSource.snapshot()
            snapshot.moveItem((data.first?.jokes.first)!, afterItem: (data.first?.jokes.last)!)
            
            dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
            return
        }
        
        var snapshot = Snapshot()
        snapshot.appendSections(data)
        
        data.forEach { section in
            snapshot.appendItems(section.jokes, toSection: section)
        }
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: categoriesCollectionView) { collectionView, indexPath, joke in
            
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            let imageCell: ImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            imageCell.imageView.image = section.jokes[indexPath.item].image
            return imageCell
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            let labelCell: LabelCollectionViewCell = collectionView.dequeueSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath)
            labelCell.nameLabel.text = section.title
            return labelCell
            
        }
        
        return dataSource
    }
}

// MARK: - UICollectionViewDelegate
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
        readData()
    }
    func setupCollectionView() {
        categoriesCollectionView.backgroundColor = .bg
        categoriesCollectionView.isPagingEnabled = true
        categoriesCollectionView.showsHorizontalScrollIndicator = false
        categoriesCollectionView.contentInsetAdjustmentBehavior = .never
        categoriesCollectionView.delegate = self
        categoriesCollectionView.register(ImageCollectionViewCell.self)
        categoriesCollectionView.register(LabelCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
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
