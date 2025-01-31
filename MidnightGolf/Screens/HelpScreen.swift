//
//  HelpScreen.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 12/15/24.
//

import SwiftUI

struct HelpScreen: View {
    var body: some View {
        ZStack {
            Color("blue")
                .ignoresSafeArea()
            
            Image(systemName: "questionmark.circle.fill")
                .resizable()
                .frame(maxWidth: 400, maxHeight: 400)
                .offset(y: -150)
                .foregroundStyle(.white)
                .shadow(radius: 10, x: 0, y: 10)
            
            VStack(spacing: 25) {
                Spacer()
//                Scan QR Code:
//                   Tap "Scan QR Code" and use your camera to scan the code.
//                Search Name:
//                   Type “Your Name" in the search field and select it from the list.
//                If you have any trouble, please ask for assistance.
                VStack {
                    Text("Scan QR Code: ")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    
                    Text("Tap Scan QR Code and use your camera to scan the code. ")
                        .font(.title)
                        .foregroundStyle(.white)
                }
                
                
                VStack {
                    Text("Search Your Name: ")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    
                    Text("Type Your Name in the search field and select it from the list.")
                        .font(.title)
                        .foregroundStyle(.white)
                }
                
                Text(" If you have any trouble, please ask for assistance.")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)

                
                
                
            }
            .shadow(radius: 10)
            .padding()
            
        }
    }
}

#Preview {
    HelpScreen()
}
