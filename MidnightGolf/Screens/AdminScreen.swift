//
//  AdminScreen.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 1/10/25.
//

import SwiftUI

struct AdminScreen: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @State var showSheet = false
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack(spacing: 50) {
                    
                    NavigationLink {
                        StudentDirectoryScreen()
                    } label: {
                        Text("Student Directory")
                            .font(.title)
                            .foregroundStyle(Color("navy"))
                            .fontWeight(.semibold)
                            .frame(maxWidth: CheckInScreen.deviceWidth / 5)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color("yellow"))
                                    .shadow(radius: 8, x: 0, y: 8)
                            )
                    }
                    .padding()
                    
                    
                    
                    NavigationLink {
                        AttendanceTabScreen()
                            .environmentObject(viewModel)
                    } label: {
                        Text("Current Attendence")
                            .font(.title)
                            .foregroundStyle(Color("navy"))
                            .fontWeight(.semibold)
                            .frame(maxWidth: CheckInScreen.deviceWidth / 5)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color("yellow"))
                                    .shadow(radius: 8, x: 0, y: 8)
                            )
                    }
                    .padding()
                    
               
                    
                                    

                    
                }
                .padding()
                
                
            }
        }
    }
}

#Preview {
    AdminScreen()
        .environmentObject(ViewModel())
}
