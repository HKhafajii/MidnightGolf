//
//  AttendanceRowView.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 2/27/25.
//

import SwiftUI

struct AttendanceRowView: View {
    let attendance: Attendance
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {

                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.blue)
                    
                    Text(formatDate(attendance.timeIn))
                        .font(.headline)
                }
                
                // Check-in/out status
                HStack {
                    Image(systemName: attendance.isCheckedIn ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(attendance.isCheckedIn ? .green : .red)
                    
                    Text(attendance.isCheckedIn ? "Checked In" : "Checked Out")
                        .font(.subheadline)
                }
                
                // Duration info
                if let timeOut = attendance.timeOut {
                    HStack {
                        Image(systemName: "hourglass")
                            .foregroundColor(.orange)
                        
                        Text("Duration: \(formatDuration(attendance.totalTime))")
                            .font(.caption)
                    }
                    
                    Text("Checked out: \(formatDate(timeOut))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Late status if applicable
                if attendance.isLate {
                    Text("Late Arrival")
                        .font(.caption)
                        .foregroundColor(.orange)
                        .padding(.top, 2)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground).opacity(0.9))
        .cornerRadius(10)
        .shadow(radius: 1)
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formatDuration(_ hours: Double) -> String {
        let totalMinutes = Int(hours * 60)
        let hrs = totalMinutes / 60
        let mins = totalMinutes % 60
        
        if hrs > 0 {
            return "\(hrs)h \(mins)m"
        } else {
            return "\(mins) min"
        }
    }
}

struct PageIndicatorView: View {
    let filters: [String]
    let selectedFilter: Int
    let screenWidth: CGFloat
    let screenHeight: CGFloat
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<filters.count, id: \.self) { index in
                Circle()
                    .fill(index == selectedFilter ? Color.blue : Color.gray.opacity(0.5))
                    .frame(width: 8, height: 8)
            }
        }
    }
}

struct CustomSegmentedPicker: View {
    @Binding var selectedIndex: Int
    let options: [String]
    
    var body: some View {
        HStack {
            ForEach(options.indices, id: \.self) { index in
                Button(action: {
                    selectedIndex = index
                }) {
                    Text(options[index])
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(
                            selectedIndex == index ?
                                Color.blue :
                                Color.gray.opacity(0.2)
                        )
                        .foregroundColor(selectedIndex == index ? .white : .primary)
                        .cornerRadius(8)
                }
            }
        }
        .padding(4)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    AttendanceTabScreen(
        student: Student(
            id: "test-id",
            group: "Test Group",
            first: "Test",
            last: "User",
            born: "2002",
            isMale: false,
            cellNumber: "1234567890",
            email: "Test-Email",
            cohort: false,
            school: "Test School",
            gradDate: "2020",
            qrCode: "",
            isCheckedIn: false
        )
    )
    .environmentObject(ViewModel())
}

