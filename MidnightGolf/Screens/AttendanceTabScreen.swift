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
                VStack {
                    
                }
                
                
            }
        }
    }
}

#Preview {
    AttendanceTabScreen()
}
