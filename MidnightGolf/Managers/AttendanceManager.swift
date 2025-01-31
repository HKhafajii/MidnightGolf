//
//  AttendanceManager.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 1/30/25.
//


import Foundation

class AttendanceManager: ObservableObject {
    @Published var attendanceHistory: [Attendance] = []
    @Published var errorMessage: String?
    @Published var isLoading = false    
  
    
    func updateAttendanceHistory(_ history: [Attendance]) {
           self.attendanceHistory = history
       }
    
}
