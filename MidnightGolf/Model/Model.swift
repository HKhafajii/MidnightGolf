//
//  Model.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 11/11/24.
//

import Foundation
import SwiftUI
struct Student: Identifiable, Codable, Hashable {
    let id: String
    let group: String
    let first: String
    let last: String
    let born: String
    let school: String
    let gradDate: String
    var qrCode: String
    var isCheckedIn: Bool = false
    
    func qrCodeImage() -> UIImage? {
        guard !qrCode.isEmpty else {
            print("QR Code is empty for student:", first, last)
            return nil
        }
        
        guard let qrData = Data(base64Encoded: qrCode) else {
            print("Failed to decode Base64 QR Code for student:", first, last)
            return nil
        }
        
        guard let qrImage = UIImage(data: qrData) else {
            print("❌ Failed to convert QR Data to UIImage for student:", first, last)
            return nil
        }
        
        print("Successfully loaded QR Code for:", first, last)
        return qrImage
    }
}


//extension Student {
//    func qrString() -> String? {
//        String(data: qrCode, encoding: .utf8)
//    }
//}


