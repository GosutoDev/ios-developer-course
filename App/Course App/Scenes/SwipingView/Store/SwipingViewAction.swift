//
//  SwipingViewAction.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 15.06.2024.
//

import Foundation

enum SwipingViewAction {
    case viewDidLoad
    case dataLoaded([Joke])
    case didLike(Joke, Bool)
    case noMoreJokes
}
