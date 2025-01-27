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
    
    @State private var attendanceRecords: [Attendance] = [
        Attendance(
            id: UUID().uuidString, studentID: "student123",
            timeIn: Date(),
            timeOut: Date().addingTimeInterval(3600),
            isCheckedIn: false,
            isLate: false,
            totalTime: 1.0
        )
    ]
    
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading attendance...")
            } else {
                List(attendanceRecords) { attendance in
                    VStack(alignment: .leading) {
                        
                        Text("Checked in: \(attendance.timeIn?.formatted() ?? "Not Checked In")")
                        Text("Checked out: \(attendance.timeOut?.formatted() ?? "Not Checked Out")")
                        Text("Late: \(attendance.isLate ? "Yes" : "No")")
                        Text("Total Time: \(attendance.totalTime, specifier: "%.2f") hours")
                        
                        
                    }// End of Vstack
                }// End of List
            }
            
            
        }// End of VStack
        .padding()
        .onAppear {
            fetchAttendance()
        }
    }
    func fetchAttendance() {
        isLoading = true
        
        Task {
            do {
                attendanceRecords = try await FirestoreManager.shared.fetchAttendance(for: student.id)
            } catch {
                
                print("Failed to fetch attendance: \(error.localizedDescription)")
            }
            isLoading = false
        }
    }
}

#Preview {
    AttendanceView(student: studentExample)
}
