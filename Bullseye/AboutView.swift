//
//  AboutView.swift
//  Bullseye
//
//  Created by Yuxin Lin on 9/3/25.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("🎯 Bullseye 🎯")
                Text("This is Bullseye, the game where you can win points and earn fame by dragging a slider.")
                Text("Your goal is to place the slider as close as possible to the target value. The closer you are, the more points you score.")
                Text("Enjoy!")
            }
        }
        .navigationTitle("About Bullseye")
    }
}

#Preview {
    AboutView()
}
