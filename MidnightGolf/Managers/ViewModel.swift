import SwiftUI


class ViewModel: ObservableObject {
     var firestoreManager = FirestoreManager()
     var checkInManager = CheckInManager()
     var attendanceManager = AttendanceManager()
     var mailManager = MailManager()
     var qrManager = QRCodeManager()
     var csvManager = CSVManager()

    
    @Published var students: [Student] = []
    @Published var attendance: [Attendance] = []
    @Published var names: [String] = []
    @Published var adminPin: [Int] = []
    
    init() {
        Task {
            await loadAllStudents()
            await loadAllAttendance()
        }
        adminPin = [3, 2, 9, 8]
    }
    
    func updateAdminPin(newPin: [Int]) {
        adminPin = newPin
    }
    
    func updateLateThreshold(hour: Int, minute: Int) {
        checkInManager.lateThresholdHour = hour + 12 // to put it into millitary time
        checkInManager.lateThresholdMinute = minute
    }
    
    @MainActor
    func importStudents(from url: URL) async {
        do {
            let parsed = try await csvManager.loadStudents(from: url)
        

            students = parsed

            for s in parsed {
                await upload(s)
            }

            await loadAllStudents()

        } catch {
            print("mportStudents error:", error)
        }
    }
    
    @MainActor
    func upload(_ s: Student) async {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"

      
        let bornDate   = fmt.date(from: s.born)    ?? Date()
        let gradDate   = fmt.date(from: s.gradDate) ?? Date()

      
        do {
            try await firestoreManager.postUser(
                first: s.first,
                last: s.last,
                born: bornDate,
                school: s.school,
                gradDate: gradDate,
                qrCode: s.qrCode,
                cellNum: s.cellNumber,
                email: s.email,
                gender: s.isMale,
                cohort: s.cohort
            )
        } catch {
            print("upload failed for \(s.first) \(s.last):", error)
        }
    }
    
    @MainActor
    func postUser(first: String,
                  last: String,
                  born: Date,
                  school: String,
                  gradDate: Date,
                  cellNum: String,
                  email: String,
                  gender: Bool,
                  cohort: Bool) async throws {
        do {
            let qrCodeText = first + last
            try await firestoreManager.postUser(
                first: first,
                last: last,
                born: born,
                school: school,
                gradDate: gradDate,
                qrCode: qrCodeText,
                cellNum: cellNum,
                email: email,
                gender: gender,
                cohort: cohort
            )
            
            await loadAllStudents()
            
        } catch {
            print("Error posting user: \(error)")
        }
    } // End of PostUser
    
    func getAttendanceHistory(studentID: String) -> [Attendance] {
        var tempAttendance: [Attendance] = []
        for attendance in self.attendance {
            if attendance.studentID == studentID {
                tempAttendance.append(attendance)
                print("Fetched attendance for \(attendance.studentID)")
            }
        }
        return tempAttendance
    } // End of getAttendanceHistory
    
    func getStudentName(by id: String) -> String {
        if let student = students.first(where: { $0.id == id }) {
            return "\(student.first) \(student.last)"
        } else {
            return "Unknown Student"
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
    func loadAllAttendance() async {
        do {
            let fetched = try await firestoreManager.fetchAllAttendance()
            self.attendance = fetched
            
        } catch {
            print("Failed to fetch users: \(error)")
        }
    } // End of loadAllAttendance
    
    func isAbsentToday(_ student: Student) -> Bool {
        
        guard checkInManager.studentIsRequiredToday(student) else { return false }


        guard checkInManager.dayIsOver() else { return false }

      
        let today = Calendar.current.startOfDay(for: Date())
        let hasRecord = attendance.contains { att in
            att.studentID == student.id &&
            att.timeIn.map { Calendar.current.isDate($0, inSameDayAs: today) } == true
        }

        return !hasRecord
    }
    
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

                try await firestoreManager.updateAttendance(for: student.id,existingAttendance.id, fields: updatedFields)
                print("Successfully updated attendance record:", existingAttendance.id)

                try await firestoreManager.updateStudentStatus(studentID: student.id, isCheckedIn: false)
                print("Successfully updated student isCheckedIn status to false")

            } else {
                
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

    func generateCSVFile() -> URL { return csvManager.generateCSV(students: students) }
    
}
