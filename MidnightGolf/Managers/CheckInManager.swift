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
    private let lateThresholdHour = 9 // 9 AM
    
    func handleCheckInOut(for student: Student, openAttendance: Attendance?) throws -> (Attendance, Bool) {
           
           if student.isCheckedIn {
               // Student is currently checked in, so we need to check them out.
               return try handleCheckOut(openAttendance: openAttendance)
           } else {
               // Student is currently checked out, so we need to check them in.
               return handleCheckIn(student: student)
           }
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
           } else if hour == lateThresholdHour && minute > 0 {
               return true
           } else {
               return false
           }
       }
   }
