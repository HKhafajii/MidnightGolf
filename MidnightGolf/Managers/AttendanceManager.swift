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
    
    func filterCheckInToday(attendanceList: [Attendance]) -> [Attendance] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return attendanceList.filter { record in
            guard let timeIn = record.timeIn else { return false }
            return calendar.isDate(timeIn, inSameDayAs: today)
        }
    } // End of filterCheckInToday
    
    func filterCheckInWeek(attendanceList: [Attendance]) -> [Attendance] {
        let calendar = Calendar.current
        let today = Date()
        
        return attendanceList.filter { record in
            guard let timeIn = record.timeIn else { return false }
            return calendar.isDate(timeIn, equalTo: today, toGranularity: .weekOfYear)
        }
    } // End of filterCheckInWeek
    
    func filterCheckInMonth(attendanceList: [Attendance]) -> [Attendance] {
        let calendar = Calendar.current
        let today = Date()
        
        return attendanceList.filter { record in
            guard let timeIn = record.timeIn else { return false }
            return calendar.isDate(timeIn, equalTo: today, toGranularity: .month)
        }
    } // End of filterCheckInMonth
    
}
