//
//  OnboardingPage.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 01.06.2024.
//

import Foundation

enum OnboardingPage: Int, CaseIterable {
    case welcome = 1
    case about
    case diveIn
    
    var title: String {
        switch self {
        case .welcome:
            "Welcome"
        case .about:
            "About"
        case .diveIn:
            "Let's dive in"
        }
    }
}
