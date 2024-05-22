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

// HELPER
struct HomeView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> HomeViewController {
        HomeViewController()
    }
    
    func updateUIViewController(_ uiViewController: HomeViewController, context: Context) {
    }
}

final class HomeViewController: UIViewController {
    let logger = Logger()
    
    lazy var categoriesCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
    
    
    // MARK: DataSources
    typealias DataSource = UICollectionViewDiffableDataSource<SectionData, Joke>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionData, Joke>
    lazy var dataSource = makeDataSource()
    lazy var dataProvider = MockDataProvider()
    lazy var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        title = "Categories"
    }
}

// MARK: - UICollectionViewDataSource
private extension HomeViewController {
    func readData() {
        dataProvider.$data.sink { [weak self] data in
            self?.applySnapshot(data: data, animatingDifferences: true)
        }
        .store(in: &cancellables)
    }
    
    func applySnapshot(data: [SectionData], animatingDifferences: Bool = true) {
        guard dataSource.snapshot().numberOfSections == 0 else {
            var snapshot = dataSource.snapshot()
            
            // swiftlint:disable force_unwrapping
            snapshot.moveItem((data.first?.jokes.first)!, afterItem: (data.first?.jokes.last)!)
            // swiftlint:enable force_unwrapping
            
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
        let dataSource = DataSource(collectionView: categoriesCollectionView) { collectionView, indexPath, _ in
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
        categoriesCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        categoriesCollectionView.backgroundColor = .bg
        categoriesCollectionView.delegate = self
        categoriesCollectionView.register(ImageCollectionViewCell.self)
        categoriesCollectionView.register(LabelCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        view.addSubview(categoriesCollectionView)
    }
}

// MARK: - Layout
private extension HomeViewController {
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            let section = self.dataProvider.data[sectionIndex]
            
            switch section.title {
            default:
                return self.createSection(with: section)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = GlobalConstants.interSectionSpacing
        layout.configuration = config
        return layout
    }
    
    func createSection(with section: SectionData) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(GlobalConstants.layoutWidth), heightDimension: .estimated(GlobalConstants.layoutGroupHeight))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(GlobalConstants.layoutWidth), heightDimension: .estimated(GlobalConstants.layoutHeaderHeight))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
}
