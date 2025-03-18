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
    let isMale: Bool
    let cellNumber: String
    let email: String
    let cohort: Bool // True if M/W, False if T/Th
    let school: String
    let gradDate: String
    var qrCode: String
    var isCheckedIn: Bool = false
    // MARK: Later - put an image property
    
    // MARK: Put a Mentor property
    //    let mentor: String?
    
    func qrCodeImage() -> UIImage? {
          guard !qrCode.isEmpty else {
              print("QR Code is empty for:", first, last)
              return nil
          }
          
          guard let qrData = Data(base64Encoded: qrCode) else {
              print("Failed to decode Base64 QR Code for:", first, last)
              return nil
          }
          
          guard let qrImage = UIImage(data: qrData) else {
              print("Failed to convert QR Data to UIImage for:", first, last)
              return nil
          }
          
          
          let size = CGSize(width: 600, height: 600)  // Increase QR code size
          UIGraphicsBeginImageContextWithOptions(size, false, 2.0)
          qrImage.draw(in: CGRect(origin: .zero, size: size))
          let highResQRImage = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
          
          print("Successfully generated high-resolution QR Code for:", first, last)
          return highResQRImage
      }
}





