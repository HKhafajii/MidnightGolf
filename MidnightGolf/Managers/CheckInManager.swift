//
//  CheckIn.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 1/17/25.
//

import Foundation


enum CheckInError: Error {
    case alreadyCheckedIn, invalidClockInDay, invalidQRCode, notCheckedIn,missingTimeIn, noOpenAttendance, studentNotFound
}

class CheckInManager: ObservableObject {
     var lateThresholdHour = 17
     var lateThresholdMinute = 30
    
    func handleCheckInOut(for student: Student, openAttendance: Attendance?) throws -> (Attendance, Bool) {
           
        if let openAttendance = openAttendance {
            return try handleCheckOut(openAttendance: openAttendance)
        } else {
            return handleCheckIn(student: student)
        }
        
        
//           if student.isCheckedIn {
//               return try handleCheckOut(openAttendance: openAttendance)
//           } else {
//               return handleCheckIn(student: student)
//           }
       }
       
    
       private func handleCheckIn(student: Student) -> (Attendance, Bool) {
        
           
           let newAttendance = Attendance(
               id: UUID().uuidString, // You can override later with Firestore docID if needed
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
       }
   }
