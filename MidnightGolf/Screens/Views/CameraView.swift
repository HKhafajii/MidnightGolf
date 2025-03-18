//
//  CameraView.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 12/16/24.
//

import SwiftUI
import AVKit

struct CameraView: UIViewRepresentable {
    
    var frameSize: CGSize
    @Binding var session: AVCaptureSession
    
    
    func makeUIView(context: Context) ->  UIView {
        let view = UIView(frame: CGRect(origin: .zero, size: frameSize))
        view.backgroundColor = .clear
        
        let cameraLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraLayer.frame = .init(origin: .zero, size: frameSize)
        cameraLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(cameraLayer)
        return view
    }
    
    
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}


