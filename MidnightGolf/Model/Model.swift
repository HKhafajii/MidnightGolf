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
        if let qrData = Data(base64Encoded: qrCode) {
               return UIImage(data: qrData)
           }
           return nil
       }
}


//extension Student {
//    func qrString() -> String? {
//        String(data: qrCode, encoding: .utf8)
//    }
//}


