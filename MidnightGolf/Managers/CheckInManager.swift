//
//  CheckIn.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 1/17/25.
//

import Foundation

class CheckInManager: ObservableObject {
    
    let timer = TimerManager()
    
    let validClockInDays: [String: [String]] = [
        "Mon/Wed" : ["Monday", "Wednesday"],
        "Tue/Thu" : ["Tuesday", "Thursday"]
    ]
    
    let userGroups: [String: String] = [
        "StudentA": "Mon/Wed",
        "StudentB": "Tue/Wed"
    ]
    
    let lateThreshold: [String: Date]  = [
        "Monday": CheckInManager.createTime(hour: 9, minute: 0),
        "Wednesday": CheckInManager.createTime(hour: 9, minute: 0),
        "Tuesday": CheckInManager.createTime(hour: 9, minute: 0),
        "Thursday": CheckInManager.createTime(hour: 9, minute: 0)
    ]
    
    init() {
        
    }
    
//    TODO: This functionality needs to be looked at better, somewhere along the lines where we reference and return attendance objects I don't feel as though this should work properly.
    
    
    enum CheckInError: Error {
        case alreadyCheckedIn, invalidClockInDay, notCheckedIn,missingTimeIn
    }
    
    
    static func createTime(hour: Int, minute: Int) -> Date {
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components) ?? Date()
    }
    
    @Published var isCheckedIn: Bool = false
    
    func checkIn(for student: String, at time: Date) throws -> Attendance? {
        
        guard !isCheckedIn else {
            throw CheckInError.alreadyCheckedIn
        }
        
        guard isValidClockInDay(for: student) else {
            throw CheckInError.invalidClockInDay
           }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let today = formatter.string(from: Date())
        
        let isLate = isLate(for: today, at: time)
//        TODO: Fix this
        return Attendance(studentID: "chicken", timeIn: time, timeOut: nil, isCheckedIn: true, isLate: isLate, totalTime: 0)
    }
    
    func checkOut(for attendance: inout Attendance, at time: Date) {
        guard attendance.isCheckedIn, let timeIn = attendance.timeIn else {
            print("Cannot check out: not checked in or missing timeIn")
            return
        }
        
        attendance.timeOut = time
        attendance.isCheckedIn = false
        if let timeIn = attendance.timeIn {
            let elapsedTime = time.timeIntervalSince(timeIn) / 3600.0
            attendance.totalTime = elapsedTime
        }
    }
    
    func isLate(for day: String, at time: Date) -> Bool {
        guard let threshold = lateThreshold[day] else { return false }
        
        return time >= threshold
    }
    
    func isValidClockInDay(for user: String) -> Bool {
        
        guard let group = userGroups[user],
              let allowedDays = validClockInDays[group] else { return false}
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let today = dateFormatter.string(from: Date())
        
        return allowedDays.contains(today)
        
    }
    
    
    
    // When someone scans a qr code, it checks the user whos qr code it was in
    
    
    
    // Changes a bool that starts a timer to keep track of the time
    
    // OR
    
    // Takes the time they check in and takes the time they checkout and subtracts it from eachother to get the total amount of time clocked in
    
    // Checks if they're late or not
    
    // Checks if they clock out early
    
    
    
}
