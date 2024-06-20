//
//  SignInViewState.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 17.06.2024.
//

import Foundation

struct SignInViewState {
    enum Status {
        case initial
        case signingIn
        case ready
        case loading
    }
    
    var emailField: String = ""
    var passwordField: String = ""
    var status: Status = .initial
    
    static let initial = SignInViewState()
}
