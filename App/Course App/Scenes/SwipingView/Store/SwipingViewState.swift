//
//  SwipingViewState.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 15.06.2024.
//

import Foundation

struct SwipingViewState {
    enum Status {
        case initial
        case loading
        case ready
    }
    
    var jokes: [Joke] = []
    var status: Status = .initial
    
    static let initial = SwipingViewState()
}
