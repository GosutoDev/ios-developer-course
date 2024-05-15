//
//  Constatns.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 14.05.2024.
//

import Foundation

enum Constants {
    static let flowLayoutWidth: CGFloat = 8
    static let flowLayoutHeight: CGFloat = 3
    static let minimumLineSpacing: CGFloat = 8
    static let minimumInteritemSpacing: CGFloat = 10
    static let sectionInset: CGFloat = 4
    static let headerReferenceSizeHeight: CGFloat = 30
    static let deadline = DispatchTime(uptimeNanoseconds: seconds)
    static let seconds: UInt64 = 4_000_000_000
    static let cornerRadius: CGFloat = 10
    static let numberOfImages = MockDataProvider().data.count
}
