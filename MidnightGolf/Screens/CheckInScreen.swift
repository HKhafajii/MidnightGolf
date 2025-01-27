//
//  CheckInScreen.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 12/15/24.
//

import SwiftUI
import CodeScanner


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
    @State private var showScanSheet = false
    @State private var navigateToNextScreen = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: 25) {
                    
                    HStack {
                        
                        TimeView(viewModel: timerManager)
                        
                        Button {
                            showAdminSheet = true
                        } label: {
                            Image(systemName: "person.badge.key.fill")
                            
                                .resizable()
                                .frame(maxWidth: 45, maxHeight: 40)
                                .foregroundStyle(Color("navy"))
                                .shadow(radius: 10, x: 0, y: 5)
                        }
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
                        .foregroundStyle(Color("navy"))
                    
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
                    
                    
                    Button("Scan", systemImage: "qrcode.viewfinder") {
                        
                        showScanSheet = true
                        
                    }
                    .font(.largeTitle)
                    .foregroundStyle(Color("navy"))
                    .fontWeight(.semibold)
                    .frame(maxWidth: CheckInScreen.deviceWidth / 5)
                    .shadow(radius: 8, x: 0, y: 8)
                    
                    .sheet(isPresented: $showScanSheet) {
                        CodeScannerView(codeTypes: [.qr], simulatedData: "Hassan alkhafaji\nalkhafajihassan@gmail.com", completion: handleScan)
                    }
  
                    NavigationLink(destination: AdminScreen(), isActive: $navigateToNextScreen) {
                        EmptyView()
                    }
                }
                .sheet(isPresented: $showAdminSheet) {
                    AdminVerificationSheetView(navigateToNextScreen: $navigateToNextScreen, showAdminSheet: $showAdminSheet)
                }
                .padding()
            }
        }
    }
      func handleScan(result: Result<ScanResult, ScanError>) {
    
          showScanSheet = false
    
        
            switch result {
            case .success(let result):
                let scannedCode = result.string
                if let student = fbManager.students.first(where: {
                    String(data: $0.qrCode, encoding: .utf8) == scannedCode
                }) {
                    fbManager.checkInManager.handleCheckInorOut(for: student)
                    print("Scanned code matches")
                    
                }
            case .failure(let error):
                print("Scanning failed: \(error.localizedDescription)")
            }    }
}
#Preview {
    CheckInScreen()
}


struct TimeView: View {
    
    
    @ObservedObject var viewModel: TimerManager
    
    var body: some View {
        Text(viewModel.currentTime)
            .font(.largeTitle)
            .foregroundStyle(Color("navy"))
            .fontWeight(.semibold)
            .frame(maxWidth: CheckInScreen.deviceWidth / 1.5)
            .padding()
            .shadow(radius: 8, x: 0, y: 5)
    }
}

