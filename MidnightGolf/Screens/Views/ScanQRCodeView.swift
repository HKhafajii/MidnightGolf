//
//  ScanQRCodeView.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 12/15/24.
//

import SwiftUI
import AVKit

struct ScanQRCodeView: View {
    
    @State private var isScanning = false
    @State private var session: AVCaptureSession = .init()
    
    @State private var qrOutPut: AVCaptureMetadataOutput = .init()
    
    @State private var errorMessage: String = ""
    @State private var showError = false
    @State private var cameraPermission: Permission = .idle
    
    @Environment(\.openURL) private var openURL
    @StateObject private var qrDelegate = QRScannerDelegate()
    
    var body: some View {
        
        ZStack {
            
            Image("bg")
                .resizable()
                .scaledToFill()
            
            VStack(spacing: 8) {
                
                Button {
                    
                } label: {
                    Image(systemName: "xmark")
                        .font(.title)
                        .foregroundColor(.red)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Place the QR code inside the area")
                    .font(.title3)
                    .padding(.top, 20)
                
                Text("Scanning will start automatically")
                    .font(.title3)
                    .foregroundStyle(.gray)
                
                Spacer(minLength: 0)
                
                // SCANNER
                GeometryReader { geo in
                    let size = min(geo.size.width, geo.size.height)
                    let size2 = geo.size
                    
                    ZStack {
                        
                        CameraView(frameSize: size2, session: $session)
                        
                        ForEach(0...3, id: \.self) { index in
                            let rotation = Double(index) * 90
                            
                            RoundedRectangle(cornerRadius: 2, style: .circular)
                                .trim(from: 0.6, to: 0.65)
                                .stroke(.black, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                .rotationEffect(.degrees(rotation))
                        }
                    }
                    .frame(width: size, height: size)
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                    //                .overlay(alignment: .bottom, content: {
                    //                    Rectangle()
                    //                        .fill(Color.black)
                    //                        .frame(height: 2.5)
                    //                        .shadow(color: .black.opacity(0.8), radius: 8, x: 0, y: 15)
                    //                        .offset(y: isScanning ? CGFloat(size2.width) : 0)
                    //                        .frame(width: size, height: size)
                    //                })
                }
                .frame(height: 300)
                .padding(.horizontal, 45)
                
                
                Spacer(minLength: 15)
                
                Button {
                    
                } label: {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.largeTitle)
                        .foregroundStyle(.gray)
                }
                
                Spacer(minLength: 45)
                
                
                
            }
            .padding()
            .onAppear(perform: checkCameraPermission)
            .alert(errorMessage, isPresented: $showError) {
                if cameraPermission == .denied {
                    Button("Settings") {
                        let settingsStrings = UIApplication.openSettingsURLString
                        if let settingsURL = URL(string: settingsStrings) {
                            openURL(settingsURL)
                        }
                    }
                    
                    
                    Button("Cancel", role: .cancel) {}
                    
                }
            }
        }
    }
    
    
    func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                cameraPermission = .approved
            case .notDetermined:
                if await AVCaptureDevice.requestAccess(for: .video) {
                    cameraPermission = .approved
                } else {
                    cameraPermission = .denied
                    presentError("Please Provide Access to Camera for Scanning Codes")
                }
            case .denied, .restricted:
                cameraPermission = .denied
                presentError("Please Provide Access to Camera for Scanning Codes")
            default: break
            }
        }
    }
    
    func setupCamera() {
        
        do {
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
                presentError("Unknown error")
                return
            }
            
            let input = try AVCaptureDeviceInput(device: device)
            
            guard session.canAddInput(input), session.canAddOutput(qrOutPut) else {
                presentError("Unknown reason")
                return
            }
            
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(qrOutPut)
            qrOutPut.metadataObjectTypes = [.qr]
            qrOutPut.setMetadataObjectsDelegate(qrDelegate, queue: .main)
            session.commitConfiguration()
            DispatchQueue.global(qos: .background).async {
                session.startRunning()
            }
            
            
        } catch {
            presentError(error.localizedDescription)
        }
        
    }
    
    func presentError(_ message: String) {
        errorMessage = message
        showError.toggle()
    }
    
    
    
}

#Preview {
    ScanQRCodeView()
}
