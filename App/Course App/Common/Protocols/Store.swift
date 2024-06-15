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
    
    var viewState: State { get }
    
    func send(action: Action)
}
