import SwiftUI

struct AttendanceView: View {
    let student: Student
    @State private var attendanceHistory: [Attendance] = []
    @State private var errorMessage: String?
    @State private var isLoading = true
    @ObservedObject var firestoreManager = FirestoreManager.shared

    var body: some View {
        VStack {
            
            Text("Attendance for \(student.first) \(student.last)")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            
            if isLoading {
                ProgressView("Loading attendance...")
                    .padding()
            } else if let errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else if attendanceHistory.isEmpty {
                Text("No attendance records found.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                
                List(attendanceHistory) { attendance in
                    VStack(alignment: .leading) {
                        Text("Checked In: \(attendance.timeIn?.formatted() ?? "N/A")")
                        Text(attendance.timeOut != nil ?
                             "Checked Out: \(attendance.timeOut!.formatted())" :
                             "Currently Checked In")
                            .foregroundColor(attendance.timeOut == nil ? .blue : .primary)
                        Text("Late Arrival: \(attendance.isLate ? "Yes" : "No")")
                        Text("Total Time: \(attendance.totalTime, specifier: "%.2f") hours")
                    }
                    .padding(.vertical, 5)
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
        .padding()
        .task {
            guard !student.id.isEmpty else { return }
            await loadAttendance()
        }
        
    }

    // Fetch Attendance History
    private func loadAttendance() async {
        
                
        isLoading = true
        print("DEBUG: Starting load for student \(student.id)")
        
        defer { isLoading = false }
        
        
        do {
            print("DEBUG: Student exists? \(student.id.isEmpty ? "NO" : "YES")")
            let history = try await firestoreManager.getAttendanceHistory(studentID: student.id)
            
            DispatchQueue.main.async {
                attendanceHistory = history
            }
            
        } catch {
            DispatchQueue.main.async {
                errorMessage = error.localizedDescription
            }
        }
    } // End of loadAttendance()
    
}

#Preview {
    let validQRCode = "Sample QR Code".data(using: .utf8) ?? Data()
    AttendanceView(
        student: Student(
            id: "test-id",
            group: "Test Group",
            first: "Test",
            last: "User",
            born: "2002",
            school: "Test School",
            gradDate: "2020",
            qrCode: Data(),
            isCheckedIn: false
            
        )
    )
}



