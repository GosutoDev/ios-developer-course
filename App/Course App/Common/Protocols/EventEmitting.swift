//
//  EventEmitting.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 03.06.2024.
//

import Combine

protocol EventEmitting {
    associatedtype Event
    
    var eventPublisher: AnyPublisher<Event, Never> { get }
}
