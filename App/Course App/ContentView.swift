//
//  ContentView.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 26.04.2024.
//

import os
import SwiftUI

struct ContentView: View {
    let imagesBaseURL = Configuration.default.imagesBaseURL
    let jokesBaseURL = Configuration.default.jokesBaseURL
    
    private let logger = Logger()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            logger.info("Images URL = \(imagesBaseURL)")
            logger.info("Jokes URL = \(jokesBaseURL)")
            
            
            // Fonts identifier
            let identifier: String = "[SYSTEM FONTS]"
            for family in UIFont.familyNames as [String] {
                debugPrint("\(identifier) FONT FAMILY: \(family)")
                for name in UIFont.fontNames(forFamilyName: family) {
                    debugPrint("\(identifier) FONT NAME: \(name)")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
