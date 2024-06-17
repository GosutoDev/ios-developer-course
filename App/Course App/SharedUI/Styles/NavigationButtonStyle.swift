//
//  NavigationButtonStyle.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 01.06.2024.
//

import SwiftUI
import DesignSystem

struct NavigationButtonStyle: ButtonStyle {
    private enum StyleConstant {
        static let divider: CGFloat = 2
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
            .padding(.vertical)
            .frame(width: UIScreen.main.bounds.width / StyleConstant.divider)
            .background(.brown.gradient)
            .clipShape(.rect(cornerRadius: CornerRadiusSize.default.rawValue))
            .opacity(configuration.isPressed ? OpacityVisibility.half.rawValue : OpacityVisibility.default.rawValue)
    }
}
