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
    // MARK: UIConstants
    enum UIConstants {
        static let spacing: CGFloat = 20
        static let layoutWidth: CGFloat = 1
        static let layoutGroupHeight: CGFloat = 250
        static let layoutHeaderHeight: CGFloat = 20
    }
    
    // MARK: DataSources
    typealias DataSource = UICollectionViewDiffableDataSource<SectionData, Joke>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionData, Joke>
    
    // MARK: Private properties
    private lazy var dataSource = makeDataSource()
    private var dataProvider = DataProvider()
    private lazy var cancellables = Set<AnyCancellable>()
    private let jokeService = JokeService(apiManager: APIManager())
    private lazy var categoriesCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
    private let logger = Logger()
    private let storage = StorageManager()
    private let eventSubject = PassthroughSubject<HomeViewEvent, Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        setup()
    }
}

// MARK: - EventEmitting
extension HomeViewController: EventEmitting {
    var eventPublisher: AnyPublisher<HomeViewEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

// MARK: - UI SETUP
private extension HomeViewController {
    func setup() {
        setupCollectionView()
        readData()
        loadData()
    }
    func setupCollectionView() {
        categoriesCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        categoriesCollectionView.backgroundColor = .bg
        categoriesCollectionView.delegate = self
        
        view.addSubview(categoriesCollectionView)
        
        categoriesCollectionView.register(
            UICollectionViewCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
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
                    // swiftlint:disable:next no_magic_numbers
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
                }
                
                for sectionIndex in dataProvider.data.indices {
                    for jokeIndex in dataProvider.data[sectionIndex].jokes.indices {
                        let isLiked = try await storage.liked(jokeId: dataProvider.data[sectionIndex].jokes[jokeIndex].jokeID)
                        dataProvider.data[sectionIndex].jokes[jokeIndex].isLiked = isLiked
                    }
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
private extension HomeViewController {
    func readData() {
        categoriesCollectionView.reloadData()
        dataProvider.$data.sink { [weak self] data in
            self?.applySnapshot(data: data, animatingDifferences: true)
        }
        .store(in: &cancellables)
    }
    
    func applySnapshot(data: [SectionData], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(data)
        data.forEach { section in
            snapshot.appendItems(section.jokes, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func makeDataSource() -> DataSource {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Joke> { cell, _, joke in
            cell.contentConfiguration = UIHostingConfiguration {
                if let url = try? ImagesRouter.size300x200.asURLRequest().url {
                    ZStack(alignment: .topTrailing) {
                        AsyncImage(url: url) { image in
                            image.resizableBordered(cornerRadius: CornerRadiusSize.default.rawValue)
                        } placeholder: {
                            Color.gray
                        }
                        if joke.isLiked ?? false {
                            Image(systemName: "heart.circle.fill")
                                .font(.largeTitle)
                                .symbolRenderingMode(.multicolor)
                                .padding(PaddingSize.default.rawValue)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        }
                    }
                    .onTapGesture { [weak self] in
                        self?.eventSubject.send(.itemTapped(joke))
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

// MARK: - Layout
private extension HomeViewController {
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets.trailing = UIConstants.spacing
        layoutItem.contentInsets.leading = UIConstants.spacing
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(UIConstants.layoutWidth), heightDimension: .estimated(UIConstants.layoutGroupHeight))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        layoutGroup.interItemSpacing = NSCollectionLayoutSpacing.fixed(UIConstants.spacing)
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(UIConstants.layoutWidth), heightDimension: .estimated(UIConstants.layoutHeaderHeight))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = UIConstants.spacing
        
        let layout = UICollectionViewCompositionalLayout(section: layoutSection)
        layout.configuration = config
        
        return layout
    }
}
