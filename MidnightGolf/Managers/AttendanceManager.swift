//
//  AttendanceManager.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 1/30/25.
//


import SwiftUI

class AttendanceManager: ObservableObject {
    @Published var attendanceHistory: [Attendance] = []
    @Published var errorMessage: String?
    @Published var isLoading = false    
  
    func filterCheckInToday(attendanceList: [Attendance]) -> [Attendance] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return attendanceList.filter { record in
            guard let timeIn = record.timeIn else { return false }
            return calendar.isDate(timeIn, inSameDayAs: today)
        }
    } // End of filterCheckInToday
    
    func filterCheckInTardies(attendanceList: [Attendance]) -> [Attendance] {
        attendanceList.filter { $0.isLate }
    } // End of filterCheckInToday
    
    fileprivate func requiredWeekdays(for student: Student) -> Set<Int> {
        student.cohort ? [2, 4] : [3, 5]           // M/W  or  T/Th
    }


    fileprivate func isRequired(_ date: Date, for student: Student) -> Bool {
        requiredWeekdays(for: student)
            .contains(Calendar.current.component(.weekday, from: date))
    }


    func absences(for student: Student,
                  attendanceList: [Attendance],
                  from start: Date,
                  through end: Date = Date()) -> [Date] {

        let cal = Calendar.current
        let checkInDays: Set<Date> = Set(
            attendanceList.compactMap { $0.timeIn }
                          .map { cal.startOfDay(for: $0) }
        )

        var cursor = cal.startOfDay(for: start)
        let last   = cal.startOfDay(for: end)
        var misses: [Date] = []

        while cursor <= last {
            if isRequired(cursor, for: student)
               && !checkInDays.contains(cursor) {
                misses.append(cursor)
            }
            cursor = cal.date(byAdding: .day, value: 1, to: cursor)!
        }
        return misses
    }



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
