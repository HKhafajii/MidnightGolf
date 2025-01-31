import SwiftUI
import Combine

class ViewModel: ObservableObject {
    @Published var firestoreManager = FirestoreManager()
    @Published var checkInManager = CheckInManager()
    @Published var attendanceManager = AttendanceManager()
    @Published var mailManager = MailManager()
    
    // Example: All students loaded from Firestore
    @Published var students: [Student] = []
    @Published var names: [String] = []
    
    init() {
        Task {
            await loadAllStudents()
        }
    }
    
    // MARK: - Public Functions
    
    /// Fetch all users from Firestore (via FirestoreManager).
    @MainActor
    func loadAllStudents() async {
        do {
            let fetched = try await firestoreManager.fetchAllUsers()
            self.students = fetched
        } catch {
            print("Failed to fetch users: \(error)")
        }
    }
    
    /// Toggling check-in/out for a single student.
    @MainActor
    func checkInOutStudent(_ student: Student) async {
        do {
            // 1. If the student is currently checked in, fetch any open attendance record
            let openAttendance = try await firestoreManager.fetchOpenAttendance(for: student.id)
            
            // 2. Use the CheckInManager to build or update the attendance object
            let (updatedAttendance, newIsCheckedIn) = try checkInManager.handleCheckInOut(for: student, openAttendance: openAttendance)
            
            // 3. If we are checking in, the record is new -> create it in Firestore
            //    If we are checking out, we update the existing record in Firestore
            if student.isCheckedIn {
                // Student was checked in, so we just "checked out" => update Firestore doc
                try await firestoreManager.updateAttendance(
                    updatedAttendance.id,
                    fields: [
                        "timeOut": updatedAttendance.timeOut ?? NSNull(),
                        "totalTime": updatedAttendance.totalTime,
                        "isCheckedIn": updatedAttendance.isCheckedIn
                    ]
                )
            } else {
                // Student was not checked in, so we just "checked in" => create new record in Firestore
                try await firestoreManager.createAttendance(updatedAttendance)
            }
            
            // 4. Update the student's `isCheckedIn` status in Firestore
            try await firestoreManager.updateStudentStatus(
                studentID: student.id,
                isCheckedIn: newIsCheckedIn
            )
            
            // 5. Update local state (optional: if you want to keep your local list in sync)
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
    
    func loadNames() {
        for student in students {
            names.append(student.first + " " + student.last)
        }
    } // end of getNames
    
}
