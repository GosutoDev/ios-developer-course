//
//  HomeViewController+Extensions.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 14.05.2024.
//

import UIKit

// MARK: - UICollectionViewDataSource
extension HomeViewController {
    func readData() {
        dataProvider.$data.sink { [weak self] data in
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

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize = .zero
        size = CGSize(width: collectionView.bounds.width - Constants.flowLayoutWidth, height: collectionView.bounds.height / Constants.flowLayoutHeight)
        return size
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
extension HomeViewController {
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
        
        let layout = createCompositionalLayout()
        categoriesCollectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = self.dataProvider.data[sectionIndex]
            
            switch section.title {
            default:
                return self.createSection(with: section)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    func createSection(with section: SectionData) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(250))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
}
