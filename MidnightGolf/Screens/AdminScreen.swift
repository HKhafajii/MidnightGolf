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
                    
                 
                    NavigationButtons(destination: StudentDirectoryScreen().environmentObject(viewModel), destinationName: "Student Directory")
                    
                    
                    NavigationButtons(destination: AttendanceTabScreen().environmentObject(viewModel), destinationName: "Attendance")
                    
                    NavigationButtons(destination: EmailSenderView().environmentObject(viewModel), destinationName: "Send an Email")
                    
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


struct NavigationButtons<Destination: View>: View {
    
    var destination: Destination
    let destinationName: String
    
    var body: some View {
        NavigationStack {
            NavigationLink {
                destination
            } label: {
                Text(destinationName)
                    .font(.title)
                    .foregroundStyle(Color("MGPnavy"))
                    .fontWeight(.semibold)
                    .frame(maxWidth: CheckInScreen.deviceWidth / 5)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("MGPyellow"))
                            .shadow(radius: 8, x: 0, y: 8)
                    )
            }
            .padding()
        }
    }
}
