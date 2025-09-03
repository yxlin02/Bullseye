//
//  ContentView.swift
//  Bullseye
//
//  Created by Yuxin Lin on 9/2/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var alterIsVisible = false
    @State var sliderValue = 50.0
    @State var target = Int.random(in: 1...100)
    
    func pointsForCurrentGuess() -> Int {
        return 100 - abs(target - sliderValueRounded())
    }
    
    func sliderValueRounded() -> Int {
        return Int(sliderValue.rounded())
    }
    
    var body: some View {
        
        VStack {
            // Target row
            Spacer()
            HStack {
                Text("Put the bullseye as close as you can to:")
                Text("\(target)")
            }
            Spacer()
            
            // Slider row
            HStack{
                Text("1")
                Slider(value: $sliderValue, in: 1...100 )
                Text("100")
            }
            Spacer()
            
            // Button row
            Button("Hit me!") {
                print("Button clicked!")
                alterIsVisible = true
            }
            .alert(isPresented: $alterIsVisible){ () ->
                Alert in
                return Alert(title: Text("Hello there!"),
                             message: Text("The slider's value is \(sliderValueRounded()).\n" + "Your score is \(pointsForCurrentGuess()) for this round."),
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
