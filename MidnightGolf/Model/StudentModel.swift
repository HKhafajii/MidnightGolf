//
//  Model.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 11/11/24.
//

import Foundation
import SwiftUI

/* Student:
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
 var mentor: String
        

 */



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
              return nil
          }
          
          guard let qrData = Data(base64Encoded: qrCode) else {
              return nil
          }
          
          guard let qrImage = UIImage(data: qrData) else {
              return nil
          }
          
          
          let size = CGSize(width: 600, height: 600)  
          UIGraphicsBeginImageContextWithOptions(size, false, 2.0)
          qrImage.draw(in: CGRect(origin: .zero, size: size))
          let highResQRImage = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
          
          
          return highResQRImage
      }
}





