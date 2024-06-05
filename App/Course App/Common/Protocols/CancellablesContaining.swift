//
//  CancellablesContaining.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 05.06.2024.
//

import Combine

protocol CancellablesContaining: AnyObject {
    var cancellables: Set<AnyCancellable> { get set }
}
