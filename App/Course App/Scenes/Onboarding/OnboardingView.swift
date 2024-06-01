//
//  OnboardingView.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 01.06.2024.
//

import SwiftUI

struct OnboardingView: View {
    let page: OnboardingPage
    
    init(page: OnboardingPage) {
        self.page = page
    }
    
    var body: some View {
        VStack(spacing: PaddingSize.default.rawValue) {
            Text("This page name is \(page.title).")
                .foregroundStyle(.black)
                .textStyle(textType: .baseText)
                .underline()
            
            Button("Next page") {
            }
            .buttonStyle(.navigationButtonStyle)
            
            Button("Close") {
            }
            .buttonStyle(.navigationButtonStyle)
        }
        .navigationTitle("Onboarding")
    }
}

#Preview {
    NavigationStack {
        OnboardingView(page: .welcome)
    }
}
