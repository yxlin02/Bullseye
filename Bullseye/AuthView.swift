//
//  AuthView.swift
//  Bullseye
//
//  Created by Yuxin Lin on 9/3/25.
//

import SwiftUI
import FirebaseAuth

struct AuthView: View {
    // variables for login
    @State private var email = ""
    @State private var password = ""
    // type of the messages
    @State private var errorMessage: String?
    @State private var successMessage: String?

    let midnightBlue = Color(red: 0.0/255.0, green: 51/255.0, blue: 102/255.0)

    struct LabelStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .foregroundColor(Color.white)
                .modifier(Shadow())
                .font(Font.custom("Arial Rounded MT Bold", size: 18))
        }
    }

    struct ValueStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .foregroundColor(Color.yellow)
                .modifier(Shadow())
                .font(Font.custom("Arial Rounded MT Bold", size: 24))
        }
    }

    struct Shadow: ViewModifier {
        func body(content: Content) -> some View {
            content
                .shadow(color: Color.black, radius: 5, x: 2, y: 2)
        }
    }

    struct ButtonLargeTextStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .foregroundColor(Color.black)
                .font(Font.custom("Arial Rounded MT Bold", size: 18))
        }
    }

    private let fieldBackgroundColor = Color(white: 1.0).opacity(0.8)
    private let fieldCornerRadius: CGFloat = 8

    var body: some View {
        VStack(spacing: 20) {
            
            //title row
            Text("Welcome to Bullseye!")
                .modifier(ValueStyle())
                .foregroundColor(.white)
                .padding(.bottom, 20)

            // email input row
            TextField("Email", text: $email)
                .padding()
                .background(Color.white)
                .cornerRadius(fieldCornerRadius)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .modifier(Shadow())
            
            //password input row
            SecureField("Password", text: $password)
                .padding()
                .background(Color.white)
                .cornerRadius(fieldCornerRadius)
                .modifier(Shadow())

            // display error or success messages
            // leared this syntax through gemini.ai
            if let displayErrorMessage = errorMessage {
                Text(displayErrorMessage)
                    .foregroundColor(.red)
                    .font(Font.custom("Arial Rounded MT Bold", size: 14))
            }

            if let displaySuccessMessage = successMessage {
                Text(displaySuccessMessage)
                    .foregroundColor(.green)
                    .font(Font.custom("Arial Rounded MT Bold", size: 14))
            }
            
            // signup row
            Button(action: {
                signUp()
            }) {
                Text("Sign Up")
                    .modifier(ButtonLargeTextStyle())
            }
            .background(Image("Button"))
            .modifier(Shadow())

            // sign in row
            Button(action: {
                signIn()
            }) {
                Text("Sign In")
                    .modifier(ButtonLargeTextStyle())
            }
            .background(Image("Button"))
            .modifier(Shadow())
        }
        .padding()
        .background(Image("Background"), alignment: .center)
        .accentColor(midnightBlue)
    }

    
    private func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.successMessage = nil
            } else {
                self.errorMessage = nil
                self.successMessage = "Successfully signed up!"
                print("Successfully signed up as: \(result?.user.uid ?? "N/A")")
            }
        }
    }

    private func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.successMessage = nil
            } else {
                self.errorMessage = nil
                self.successMessage = nil
                print("Successfully signed in as: \(result?.user.uid ?? "N/A")")
            }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
