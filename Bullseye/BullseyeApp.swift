//
//  BullseyeApp.swift
//  Bullseye
//
//  Created by Yuxin Lin on 9/2/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

// default set up code took from fire base
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct BullseyeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authState = AuthState() // state object for authentication state
    var body: some Scene {
        WindowGroup {
            if authState.isAuthenticated {
                ContentView()
            } else {
                AuthView()
            }
        }
    }
}

// Observable object to track authentication state from Firebase
// learned this through https://firebase.google.com/docs/auth/ios/start
class AuthState: ObservableObject {
    @Published var isAuthenticated = false
    
    //a private property to hold the listener handle
    // if I don't hold it, the listener might get deallocated and stop working
    private var authHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        // learned this from gemini.ai
        authHandle = Auth.auth().addStateDidChangeListener { auth, user in
            self.isAuthenticated = user != nil // check if user is nil and assign the result to isAuthenticated
            if self.isAuthenticated {
                print("User is logged in: \(user!.uid)")
            } else {
                print("User is logged out.")
            }
        }
    }
}
