//
//  CheckIn.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 1/17/25.
//

import Foundation


enum CheckInError: Error {
    case alreadyCheckedIn, invalidClockInDay, notCheckedIn,missingTimeIn, noOpenAttendance, studentNotFound
}

class CheckInManager: ObservableObject {
    var lateThresholdHour = 17
    var lateThresholdMinute = 30
    
    @Published var absences: [Attendance] = []
    @Published var tardies: [Attendance] = []
    
    
    func handleCheckInOut(for student: Student, openAttendance: Attendance?) throws -> (Attendance, Bool) {
        
        if let openAttendance = openAttendance {
            return try handleCheckOut(openAttendance: openAttendance)
        } else {
            return handleCheckIn(student: student)
        }
        
    }
    func setLateThreshold(hour: Int, minute: Int) {
        lateThresholdMinute = minute
        lateThresholdHour = hour
    }
    
    func studentIsRequiredToday(_ student: Student, on date: Date = Date()) -> Bool {
        let weekday = Calendar.current.component(.weekday, from: date)   
        switch student.cohort {
        case true:   return weekday == 2 || weekday == 4      // M / W
        case false:  return weekday == 3 || weekday == 5      // T / Th
        }
    }

  
    private let sessionEndHour   = 19
    private let sessionEndMinute = 30

    func dayIsOver(for date: Date = Date()) -> Bool {
        let c = Calendar.current.dateComponents([.hour, .minute], from: date)
        guard let h = c.hour, let m = c.minute else { return false }
        return h > sessionEndHour || (h == sessionEndHour && m >= sessionEndMinute)
    }
    
    
    private func handleCheckIn(student: Student) -> (Attendance, Bool) {
        
        
        let newAttendance = Attendance(
            id: UUID().uuidString,
            studentID: student.id,
            timeIn: Date(),
            timeOut: nil,
            isCheckedIn: true,
            isLate: isLate(checkInDate: Date()),
            totalTime: 0
        )
        
        
        return (newAttendance, true)
    }
    
    
    private func handleCheckOut(openAttendance: Attendance?) throws -> (Attendance, Bool) {
        guard let openAttendance = openAttendance,
              let timeIn = openAttendance.timeIn else {
            throw CheckInError.noOpenAttendance
        }
        
        var updatedAttendance = openAttendance
        let checkOutDate = Date()
        let totalTime = checkOutDate.timeIntervalSince(timeIn) / 3600
        
        updatedAttendance.timeOut = checkOutDate
        updatedAttendance.totalTime = totalTime
        updatedAttendance.isCheckedIn = false
        
        return (updatedAttendance, false)
    }
    
    
    private func isLate(checkInDate: Date) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: checkInDate)
        
        guard let hour = components.hour,
              let minute = components.minute else {
            return false
        }
        
        if hour > lateThresholdHour {
            return true
        } else if hour == lateThresholdHour && minute > lateThresholdMinute {
            return true
        } else {
            return false
        }
    } // End of isLate
    

    
}
