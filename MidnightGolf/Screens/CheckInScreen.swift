//
//  CheckInScreen.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 12/15/24.
//

import SwiftUI
import CodeScanner


struct CheckInScreen: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @StateObject private var timerManager = TimerManager()
    
    @State var searchTitle = ""
    @State private var showAdminSheet = false
    @State private var showScanSheet = false
    @State private var navigateToNextScreen = false
    static var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    static var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
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
                            .environmentObject(viewModel)
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
                    
                    
                    Button("Scan", systemImage: "qrcode.viewfinder") { showScanSheet = true }
                        .disabled(viewModel.firestoreManager.isLoadingStudents)
                        .font(.largeTitle)
                        .foregroundStyle(Color("navy"))
                        .fontWeight(.semibold)
                        .frame(maxWidth: CheckInScreen.deviceWidth / 5)
                        .shadow(radius: 8, x: 0, y: 8)
                    
                        .sheet(isPresented: $showScanSheet) {
                            CodeScannerView(codeTypes: [.qr], simulatedData: "Hassan alkhafaji\nalkhafajihassan@gmail.com", completion: handleScan)
                        }
                    
                    NavigationLink(destination: AdminScreen().environmentObject(viewModel), isActive: $navigateToNextScreen) {
                        EmptyView()
                    }
                }
                .sheet(isPresented: $showAdminSheet) {
                    AdminVerificationSheetView(navigateToNextScreen: $navigateToNextScreen, showAdminSheet: $showAdminSheet)
                }
                .padding()
            }
            .task {
                await viewModel.loadAllStudents()
            }
        }
    }
    func handleScan(result: Result<ScanResult, ScanError>) {
        showScanSheet = false

        switch result {
        case .success(let result):
            Task {
                do {
                    print("Scanned QR Code Text: \(result.string)")

                    if let student = viewModel.students.first(where: {
                        print("Checking student: \($0.first) \($0.last)")
                        print("Stored QR Text: \($0.qrCode)")
                        return $0.qrCode == result.string
                    }) {
                        print("Matched student: \(student.first) \(student.last)")
                        await viewModel.checkInOutStudent(student)
                    } else {
                        print("No student matched the scanned QR Code Text.")
                        throw CheckInError.studentNotFound
                    }

                    await viewModel.loadAllStudents()
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
}
#Preview {
    CheckInScreen()
        .environmentObject(ViewModel())
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

