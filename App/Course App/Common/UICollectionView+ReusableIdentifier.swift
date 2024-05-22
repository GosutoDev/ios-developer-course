//
//  UICollectionView+ReusableIdentifier.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 14.05.2024.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableIdentifier {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }
    
    func register<T: UICollectionViewCell>(_: T.Type, forSupplementaryViewOfKind: String) where T: ReusableIdentifier {
        register(
            T.self,
            forSupplementaryViewOfKind: forSupplementaryViewOfKind,
            withReuseIdentifier: T.identifier
        )
    }
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: ReusableIdentifier {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Cell with identifier: \(T.identifier) could not be dequeue!")
        }
        return cell
    }
    
    func dequeueSupplementaryView<T: UICollectionViewCell>(ofKind: String, for indexPath: IndexPath) -> T where T: ReusableIdentifier {
        guard let cell = dequeueReusableSupplementaryView(
            ofKind: ofKind,
            withReuseIdentifier: T.identifier,
            for: indexPath
        ) as? T else {
            fatalError("SupplementaryView with identfier: \(T.identifier) could not be dequeue!")
        }
        return cell
    }
}
