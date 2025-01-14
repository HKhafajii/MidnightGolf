//
//  AdminScreen.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 1/10/25.
//

import SwiftUI

struct AdminScreen: View {
    
    @ObservedObject var fbManager = FirestoreManager.shared
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack(spacing: 25) {
                    
                    NavigationLink {
                        UsersView()
                    } label: {
                        Text("User View")
                    }

                    
                }
                
                
            }
        }
    }
}

#Preview {
    AdminScreen()
}
