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
    // MARK: UIConstants
    enum UIConstants {
        static let interSectionSpacing: CGFloat = 20
        static let layoutWidth: CGFloat = 1
        static let layoutGroupHeight: CGFloat = 250
        static let layoutHeaderHeight: CGFloat = 20
    }
    
    let logger = Logger()
    
    var categoriesCollectionView: UICollectionView!
    
    
    // MARK: DataSources
    typealias DataSource = UICollectionViewDiffableDataSource<SectionData, Joke>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionData, Joke>
    lazy var dataSource = makeDataSource()
    private var dataProvider = DataProvider()
    lazy var cancellables = Set<AnyCancellable>()
    private let jokeService = JokeService(apiManager: APIManager())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        setup()
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
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Joke> { cell, _, _ in
            cell.contentConfiguration = UIHostingConfiguration {
                if let url = try? ImagesRouter.size300x200.asURLRequest().url {
                    AsyncImage(url: url) { image in
                        image.resizableBordered(cornerRadius: CornerRadiusSize.default.rawValue)
                    } placeholder: {
                        Color.gray
                    }
                } else {
                    Text("ERROR")
                }
            }
        }
        
        let dataSource = DataSource(collectionView: categoriesCollectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            let labelCell: UICollectionViewCell = collectionView.dequeueSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                for: indexPath
            )
            labelCell.contentConfiguration = UIHostingConfiguration {
                Text(section.title)
                    .textStyle(textType: .sectionTitle)
            }
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
        loadData()
        setupCollectionView()
        readData()
    }
    func setupCollectionView() {
        categoriesCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        categoriesCollectionView.backgroundColor = .bg
        categoriesCollectionView.delegate = self
        categoriesCollectionView.register(
            UICollectionViewCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        view.addSubview(categoriesCollectionView)
    }
}

// MARK: - Layout
private extension HomeViewController {
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            let section = self.dataProvider.data[sectionIndex]
            
            switch section.title {
            default:
                return self.createSection(with: section)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = UIConstants.interSectionSpacing
        layout.configuration = config
        return layout
    }
    
    func createSection(with section: SectionData) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(UIConstants.layoutWidth), heightDimension: .estimated(UIConstants.layoutGroupHeight))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(UIConstants.layoutWidth), heightDimension: .estimated(UIConstants.layoutHeaderHeight))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
}

// MARK: - Loading data
extension HomeViewController {
    func loadData() {
        Task {
            let categories = try await jokeService.loadCategories()
            
            try await withThrowingTaskGroup(of: JokeResponse.self) { [weak self] group in
                guard let self else {
                    return
                }
                
                for category in categories {
                    for _ in 1...5 {
                        group.addTask {
                            try await self.jokeService.loadJokeForCategory(category)
                        }
                    }
                }
                
                var jokeResponses: [JokeResponse] = []
                for try await jokeResponse in group {
                    jokeResponses.append(jokeResponse)
                }
                
                let dataDictionary = Dictionary(grouping: jokeResponses, by: { $0.categories.first ?? "" })
                for key in dataDictionary.keys {
                    dataProvider.data.append(SectionData(title: key, jokes: dataDictionary[key] ?? []))
                    logger.info("\(dataProvider.data)")
                }
            }
        }
    }
}
