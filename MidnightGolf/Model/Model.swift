//
//  Model.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 11/11/24.
//

import Foundation
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
}

//extension Student {
//    func qrString() -> String? {
//        String(data: qrCode, encoding: .utf8)
//    }
//}


