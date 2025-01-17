//
//  MidnightGolfApp.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 9/25/24.
//

import SwiftUI
import Firebase
 // Setting Cloud Firestore up


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
          
    return true
  }
}




@main
struct MidnightGolfApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
//    @ObservedObject var manager = FirestoreManager()
    
    init() {
        FirebaseApp.configure()
        
    }
    
    var body: some Scene {
        WindowGroup {
//            ContentView(email: "", password: "", firstName: "", lastName: "", birthYear: 0)
            CheckInScreen()
        }
    }
}
