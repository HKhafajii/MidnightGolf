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
    
    @State private var showConfirmationSheet = false
    @State private var checkInMessage = ("", false)
    
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
                    
                    Text("Check In")
                        .font(.custom("NeueMontreal-Regular", size: CheckInScreen.deviceWidth * 0.03))
                        .shadow(radius: 16, x: 0, y: 5)
                        .fontWeight(.bold)
                        .foregroundStyle(Color("MGPnavy"))
                    
                    
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
                            CodeScannerView(codeTypes: [.qr], simulatedData: "Hassan alkhafaji\nalkhafajihassan@gmail.com", completion: handleScan)
                        }
                    
                    NavigationLink(destination: AdminTest().environmentObject(viewModel), isActive: $navigateToNextScreen) {
                        EmptyView()
                    }
                }
                .sheet(isPresented: $showAdminSheet) {
                    AdminVerificationSheetView(navigateToNextScreen: $navigateToNextScreen, showAdminSheet: $showAdminSheet)
                }
                .sheet(isPresented: $showConfirmationSheet) {
                    CheckInResultSheet(message: checkInMessage.0, result: checkInMessage.1)
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
                    let scannedText = result.string.trimmingCharacters(in: .whitespacesAndNewlines)
                    print("Scanned QR Code Text:", scannedText)

                    guard let qrCodeImage = QRCodeManager().generateQRCode(from: scannedText),
                          let qrCodeData = qrCodeImage.pngData() else {
                        throw CheckInError.invalidQRCode
                    }
                    
                    let scannedBase64 = qrCodeData.base64EncodedString()
                    print("Scanned QR Code Base64:", scannedBase64.prefix(20), "...")

                    guard let student = viewModel.students.first(where: { $0.qrCode == scannedBase64 }) else {
                        throw CheckInError.studentNotFound
                    }

                    print("✅ Matched student:", student.first, student.last)
                    await viewModel.checkInOutStudent(student)

                    checkInMessage = ("✅ Welcome, \(student.first) \(student.last)!", true)
                    showConfirmationSheet = true

                    await viewModel.loadAllStudents()
                
                } catch CheckInError.studentNotFound {
                    print("❌ No student matched the scanned QR Code.")
                    checkInMessage = ("Student not found. Please try again.", false)
                    showConfirmationSheet = true

                } catch CheckInError.invalidQRCode {
                    print("❌ Invalid QR code.")
                    checkInMessage = ("Invalid QR code. Please try again.", false)
                    showConfirmationSheet = true

                } catch {
                    print("❌ Unexpected Error: \(error.localizedDescription)")
                    checkInMessage = ("An error occurred. Please try again.", false)
                    showConfirmationSheet = true
                }
            }
        case .failure(let error):
            print("❌ Scanning failed: \(error.localizedDescription)")
            checkInMessage = ("Scanning failed. Please try again.", false)
            showConfirmationSheet = true
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
            .font(.custom("NeueMontreal-Regular", size: CheckInScreen.deviceWidth * 0.03))
            .foregroundStyle(Color("MGPnavy"))
            .fontWeight(.semibold)
            .frame(maxWidth: CheckInScreen.deviceWidth / 1.5)
            .padding()
            .shadow(radius: 16, x: 0, y: 5)
    }
}

