import SwiftUI
import Combine

class ViewModel: ObservableObject {
    @Published var firestoreManager = FirestoreManager()
    @Published var checkInManager = CheckInManager()
    @Published var attendanceManager = AttendanceManager()
    @Published var mailManager = MailManager()
    
    @Published var students: [Student] = []
    @Published var names: [String] = []
    
    init() {
        Task {
            await loadAllStudents()
        }
    }
    
    
    @MainActor
    func loadAllStudents() async {
        do {
            let fetched = try await firestoreManager.fetchAllUsers()
            self.students = fetched
            self.names = fetched.map { $0.first + " " + $0.last }
        } catch {
            print("Failed to fetch users: \(error)")
        }
    }
    
    
    @MainActor
    func checkInOutStudent(_ student: Student) async {
        do {
            
            let openAttendance = try await firestoreManager.fetchOpenAttendance(for: student.id)
            
            
            let (updatedAttendance, newIsCheckedIn) = try checkInManager.handleCheckInOut(for: student, openAttendance: openAttendance)
            
            
            
            if student.isCheckedIn {
                
                try await firestoreManager.updateAttendance(
                    updatedAttendance.id,
                    fields: [
                        "timeOut": updatedAttendance.timeOut ?? NSNull(),
                        "totalTime": updatedAttendance.totalTime,
                        "isCheckedIn": updatedAttendance.isCheckedIn
                    ]
                )
            } else {
                
                try await firestoreManager.createAttendance(updatedAttendance)
            }
            
            
            try await firestoreManager.updateStudentStatus(
                studentID: student.id,
                isCheckedIn: newIsCheckedIn
            )
            
            
            if let index = students.firstIndex(where: { $0.id == student.id }) {
                var updatedStudent = students[index]
                updatedStudent.isCheckedIn = newIsCheckedIn
                students[index] = updatedStudent
            }
            
        } catch {
            print("Error checking in/out: \(error.localizedDescription)")
        }
    }
    
    
    func loadAttendance(for student: Student) async {
        attendanceManager.isLoading = true
        attendanceManager.errorMessage = nil
        
        defer { attendanceManager.isLoading = false }
        
        do {
            let history = try await firestoreManager.getAttendanceHistory(studentID: student.id)
            attendanceManager.attendanceHistory = history
        } catch {
            attendanceManager.errorMessage = "Failed to load attendance: \(error.localizedDescription)"
        }
    }
    
}
