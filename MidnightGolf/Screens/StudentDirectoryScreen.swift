//
//  StudentDirectoryScreen.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 1/14/25.
//

import SwiftUI

struct StudentDirectoryScreen: View {
    @ObservedObject var fbManager = FirestoreManager.shared
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 25) {
                   
                    Text("Student Directory")
                        .font(.largeTitle)
                        .foregroundStyle(Color("navy"))
                        .fontWeight(.bold)
                        
                    
                }
                .padding()
                
                
            }
        }
    }
}

#Preview {
    StudentDirectoryScreen()
}
