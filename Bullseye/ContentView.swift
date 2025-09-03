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
    @State var score = 0
    @State var round = 1
    
    struct LabelStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .foregroundColor(Color.white)
                .modifier(Shadow())
                .font(Font.custom("Arial Rounded MT Bold", size: 18))
        }
    }
    
    struct ValueStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .foregroundColor(Color.yellow)
                .modifier(Shadow())
                .font(Font.custom("Arial Rounded MT Bold", size: 24))
        }
    }
    
    struct Shadow: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .shadow(color: Color.black, radius: 5, x: 2, y: 2)
        }
    }
    
    func startOver() {
        score = 0
        round = 1
        sliderValue = 50.0
        target = Int.random(in: 1...100)
    }
    
    func pointsForCurrentGuess() -> Int {
        let maxPoints = 100
        let diff = amountOff()
        let bonus: Int
        if diff == 0 {
            bonus = 100
        } else if diff == 1 {
            bonus = 50
        } else {
            bonus = 0
        }
        return maxPoints - diff + bonus
    }
    
    func sliderValueRounded() -> Int {
        return Int(sliderValue.rounded())
    }
    
    func amountOff() -> Int {
        return abs(target - sliderValueRounded())
    }
    
    func alertTitle() -> String {
        let diff = amountOff()
        let title: String
        if diff == 0 {
            title = "You're spot on!"
        } else if diff < 5 {
            title = "Pretty close!"
        } else if diff <= 10 {
            title = "You're getting warmer!"
        } else {
            title = "Way off!"
        }
        return title
    }
    
    var body: some View {
        
        VStack {
            // Target row
            Spacer()
            HStack {
                Text("Put the bullseye as close as you can to:").modifier(LabelStyle())
                Text("\(target)").modifier(ValueStyle())
            }
            Spacer()
            
            // Slider row
            HStack{
                Text("1").modifier(LabelStyle())
                Slider(value: $sliderValue, in: 1...100 )
                Text("100").modifier(LabelStyle())
            }
            Spacer()
            
            // Button row
            Button("Hit me!") {
                print("Button clicked!")
                alterIsVisible = true
                score = score + pointsForCurrentGuess()
            }
            .alert(isPresented: $alterIsVisible){ () ->
                Alert in
                return Alert(title: Text(alertTitle()),
                             message: Text("The slider's value is \(sliderValueRounded()).\n" + "Your score is \(pointsForCurrentGuess()) for this round."),
                             dismissButton: .default(Text("Awesome!")) {
                    target = Int.random(in: 1...100)
                    round += 1
                })
            }
            Spacer()
            
            // Score row
            HStack{
                Button("Start Over") {
                    self.startOver()
                }
                Spacer()
                Text("Score:").modifier(LabelStyle())
                Text("\(score)").modifier(ValueStyle())
                Spacer()
                Text("Round:").modifier(LabelStyle())
                Text("\(round)").modifier(ValueStyle())
                Spacer()
                Button("Info") {
                   
                }
            }
            .padding(.bottom, 20)
        }
        .padding()
        .background(Image("Background"), alignment: .center)
    }
}

#Preview {
    ContentView()
}
