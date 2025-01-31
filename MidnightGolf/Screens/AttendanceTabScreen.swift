//
//  AttendanceTabScreen.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 1/14/25.
//

import SwiftUI

struct AttendanceTabScreen: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack(alignment: .leading) {
                    
                    Text("Attendance")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color("navy"))
                    
                    
                    TabView {

                        Tab {
                            Image(systemName: "person.fill")
                        } label: {
                            Image(systemName: "person.fill")
                        }
                        

                        
                    }
                    .tabViewStyle(PageTabViewStyle())
             
                    
                    
                }
                .padding()
                
                
            }
        }
    }
}

#Preview {
    AttendanceTabScreen()
}
