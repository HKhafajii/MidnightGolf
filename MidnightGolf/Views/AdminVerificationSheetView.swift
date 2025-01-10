//
//  AdminVerificationSheetView.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 1/10/25.
//

import SwiftUI

struct AdminVerificationSheetView: View {
    @State private var pin: [Int] = [] // Stores entered digits
       let maxDigits = 4 // Limit to 4 digits
       
       var body: some View {
           VStack {
               Spacer()
               
               // Display entered PIN
               HStack(spacing: 15) {
                   ForEach(0..<maxDigits, id: \.self) { index in
                       Circle()
                           .strokeBorder(Color.blue, lineWidth: 2)
                           .frame(width: 20, height: 20)
                           .overlay(
                               Circle()
                                   .fill(pin.count > index ? Color.blue : Color.clear)
                                   .frame(width: 10, height: 10)
                           )
                   }
               }
               .padding()
               
               Spacer()
               
               // Number pad
               VStack(spacing: 10) {
                   ForEach(0..<3) { row in
                       HStack(spacing: 10) {
                           ForEach(1...3, id: \.self) { col in
                               let number = row * 3 + col
                               PinButton(number: number) {
                                   addDigit(number)
                               }
                           }
                       }
                   }
                   
                   // Bottom row: 0 and actions
                   HStack(spacing: 10) {
                       Spacer()
                       
                       PinButton(number: 0) {
                           addDigit(0)
                       }
                       
                       Button(action: deleteDigit) {
                           Image(systemName: "delete.left")
                               .font(.title)
                               .frame(width: 60, height: 60)
                               .background(Circle().fill(Color.gray.opacity(0.2)))
                       }
                   }
               }
               
               Spacer()
           }
           .padding()
           .navigationTitle("Enter PIN")
       }
       
       private func addDigit(_ digit: Int) {
           if pin.count < maxDigits {
               pin.append(digit)
           }
       }
       
       private func deleteDigit() {
           if !pin.isEmpty {
               pin.removeLast()
           }
       }
   }

   struct PinButton: View {
       let number: Int
       let action: () -> Void
       
       var body: some View {
           Button(action: action) {
               Text("\(number)")
                   .font(.title)
                   .frame(width: 60, height: 60)
                   .background(Circle().fill(Color.blue.opacity(0.2)))
           }
       }
}

#Preview {
    AdminVerificationSheetView()
}
