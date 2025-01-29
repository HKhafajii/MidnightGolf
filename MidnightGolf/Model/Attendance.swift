//
//  Attendance.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 1/20/25.
//

import Foundation
import FirebaseFirestore

struct Attendance: Codable, Identifiable {
    var id: String
    let studentID: String
    @ServerTimestamp var timeIn: Date?
    @ServerTimestamp var timeOut: Date?
    var isCheckedIn: Bool
    var isLate: Bool
    var totalTime: Double
    
}
