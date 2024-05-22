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
    static let deadline = DispatchTime(uptimeNanoseconds: seconds)
    static let seconds: UInt64 = 4_000_000_000
    static let cornerRadius: CGFloat = 10
    static let numberOfImages = MockDataProvider().data.count
    static let interSectionSpacing: CGFloat = 20
    static let layoutWidth: CGFloat = 0.93
    static let layoutGroupHeight: CGFloat = 250
    static let layoutHeaderHeight: CGFloat = 80
}
