//
//  AttendanceTabScreen.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 1/14/25.
//

import SwiftUI

struct AttendanceTabScreen: View {
    @ObservedObject var fbManager = FirestoreManager.shared
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack(alignment: .leading) {
                    
                    Text("Attendance")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color("navy"))
                    
                    
//                    TabView {
                        
//                        Text("Today")
//                            .tabItem {
//                                Image(systemName: "house.fill")
//                                Text("Home")
//                            }
//                        
//                        Text("Week")
//                            .tabItem {
//                                Image(systemName: "globe")
//                                Text("Browse")
//                            }
//                        
//                        Text("Month")
//                            .tabItem {
//                                Image(systemName: "person.fill")
//                                Text("Profile")
//                            }
                        
                        
//                    }
//                    .tabViewStyle(PageTabViewStyle())
             
                    
                    
                }
                
                
            }
        }
    }
}

#Preview {
    AttendanceTabScreen()
}
