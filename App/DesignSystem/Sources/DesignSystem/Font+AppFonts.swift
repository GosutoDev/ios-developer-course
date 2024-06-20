//
//  Font+AppFonts.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 24.05.2024.
//

import SwiftUI

public extension Font {
    static func regular(with size: FontSize) -> Font {
        Font.custom(FontType.regular.rawValue, size: size.rawValue)
    }

    static func bold(with size: FontSize) -> Font {
        Font.custom(FontType.bold.rawValue, size: size.rawValue)
    }

    static func mediumItalic(with size: FontSize) -> Font {
        Font.custom(FontType.mediumItalic.rawValue, size: size.rawValue)
    }
}
