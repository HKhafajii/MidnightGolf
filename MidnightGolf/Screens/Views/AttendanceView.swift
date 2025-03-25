import SwiftUI

struct AttendanceView: View {
    let student: Student
    @State private var attendanceHistory: [Attendance] = []
    @State private var errorMessage: String?
    @State private var isLoading = true
    @EnvironmentObject private var viewModel: ViewModel
    
    

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
                        Text(attendance.timeOut != nil
                             ? "Checked Out: \(attendance.timeOut!.formatted())"
                             : "Currently Checked In")
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
            isLoading = true
            errorMessage = nil
            let history = viewModel.getAttendanceHistory(studentID: student.id)
            attendanceHistory = history
            isLoading = false
        }
        
    }
}

#Preview {

    AttendanceView(
        student: Student(
            id: "test-id",
            first: "Test",
            last: "User",
            born: "2002",
            isMale: false,
            cellNumber: "123123",
            email: "test-email",
            cohort: false,
            school: "Test School",
            gradDate: "2020",
            qrCode: "",
            isCheckedIn: false
        )  
    )
    .environmentObject(ViewModel())
}



