//
//  TextFieldComponents.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 3/18/25.
//

import SwiftUI

struct TextfieldComponent: View {
    
    let title: String
    @State var description: String
    @Binding var bindingString: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            TextField(description, text: $bindingString)
                .padding()
                .frame(maxWidth: CheckInScreen.deviceWidth / 2)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(16)
                .submitLabel(.done)
        }
    }
}


struct EmailFieldComponent: View {
    
    let title: String
    @State var description: String
    @Binding var bindingString: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            TextField(description, text: $bindingString)
                .padding()
                .keyboardType(.emailAddress)
                .frame(maxWidth: CheckInScreen.deviceWidth / 2)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(16)
                .submitLabel(.done)
        }
    }
}
struct CellFieldComponent: View {
    
    let title: String
    @State var description: String
    @Binding var bindingString: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            TextField(description, text: $bindingString)
                .padding()
                .keyboardType(.phonePad)
                .frame(maxWidth: CheckInScreen.deviceWidth / 2)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(16)
                .submitLabel(.done)
        }
    }
}

struct NumberFieldComponent: View {
    let title: String
    let description: String
    
    @State var intValue: Int
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            TextField(description, value: $intValue, format: .number)
                .padding()
                .keyboardType(.numberPad)
                .frame(maxWidth: CheckInScreen.deviceWidth / 2)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(16)
                .submitLabel(.done)
        }
        
    }
}

