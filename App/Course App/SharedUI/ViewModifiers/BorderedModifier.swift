//
//  BorderedModifier.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 22.05.2024.
//

import SwiftUI

struct BorderedModifier: ViewModifier {
    // MARK: UIConstants
    private enum UIConstants {
        static let lineWidth: CGFloat = 2
        static let shadowRadius: CGFloat = 2
    }
    
    var cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(.gray)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white, lineWidth: UIConstants.lineWidth)
            )
            .shadow(radius: UIConstants.shadowRadius)
    }
}

extension View {
    func bordered(cornerRadius: CGFloat) -> some View {
        self.modifier(BorderedModifier(cornerRadius: cornerRadius))
    }
}
