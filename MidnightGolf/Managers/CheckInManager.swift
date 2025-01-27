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
    
    func checkIn(for student: Student, at time: Date) async throws -> Attendance? {
        
        guard !isCheckedIn else { throw CheckInError.alreadyCheckedIn }
        guard isValidClockInDay(for: student) else { throw CheckInError.invalidClockInDay }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let today = formatter.string(from: Date())
        let isLate = isLate(for: today, at: time)

        
        let attendance = Attendance(
            id: UUID().uuidString, studentID: student.id,
            timeIn: time,
            timeOut: nil,
            isCheckedIn: true,
            isLate: isLate,
            totalTime: 0)
        
        try await FirestoreManager.shared.postAttendance(attendance)
        isCheckedIn = true
        return attendance
    }
    
    func checkOut(for attendance: inout Attendance, at time: Date) async throws {
        guard attendance.isCheckedIn, let timeIn = attendance.timeIn else {
            throw CheckInError.notCheckedIn
        }
        
        attendance.timeOut = time
        attendance.isCheckedIn = false
        attendance.totalTime = time.timeIntervalSince(timeIn) / 3600.0
        
        try await FirestoreManager.shared.postAttendance(attendance)
        isCheckedIn = false
        
    }
    
    func isLate(for day: String, at time: Date) -> Bool {
        guard let threshold = lateThreshold[day] else { return false }
        
        return time >= threshold
    }
    
    func isValidClockInDay(for student: Student) -> Bool {
        
        guard let group = userGroups[student.group],
              let allowedDays = validClockInDays[group] else { return false}
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let today = dateFormatter.string(from: Date())
        
        return allowedDays.contains(today)
        
    }
    
    func handleCheckInorOut(for student: Student) {
        Task {
            do {
                let attendance = try await checkIn(for: student, at: Date())
                print("Check in successful for \(student.first)")
                
            } catch {
                print("Check in failed: \(error.localizedDescription)")
            }
        }
    }
    
}
