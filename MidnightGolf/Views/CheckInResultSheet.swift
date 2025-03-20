//
//  CheckInResultSheet.swift
//  MidnightGolf
//
//  Created by Kasia Rivers on 3/19/25.
//
import SwiftUI

struct CheckInResultSheet: View {
    let message: String
    var result: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            ZStack {
                BackgroundImageView(screenWidth: screenWidth, screenHeight: screenHeight)
                VStack {
                    Spacer()
                    if result == true {
                        Image(systemName: "checkmark.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: screenWidth * 0.5, maxHeight: screenHeight * 0.5)
                            .foregroundStyle(.green)
                            .padding(.bottom)
                    } else {
                        Image(systemName: "x.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: screenWidth * 0.5, maxHeight: screenHeight * 0.5)
                            .foregroundStyle(.red)
                            .padding(.bottom)
                    }
                    Spacer()
                    Text(message)
                        .font(.custom("NeueMontreal-Regular", size: CheckInScreen.deviceWidth * 0.03))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("MGPnavy"))
                        .multilineTextAlignment(.center)
                    
                    Button("OK") {
                        dismiss()
                    }
                    .padding()
                    .cornerRadius(10)
                    Spacer()
                }
            }
        }
        .ignoresSafeArea()
    }
}
    
    #Preview {
        CheckInResultSheet(message: "Welcome, Hassan Alkhafaji!", result: true)
    }
