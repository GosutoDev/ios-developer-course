//
//  Store.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 14.06.2024.
//

import Foundation

protocol Store {
    associatedtype State
    associatedtype Action
    
    @MainActor var viewState: State { get }
    
    @MainActor func send(action: Action)
}
