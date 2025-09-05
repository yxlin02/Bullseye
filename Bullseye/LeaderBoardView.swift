//
//  LeaderBoardView.swift
//  Bullseye
//
//  Created by Yuxin Lin on 9/4/25.
//

import SwiftUI
import FirebaseFirestore

struct LeaderBoardView: View {
    
    let beige = Color(red: 255/255.0 , green: 214/255.0, blue: 179/255.0)
    let navYellow = Color(red: 250/255.0, green: 127/255.0, blue: 82/255.0)
    
    @State private var highScores: [Score] = []
    
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
    
    
    //simple struct to model data
    struct Score: Identifiable {
        var id: String
        var email: String
        var score: Int
    }
    
    var body: some View {
        NavigationStack {
            Group {
                VStack {
                    Text("🏆 Leaderboard 🏆").modifier(AboutHeadingStyle())
                    List {
                        ForEach(highScores) { score in
                            HStack {
                                Text(score.email).modifier(AboutBodyStyle())
                                Spacer()
                                Text("\(score.score)").modifier(AboutBodyStyle())
                            }
                        }
                    }
                    .onAppear {
                        fetchHighScores()
                    }
                }
                .padding()
                .background(beige)
                .cornerRadius(12)
            }.background(Image("Background"))
        }
        .toolbarBackground(navYellow.opacity(0.5), for: .navigationBar)
        .toolbarBackgroundVisibility(.visible, for: .navigationBar)
    }
    
    func fetchHighScores() {
        let db = Firestore.firestore()
        db.collection("highscores").order(by: "score", descending: true).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.highScores = documents.map { (queryDocumentSnapshot) -> Score in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let email = data["email"] as? String ?? "N/A"
                let score = data["score"] as? Int ?? 0
                return Score(id: id, email: email, score: score)
            }
        }
    }
}

struct LeaderBoardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderBoardView()
    }
}
