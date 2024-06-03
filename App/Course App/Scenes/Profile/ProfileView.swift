//
//  ProfileView.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 03.06.2024.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            Text("Profile")
                .foregroundStyle(.black)
                .textStyle(textType: .baseText)
        }
        .navigationTitle("Profile")
    }
}

#Preview {
    ProfileView()
}
