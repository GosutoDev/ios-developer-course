//
//  Image+ResizableBordered.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 22.05.2024.
//

import SwiftUI

extension Image {
    func resizableBordered(cornerRadius: CGFloat) -> some View {
        self
            .resizable()
            .scaledToFill()
            .bordered(cornerRadius: cornerRadius)
    }
}
