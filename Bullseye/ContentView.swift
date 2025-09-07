//
//  ContentView.swift
//  Bullseye
//
//  Created by Yuxin Lin on 9/2/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ContentView: View {
    
    @State var alterIsVisible = false
    @State var sliderValue = 50.0
    @State var target = Int.random(in: 1...100)
    @State var score = 0
    @State var round = 1
    let midnightBlue = Color(red: 0.0/255.0, green: 51/255.0, blue: 102/255.0)
    let navYellow = Color(red: 250/255.0, green: 127/255.0, blue: 82/255.0)
    
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
    
    struct ButtonLargeTextStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .foregroundColor(Color.black)
                .font(Font.custom("Arial Rounded MT Bold", size: 18))
        }
    }
    
    struct ButtonSmallTextStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .foregroundColor(Color.black)
                .font(Font.custom("Arial Rounded MT Bold", size: 12))
        }
    }
    
    
    
    var body: some View {
        
        NavigationStack {
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
                    Slider(value: $sliderValue, in: 1...100 ).accentColor(Color.green)
                    Text("100").modifier(LabelStyle())
                }
                Spacer()
                
                // Button row
                
                Button (action: {
                    alterIsVisible = true
                    score = score + pointsForCurrentGuess()
                }, label: {
                    Text("Hit Me!").modifier(ButtonLargeTextStyle())
                })
                .alert(isPresented: $alterIsVisible){ () ->
                    Alert in
                    return Alert(title: Text(alertTitle()),
                                 message: Text("The slider's value is \(sliderValueRounded()).\n" + "Your score is \(pointsForCurrentGuess()) for this round."),
                                 dismissButton: .default(Text("Awesome!")) {
                        target = Int.random(in: 1...100)
                        round += 1
                        
                        //submit the score to Firestore on a new round
                        submitScore(currentScore: score)
                    })
                }
                .background(Image("Button")).modifier(Shadow())
                Spacer()
                
                // Score row
                HStack{
                    VStack(spacing: 25) {
                        Button(action: {
                            signOut()
                        }, label: {
                            Text("Log Out").modifier(ButtonSmallTextStyle())
                        })
                        .background(Image("Button")).modifier(Shadow())
                    
                        
                        Button (action: {
                            startOver()
                        }, label: {
                            HStack {
                                Image("StartOverIcon")
                                Text("Start Over").modifier(ButtonSmallTextStyle())
                            }
                        }).background(Image("Button")).modifier(Shadow())
                    }
                    Spacer()
                    Text("Score:").modifier(LabelStyle())
                    Text("\(score)").modifier(ValueStyle())
                    Spacer()
                    Text("Round:").modifier(LabelStyle())
                    Text("\(round)").modifier(ValueStyle())
                    Spacer()
                    VStack (spacing: 25){
                        NavigationLink(destination: LeaderBoardView(), label: {
                            Text("Leaderboard").modifier(ButtonSmallTextStyle())
                        })
                        .background(Image("Button")).modifier(Shadow())
                        
                        NavigationLink(destination: AboutView(), label: {
                            HStack {
                                Image("InfoIcon")
                                Text("Info").modifier(ButtonSmallTextStyle())
                            }})
                        .background(Image("Button")).modifier(Shadow())
                    }
                }
                .padding(.bottom, 20)
            }
            .padding()
            .background(Image("Background"), alignment: .center)
            .accentColor(midnightBlue)
            .navigationTitle("Bullseye")
            .toolbarBackground(navYellow.opacity(0.5), for: .navigationBar)
            .toolbarBackgroundVisibility(.visible, for: .navigationBar)
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
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            print("User signed out successfully.")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func submitScore(currentScore: Int){
        //just to make sure user is signed in
        guard let user = Auth.auth().currentUser else {
                    print("No user is signed in.")
                    return
        }
        
        let db = Firestore.firestore()
        let userDocRef = db.collection("highscores").document(user.uid)

        // Use a transaction to ensure atomic read-write
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let userDocument: DocumentSnapshot
            do {
                userDocument = try transaction.getDocument(userDocRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            //get the existing high score, or set it to 0 if none exists
            let existingScore = userDocument.data()?["score"] as? Int ?? 0

            //if the current score is higher than the existing high score, update it
            if currentScore > existingScore {
                transaction.setData(["score": currentScore, "email": user.email ?? ""], forDocument: userDocRef)
            }
            
            return nil
        }) { (object, error) in // print result to console for debugging
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                print("Score updated successfully.")
            }
        }
    }
}

#Preview {
    ContentView()
}
