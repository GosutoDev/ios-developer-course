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
        }
    }
}

#Preview {
    ContentView()
}
