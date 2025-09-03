//
//  ContentView.swift
//  Bullseye
//
//  Created by Yuxin Lin on 9/2/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var alterIsVisible: Bool = false
    @State var knockIsVisible: Bool = false
    
    var body: some View {
        
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("Welcome to my first app")
            
            Button("Hit me!") {
                print("Button clicked!")
                self.alterIsVisible = true
            }
            .alert(isPresented: $alterIsVisible){ () ->
                Alert in
                return Alert(title: Text("Hello there!"),
                             message: Text("This is my first pop-up."),
                             dismissButton: .default(Text("Awesome!")))
            }
            Button("Knock knock!") {
                print("Knocked")
                self.knockIsVisible = true
            }
            .alert(isPresented: $knockIsVisible){ () ->
                Alert in
                return Alert(title: Text("Hello there!"),
                             message: Text("It's me, Mario!"),
                             dismissButton: .default(Text("Awesome!")))
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
