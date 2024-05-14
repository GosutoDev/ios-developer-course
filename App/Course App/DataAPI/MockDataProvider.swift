//
//  MockDataProvider.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 14.05.2024.
//

import UIKit

let mockImages = [
    UIImage.nature,
    UIImage.computer,
    UIImage.food
]

struct SectionData: Identifiable, Hashable {
    let id = UUID()
    let title: String
    var jokes: [Joke]
}

struct Joke: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let image = mockImages.randomElement()
}

final class MockDataProvider: ObservableObject {
    @Published var data: [SectionData]
    
    private var localData = [
        SectionData(title: "Celebrations", jokes: [
            Joke(text: "Chuck Norris can make hamburger out of ham."),
            Joke(text: "All your base are belong to Chuck Norris"),
            Joke(text: "Chuck Norris can hit a barn door with a broad's side.")
        ])
    ]
    
    init() {
        data = localData
        updateData()
    }
}

private extension MockDataProvider {
    func updateData() {
        DispatchQueue.main.asyncAfter(deadline: Constatns.deadline, execute: {
            if var section = self.localData.first {
                section.jokes.remove(at: 1)
                self.data = [section]
            }
        })
    }
}
