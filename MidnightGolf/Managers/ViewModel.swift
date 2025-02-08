import SwiftUI


class ViewModel: ObservableObject {
    @Published var firestoreManager = FirestoreManager()
    @Published var checkInManager = CheckInManager()
    @Published var attendanceManager = AttendanceManager()
    @Published var mailManager = MailManager()
    @Published var qrManager = QRCodeManager()
    
    @Published var students: [Student] = []
    @Published var attendance: [Attendance] = []
    @Published var names: [String] = []
    
    init() {
        Task {
            await loadAllStudents()
            await loadAllAttendance()
            
        }
    }
    
//    @MainActor
//      func getAttendanceHistory(studentID: String) async throws -> [Attendance] {
//          
//          let snapshot = try await db.collection("attendance")
//              .whereField("studentID", isEqualTo: studentID)
//              .order(by: "timeIn", descending: true)
//              .getDocuments()
//          
//          return try snapshot.documents.map { document in
//              return try document.data(as: Attendance.self)
//          }
//          
//      } // End of getAttendanceHistory()
    
    
    func getAttendanceHistory(studentID: String) -> [Attendance] {
        var tempAttendance: [Attendance] = []
        for attendance in self.attendance {
            if attendance.studentID == studentID {
                tempAttendance.append(attendance)
            }
        }
        return tempAttendance
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
    func loadAllAttendance() async {
        do {
            let fetched = try await firestoreManager.fetchAllAttendance()
            self.attendance = fetched
        } catch {
            print("Failed to fetch users: \(error)")
        }
    } // End of loadAllAttendance
    
    @MainActor
    func checkInOutStudent(_ student: Student) async {
        do {
            print("Starting checkInOutStudent for student ID:", student.id)

            let openAttendance = try await firestoreManager.fetchOpenAttendance(for: student.id)
            print("Fetched open attendance:", openAttendance?.id ?? "None found")

            if let existingAttendance = openAttendance {
                
                print("Checking out, updating existing attendance record:", existingAttendance.id)

                let checkOutDate = Date()
                let totalTime = checkOutDate.timeIntervalSince(existingAttendance.timeIn ?? checkOutDate) / 3600

                let updatedFields: [String: Any] = [
                    "timeOut": checkOutDate,
                    "totalTime": totalTime,
                    "isCheckedIn": false
                ]

                try await firestoreManager.updateAttendance(existingAttendance.id, fields: updatedFields)
                print("Successfully updated attendance record:", existingAttendance.id)

                try await firestoreManager.updateStudentStatus(studentID: student.id, isCheckedIn: false)
                print("Successfully updated student isCheckedIn status to false")

            } else {
                // Student is checking in
                print("Checking in, creating a new attendance record")

                let newAttendance = Attendance(
                    id: UUID().uuidString,
                    studentID: student.id,
                    timeIn: Date(),
                    timeOut: nil,
                    isCheckedIn: true,
                    isLate: false,
                    totalTime: 0
                )

                try await firestoreManager.createAttendance(newAttendance)
                print("Created new attendance record:", newAttendance.id)

                try await firestoreManager.updateStudentStatus(studentID: student.id, isCheckedIn: true)
                print("Successfully updated student isCheckedIn status to true")
            }

        } catch {
            print("Error checking in/out:", error.localizedDescription)
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
