//
//  AboutView.swift
//  Bullseye
//
//  Created by Yuxin Lin on 9/3/25.
//

import SwiftUI

struct AboutView: View {
    
    let beige = Color(red: 255/255.0 , green: 214/255.0, blue: 179/255.0)
    let navYellow = Color(red: 250/255.0, green: 127/255.0, blue: 82/255.0)
    
    struct AboutHeadingStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .foregroundColor(Color.black)
                .font(Font.custom("Arial Rounded MT Bold", size: 30))
                .padding(.top, 20)
                .padding(.bottom, 20)
        }
    }
    
    struct AboutBodyStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .foregroundColor(Color.black)
                .font(Font.custom("Arial Rounded MT Bold", size: 16))
                .padding(.leading, 60)
                .padding(.trailing, 60)
                .padding(.bottom, 20)
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                VStack {
                    Text("🎯 Bullseye 🎯").modifier(AboutHeadingStyle())
                    Text("This is Bullseye, the game where you can win points and earn fame by dragging a slider.").modifier(AboutBodyStyle())
                    Text("Your goal is to place the slider as close as possible to the target value. The closer you are, the more points you score.").modifier(AboutBodyStyle())
                    Text("Enjoy!").modifier(AboutBodyStyle())
                }.background(beige)
            }.background(Image("Background"))
        }
        .navigationTitle("About Bullseye")
        .toolbarBackground(navYellow.opacity(0.5), for: .navigationBar)
        .toolbarBackgroundVisibility(.visible, for: .navigationBar)
    }
}

#Preview {
    AboutView()
}
