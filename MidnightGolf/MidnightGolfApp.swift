//
//  MidnightGolfApp.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 9/25/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

 // Setting Cloud Firestore up


//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure() // Configuring Firebase at the start of the application
//          
//    return true
//  }
//}

let db = Firestore.firestore()

@main
struct MidnightGolfApp: App {
    @ObservedObject var manager = FirestoreManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
//            ContentView(email: "", password: "", firstName: "", lastName: "", birthYear: 0)
//            CheckInScreen()
              SearchView()
        }
    }
}
