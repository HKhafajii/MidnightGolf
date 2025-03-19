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
    @ServerTimestamp var timeIn: Date? = nil
    var timeOut: Date? = nil
    var isCheckedIn: Bool = false
    var isLate: Bool = false
    var totalTime: Double = 0
}
