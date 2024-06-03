//
//  ProfileView.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 03.06.2024.
//

import Combine
import SwiftUI

struct ProfileView: View {
    
//    private let eventSubject = PassthroughSubject<Event, Never>()
    
    var body: some View {
        VStack {
            Text("Profile")
                .foregroundStyle(.black)
                .textStyle(textType: .baseText)
                .underline()
            
            Button("Onboarding") {
                
            }
            .buttonStyle(.navigationButtonStyle)
            
            Button("Onboarding modal") {
                
            }
            .buttonStyle(.navigationButtonStyle)
            
            Button("Logout") {
                
            }
            .buttonStyle(.navigationButtonStyle)
        }
    }
}

// MARK: - Event Emitter
extension ProfileView: EventEmitting {
    var eventPublisher: AnyPublisher<Event, Never> {
        
    }
}

#Preview {
    ProfileView()
}
