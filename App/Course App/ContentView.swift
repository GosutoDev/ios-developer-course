//
//  ContentView.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 26.04.2024.
//

import SwiftUI

struct ContentView: View {
    
    let imagesBaseURL = Configuration.default.imagesBaseURL
    let jokesBaseURL = Configuration.default.jokesBaseURL
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            print(imagesBaseURL)
            print(jokesBaseURL)
        }
    }
}

#Preview {
    ContentView()
}
