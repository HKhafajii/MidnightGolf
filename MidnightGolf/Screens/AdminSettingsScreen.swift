//
//  AdminSettingsScreen.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 3/10/25.
//

import SwiftUI

struct AdminSettingsScreen: View {
    
    @State private var showChangeLateThreshold: Bool = false
    @State private var showSomethingSheet: Bool = false
    
    var body: some View {
            
            List {
                
                
                Button {
                    showChangeLateThreshold = true
                } label: {
                    Text("Change Late Threshold")
                        .foregroundStyle(Color("MGPnavy"))
                        .font(.headline)
                }
                
                Button {
                    showSomethingSheet = true
                } label: {
                    Text("Show something else")
                        .foregroundStyle(Color("MGPnavy"))
                        .font(.headline)
                }
                
                .sheet(isPresented: $showChangeLateThreshold) {
                    LateThresholdChanges()
                }
            }
    }
}

#Preview {
    AdminSettingsScreen()
}


struct LateThresholdChanges: View {
    @State var intValue: Int = 0
    var body: some View {
        VStack {
            
            NumberFieldComponent(title: "Threshold Hour", description: "Type an hour", intValue: intValue)
            NumberFieldComponent(title: "Threshold Minute", description: "Type an hour", intValue: intValue)
            
            
            
        }
    }
}


