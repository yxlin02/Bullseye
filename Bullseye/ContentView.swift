//
//  ContentView.swift
//  Bullseye
//
//  Created by Yuxin Lin on 9/2/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var alterIsVisible: Bool = false
    @State var sliderValue: Double = 50.0
    
    var body: some View {
        
        VStack {
            // Target row
            Spacer()
            HStack {
                Text("Put the bullseye as close as you can to:")
                Text("100")
            }
            Spacer()
            
            // Slider row
            HStack{
                Text("1")
                Slider(value: self.$sliderValue, in: 1...100 )
                Text("100")
            }
            Spacer()
            
            // Button row
            Button("Hit me!") {
                print("Button clicked!")
                self.alterIsVisible = true
            }
            .alert(isPresented: $alterIsVisible){ () ->
                Alert in
                var roundedValue: Int = Int(self.sliderValue.rounded())
                return Alert(title: Text("Hello there!"),
                             message: Text("The slider's value is \(roundedValue)."),
                             dismissButton: .default(Text("Awesome!")))
            }
            Spacer()
            
            // Score row
            HStack{
                Button("Start Over") {
                   
                }
                Spacer()
                Text("Score:")
                Text("999")
                Spacer()
                Text("Round:")
                Text("999")
                Spacer()
                Button("Info") {
                   
                }
            }
            .padding(.bottom, 20)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
