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
    @State private var showScanAlert: Bool = false
    @State private var scanAlertMessage: String = ""
    @State private var navigateToNextScreen = false
    @State var isAnimating: Bool = false
    @State var animateLogo = false
    
    private var xAxis: CGFloat = 1.0
    private var zAxis: CGFloat = 1.0
    
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
                
                Image("logo")
                    .resizable()
                    .frame(
                        maxWidth: CheckInScreen.deviceWidth / 4,
                        maxHeight: CheckInScreen.deviceHeight / 3
                    )
                    .shadow(radius: 8, x: 0, y: 8)
                    .offset(y: -100)

                VStack(spacing: 25) {
                    HStack {
                        
                        TimeView(viewModel: timerManager)
                        
                        Button {
                            showAdminSheet = true
                        } label: {
                            Image(systemName: "person.badge.key.fill")
                                .resizable()
                                .frame(maxWidth: 45, maxHeight: 40)
                                .foregroundStyle(Color("MGPnavy"))
                                .shadow(radius: 10, x: 0, y: 5)
                        }
                    }
                    
                    Spacer()
                    
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
                                    .font(.custom("NeueMontreal-Regular", size: CheckInScreen.deviceWidth * 0.02))
                                    .shadow(radius: 12, x: 0, y: 8)
                            }
                            .padding()
                            .padding(.trailing, 20)
                        }
                        .frame(maxWidth: CheckInScreen.deviceWidth / 1.5)
                    }
                    
                    Button("Scan", systemImage: "qrcode.viewfinder") { showScanSheet = true }
                        .disabled(viewModel.firestoreManager.isLoadingStudents)
                        .font(.largeTitle)
                        .foregroundStyle(Color("MGPnavy"))
                        .fontWeight(.semibold)
                        .frame(maxWidth: CheckInScreen.deviceWidth / 5)
                        .shadow(radius: 12, x: 0, y: 5)
                        .sheet(isPresented: $showScanSheet) {
                            VStack {
                                CodeScannerView(codeTypes: [.qr], simulatedData: "Hassan alkhafaji\nalkhafajihassan@gmail.com", completion: handleScan)
                            }
                            .alert("Scan Result", isPresented: $showScanAlert) {
                                Button("OK", role: .cancel) {
                                    showScanSheet = false
                                }
                            } message: {
                                Text(scanAlertMessage)
                            }
                        }
                    
                    NavigationLink(destination: AdminScreen()
                        .environmentObject(viewModel), isActive: $navigateToNextScreen) {
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
            .onAppear {
                            animateLogo = true
                        }
        }
        .tint(Color("MGPnavy"))
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let result):
            Task {
                let scannedText = result.string.trimmingCharacters(in: .whitespacesAndNewlines)
                print("Scanned QR Code Text:", scannedText)
                
                if let qrCodeImage = QRCodeManager().generateQRCode(from: scannedText),
                   let qrCodeData = qrCodeImage.pngData() {
                    
                    let scannedBase64 = qrCodeData.base64EncodedString()
                    print("Scanned QR Code Base64:", scannedBase64.prefix(20), "...")
                    
                    if let student = viewModel.students.first(where: { $0.qrCode == scannedBase64 }) {
                        print("Matched student:", student.first, student.last)
                        await viewModel.checkInOutStudent(student)
                        DispatchQueue.main.async {
                            scanAlertMessage = "Checked in \(student.first) \(student.last)!"
                            showScanAlert = true
                        }
                    } else {
                        print("No student matched the scanned QR Code.")
                        DispatchQueue.main.async {
                            scanAlertMessage = "No student matched the scanned QR Code"
                            showScanAlert = true
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        scanAlertMessage = "Invalid QR Code data."
                        showScanAlert = true
                    }
                }
                await viewModel.loadAllStudents()
            }
        case .failure(let error):
            DispatchQueue.main.async {
                scanAlertMessage = "Scanning failed: \(error.localizedDescription)"
                showScanAlert = true
            }
        }
    } // End of HandScan
    
}
#Preview {
    CheckInScreen()
        .environmentObject(ViewModel())
}


struct TimeView: View {

    @ObservedObject var viewModel: TimerManager
    
    var body: some View {
        Text(viewModel.currentTime)
            .font(.custom("NeueMontreal-Regular", size: CheckInScreen.deviceWidth * 0.03))
            .foregroundStyle(Color("MGPnavy"))
            .fontWeight(.semibold)
            .frame(maxWidth: CheckInScreen.deviceWidth / 1.5)
            .padding()
            .shadow(radius: 16, x: 0, y: 5)
    }
}

