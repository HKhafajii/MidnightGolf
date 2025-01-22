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
    
    let lateThreshold: [String: Date]
    
    init() {
        lateThreshold = [
            "Monday": CheckInManager.createTime(hour: 9, minute: 0),
            "Wednesday": CheckInManager.createTime(hour: 9, minute: 0),
            "Tuesday": CheckInManager.createTime(hour: 9, minute: 0),
            "Thursday": CheckInManager.createTime(hour: 9, minute: 0)
        ]
        
    }
    
//    TODO: This functionality needs to be looked at better, somewhere along the lines where we reference and return attendance objects I don't feel as though this should work properly.
    
    
    
    
    static func createTime(hour: Int, minute: Int) -> Date {
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components)!
    }
    
    @Published var isCheckedIn: Bool = false
    
    func checkIn(for student: String, at time: Date) -> Attendance? {
        
        guard isValidClockInDay(for: student) else {
               print("Not a valid clock-in day")
               return nil
           }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let today = formatter.string(from: Date())
        
        let isLate = isLate(for: today, at: time)
        return Attendance(timeIn: time, timeOut: nil, isCheckedIn: true, isLate: isLate, totalTime: 0)
    }
    
    func isLate(for day: String, at time: Date) -> Bool {
        guard let threshold = lateThreshold[day] else { return false }
        
        return time > threshold
    }
    
    func isValidClockInDay(for user: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let today = dateFormatter.string(from: Date())
        
        guard let allowedDays = validClockInDays[user] else { return false }
        return allowedDays.contains(today)
    }
    
    
    
    // When someone scans a qr code, it checks the user whos qr code it was in
    
    
    
    // Changes a bool that starts a timer to keep track of the time
    
    // OR
    
    // Takes the time they check in and takes the time they checkout and subtracts it from eachother to get the total amount of time clocked in
    
    // Checks if they're late or not
    
    // Checks if they clock out early
    
    
    
}
