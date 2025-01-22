//
//  Attendance.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 1/20/25.
//

import Foundation

struct Attendance: Codable {
    
    let timeIn: Date?
    let timeOut: Date?
    let isCheckedIn: Bool?
    let isLate: Bool?
    let totalTime: Double?
    
}
