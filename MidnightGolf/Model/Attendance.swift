//
//  Attendance.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 1/20/25.
//

import Foundation

struct Attendance: Codable {
    let studentID: String
    let timeIn: Date?
    var timeOut: Date?
    var isCheckedIn: Bool
    var isLate: Bool
    var totalTime: Double
    
}
