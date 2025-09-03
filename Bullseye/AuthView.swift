//
//  AuthView.swift
//  Bullseye
//
//  Created by Yuxin Lin on 9/3/25.
//

import SwiftUI
import FirebaseAuth

struct AuthView: View {
    @State private var email = ""
    @State private var password = ""
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
            Text("Welcome to Bullseye!")
                .modifier(ValueStyle())
                .foregroundColor(.white)
                .padding(.bottom, 20)

            TextField("Email", text: $email)
                .padding()
                .background(Color.white)
                .cornerRadius(fieldCornerRadius)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .modifier(Shadow())

            SecureField("Password", text: $password)
                .padding()
                .background(Color.white)
                .cornerRadius(fieldCornerRadius)
                .modifier(Shadow())

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(Font.custom("Arial Rounded MT Bold", size: 14))
            }

            if let successMessage = successMessage {
                Text(successMessage)
                    .foregroundColor(.green)
                    .font(Font.custom("Arial Rounded MT Bold", size: 14))
            }

            Button(action: {
                signUp()
            }) {
                Text("Sign Up")
                    .modifier(ButtonLargeTextStyle())
            }
            .background(Image("Button"))
            .modifier(Shadow())

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
