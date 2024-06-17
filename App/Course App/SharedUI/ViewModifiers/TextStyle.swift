//
//  TextStyle.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 24.05.2024.
//

import SwiftUI
import DesignSystem

private struct TextStyle: ViewModifier {
    let textType: TextType

    func body(content: Content) -> some View {
        content
            .font(textType.font)
            .foregroundColor(textType.color)
    }
}

extension View {
    func textStyle(textType: TextType) -> some View {
        self.modifier(TextStyle(textType: textType))
    }
}
