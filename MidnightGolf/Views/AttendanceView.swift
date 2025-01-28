import SwiftUI

struct AttendanceView: View {
    let student: Student
    @State private var attendanceHistory: [Attendance] = []
    @State private var errorMessage: String?
    @State private var isLoading = true

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
        
    }

    // Fetch Attendance History
    private func loadAttendance() async {
        isLoading = true
        errorMessage = nil
        do {
            attendanceHistory = try await FirestoreManager.shared.getAttendanceHistory(studentID: student.id)
        } catch {
            errorMessage = "Failed to load attendance: \(error.localizedDescription)"
        }
        isLoading = false
    }
}

#Preview {
    let validQRCode = "Sample QR Code".data(using: .utf8) ?? Data()
    AttendanceView(
        student: Student(
            id: UUID().uuidString,
            group: "Group A",
            first: "Hassan",
            last: "Alkhafaji",
            born: "2002",
            school: "Melvindale",
            gradDate: "2020",
            qrCode: validQRCode,
            isCheckedIn: false
            
        )
    )
}



