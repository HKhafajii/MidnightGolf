//
//  CheckInScreen.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 12/15/24.
//

import SwiftUI

struct CheckInScreen: View {
    
    @State var searchTitle = ""
    static var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    static var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    @ObservedObject var fbManager = FirestoreManager.shared
    

    @StateObject private var timerManager = TimerManager()
    
    @State private var showAdminSheet = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: 25) {
                    
                    HStack {
                        Button {
                            showAdminSheet = true
                        } label: {
                            Image(systemName: "person.badge.key.fill")
                                .imageScale(.large)
                                .shadow(radius: 10, x: 0, y: 8)
                        }
                     
                        
                    
                        TimeView(viewModel: timerManager)
                    }
                    
                    Spacer()
                    
                    Image("logo")
                        .resizable()
                        .frame(
                            maxWidth: CheckInScreen.deviceWidth / 4,
                            maxHeight: CheckInScreen.deviceHeight / 2
                        )
                        .shadow(radius: 8, x: 0, y: 8)
                    
                    Text("Check In")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    
                    VStack {
                        
                        SearchView()
                            .frame(maxWidth: CheckInScreen.deviceWidth / 1.5)
                        
                        HStack {
                            Spacer()
                            
                            NavigationLink {
                                HelpScreen()
                            } label: {
                                Text("Help")
                                    .foregroundStyle(.gray)
                                    .fontWeight(.semibold)
                                    .font(.title2)
                                    .shadow(radius: 10, x: 0, y: 8)
                            }
                            .padding()
                            .padding(.trailing, 20)
                        }
                        .frame(maxWidth: CheckInScreen.deviceWidth / 1.5)
                    }
                    
                    NavigationLink {
                        ScanQRCodeView()
                    } label: {
                        Text("Scan QR Code")
                            .font(.title)
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                            .frame(maxWidth: CheckInScreen.deviceWidth / 5)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color("blue"))
                            )
                            .shadow(radius: 8, x: 0, y: 8)
                    }
                }
                .sheet(isPresented: $showAdminSheet) {
                    AdminVerificationSheetView()
                }
                .padding()
            }
        }
    }
}
#Preview {
    CheckInScreen()
}


struct TimeView: View {
    
 
    @ObservedObject var viewModel: TimerManager
    
    var body: some View {
        Text(viewModel.currentTime)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .frame(maxWidth: CheckInScreen.deviceWidth / 1.5)
            .padding()
            .shadow(radius: 8, x: 0, y: 8)
    }
}

