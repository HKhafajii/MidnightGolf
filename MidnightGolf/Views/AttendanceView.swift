//
//  AttendanceView.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 1/27/25.
//

import SwiftUI

let studentExample = Student(id: UUID().uuidString, group: "Student A", first: "Hassan", last: "Alkhafaji", born: "2002", school: "melvindale", gradDate: "2020", qrCode: Data())

struct AttendanceView: View {
    let student: Student
    @State private var attendanceHistory: [Attendance] = []
    
    var body: some View {
        List(attendanceHistory) { attendance in
            VStack(alignment: .leading) {
                Text("Checked in: \(attendance.timeIn?.formatted() ?? "N/A")")
                Text(attendance.timeOut != nil ?
                     "Checked out: \(attendance.timeOut!.formatted())" :
                     "Currently checked in")
                Text("Late arrival: \(attendance.isLate ? "Yes" : "No")")
                Text("Total time: \(attendance.totalTime, specifier: "%.2f") hours")
            }
        }
        .task {
            do {
                attendanceHistory = try await FirestoreManager.shared.getAttendanceHistory(studentID: student.id)
            } catch {
                print("Error loading attendance: \(error)")
            }
        }
    }
}

#Preview {
    AttendanceView(student: studentExample)
}
