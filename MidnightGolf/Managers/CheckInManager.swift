//
//  CheckIn.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 1/17/25.
//

import Foundation
import FirebaseFirestore

enum CheckInError: Error {
    case alreadyCheckedIn, invalidClockInDay, notCheckedIn,missingTimeIn, noOpenAttendance, studentNotFound
}

class CheckInManager: ObservableObject {
    private let lateThresholdHour = 9 // 9 AM
    

    @MainActor
    func handleCheckInOut(for student: Student) async throws {
        let isCurrentlyCheckedIn = student.isCheckedIn

        if isCurrentlyCheckedIn {
            print("Checking out student: \(student.first) \(student.last)")
            try await handleCheckOut(student: student)
        } else {
            print("Checking in student: \(student.first) \(student.last)")
            try await handleCheckIn(student: student)
        }
    }

    private func handleCheckIn(student: Student) async throws {
        let attendanceRef = firestoreManager.db.collection("attendance").document()
        let checkInDate = Date()

        let attendance = Attendance(
            id: attendanceRef.documentID,
            studentID: student.id,
            timeIn: checkInDate,
            timeOut: nil,
            isCheckedIn: true,
            isLate: isLate(checkInDate: checkInDate),
            totalTime: 0
        )

        try attendanceRef.setData(from: attendance)
        try await updateStudentStatus(studentID: student.id, isCheckedIn: true)
        print("Checked in: \(student.first) \(student.last)")
    }

    private func handleCheckOut(student: Student) async throws {
        guard let openAttendance = try await getOpenAttendance(studentID: student.id),
              let timeIn = openAttendance.timeIn else {
            throw CheckInError.noOpenAttendance
        }

        let checkOutDate = Date()
        let totalTime = checkOutDate.timeIntervalSince(timeIn) / 3600

        try await firestoreManager.db.collection("attendance").document(openAttendance.id).updateData([
            "timeOut": checkOutDate,
            "totalTime": totalTime
        ])

        try await updateStudentStatus(studentID: student.id, isCheckedIn: false)
    }

    private func updateStudentStatus(studentID: String, isCheckedIn: Bool) async throws {
        try await firestoreManager.db.collection("users").document(studentID).updateData([
            "isCheckedIn": isCheckedIn
        ])
    }

    private func isLate(checkInDate: Date) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: checkInDate)
        return components.hour! > lateThresholdHour ||
              (components.hour! == lateThresholdHour && components.minute! > 0)
    }

    private func getOpenAttendance(studentID: String) async throws -> Attendance? {
        let snapshot = try await firestoreManager.db.collection("attendance")
            .whereField("studentID", isEqualTo: studentID)
            .whereField("timeOut", isEqualTo: NSNull())
            .limit(to: 1)
            .getDocuments()

        return snapshot.documents.compactMap { try? $0.data(as: Attendance.self) }.first
    }
}
