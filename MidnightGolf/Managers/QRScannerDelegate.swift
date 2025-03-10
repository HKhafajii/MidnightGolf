//
//  File.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 12/16/24.
//

import SwiftUI
import AVKit

// TODO: Make sure to fix this or use the scanner 
class QRScannerDelegate: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metaObject = metadataObjects.first {
            guard let readableObject = metaObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let scannedCode = readableObject.stringValue else { return }
            print(scannedCode)
            
        }
    }
}
