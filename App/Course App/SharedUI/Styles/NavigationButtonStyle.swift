//
//  NavigationButtonStyle.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 01.06.2024.
//

import SwiftUI

struct NavigationButtonStyle: ButtonStyle {
    private enum StyleConstant {
        static let divider: CGFloat = 2
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
            .padding(.vertical)
            .frame(width: UIScreen.main.bounds.width / StyleConstant.divider)
            .background(.blue.gradient)
            .clipShape(.rect(cornerRadius: CornerRadiusSize.default.rawValue))
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}
