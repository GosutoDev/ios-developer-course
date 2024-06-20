//
//  TextType.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 24.05.2024.
//

import SwiftUI
import UIKit

public enum TextType {
    case navigationTitle
    case sectionTitle
    case baseText
    case caption
}

// MARK: - TextType attributes SwiftUI
public extension TextType {
    var font: Font {
        switch self {
        case .navigationTitle:
            .bold(with: .size28)
        case .caption:
            .regular(with: .size12)
        case .baseText:
            .regular(with: .size18)
        case .sectionTitle:
            .mediumItalic(with: .size22)
        }
    }

    var color: Color {
        .white
    }
}

// MARK: - TextType attributes UIKit
public extension TextType {
    var uiFont: UIFont {
        switch self {
        case .navigationTitle:
            .bold(with: .size28)
        case .caption:
            .regular(with: .size12)
        case .baseText:
            .regular(with: .size18)
        case .sectionTitle:
            .mediumItalic(with: .size22)
        }
    }

    var uiColor: UIColor {
        .white
    }
}
