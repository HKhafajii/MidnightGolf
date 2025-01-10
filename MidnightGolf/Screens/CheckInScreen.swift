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
    
    @StateObject var fbManager = FirestoreManager()
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: 50) {
                    
                    HStack {
                        Image(systemName: "person.badge.key.fill")
                        TimeView()
                    }
                    
                    
                    Spacer()
                    
                    Image("logo")
                        .resizable()
                        .frame(maxWidth: CheckInScreen.deviceWidth / 2.8, maxHeight: CheckInScreen.deviceHeight / 3.5)
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
                        } // End of Hstack
                        .frame(maxWidth: CheckInScreen.deviceWidth / 1.5)
                    }
                    
                    NavigationLink {
                        ScanQRCodeView()
                    } label: {
                        Text("Scan QR Code")
                            .font(.title)
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                            .frame(maxWidth: CheckInScreen.deviceWidth / 2)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color("blue")))
                            .shadow(radius: 8, x: 0, y: 8)
                    }
                } // End of VStack
                .padding()
            } // End of ZStack
        } // End of NavigationStack
    }
}

#Preview {
    CheckInScreen()
}


struct TimeView: View {
    
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var timeNow = ""
    let dateFormatter = DateFormatter()
    
    var body: some View {
        Text(timeNow)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .frame(maxWidth: CheckInScreen.deviceWidth / 1.5)
            .padding()
            .shadow(radius: 8, x: 0, y: 8)
            .onReceive(timer) { _ in
                self.timeNow = dateFormatter.string(from: Date())
            }
            .onAppear(perform: {dateFormatter.dateFormat = "LLLL dd, hh:mm:ss a"})
    }
} // End of TimeView

