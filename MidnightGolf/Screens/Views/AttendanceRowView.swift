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
        VStack(alignment: .leading, spacing: 8) {
            Text("Checked In: \(formatDate(attendance.timeIn))")
                .font(.headline)
            Text(attendance.timeOut != nil
                 ? "Checked Out: \(formatDate(attendance.timeOut))"
                 : "Currently Checked In")
                .font(.subheadline)
                .foregroundColor(attendance.timeOut == nil ? .blue : .primary)
            Text("Late Arrival: \(attendance.isLate ? "Yes" : "No")")
                .font(.subheadline)
            Text("Total Time: \(formatDuration(attendance.totalTime)) hours")
                .font(.subheadline)
        }
        .padding()
        .frame(maxWidth: 350)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .shadow(radius: 10)
        )
        .padding(.horizontal)
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
        HStack(spacing: screenWidth * 0.008) {
            ForEach(filters.indices, id: \.self) { index in
                Circle()
                    .frame(width: screenWidth * 0.01, height: screenHeight * 0.01)
                    .foregroundColor(selectedFilter == index ? .black : .gray)
                    .scaleEffect(selectedFilter == index ? 1.2 : 1.0)
                    .animation(.easeIn(duration: 0.3), value: selectedFilter)
            }
        }
        .padding(.top, screenHeight * 0.06)
        .padding(.bottom)
    }
}

struct CustomSegmentedPicker: View {
    @Binding var selectedIndex: Int
    let options: [String]
    
    var body: some View {
        HStack {
            ForEach(options.indices, id: \.self) { index in
                Text(options[index])
                    .padding(.vertical, 10)
                    .padding(.horizontal, 30)
                    .background(
                        ZStack {
                            if selectedIndex == index {
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.white)
                                    .matchedGeometryEffect(id: "selector", in: animation)
                                    .shadow(radius: 10, x: 0, y: 8)
                            }
                        }
                    )
                    .foregroundColor(.black)
                    .onTapGesture {
                        withAnimation(.smooth(duration: 0.2)) {
                            selectedIndex = index
                        }
                    }
            }
        }
        .padding(5)
        .background(Color(.systemGray4))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(radius: 20, x: 0, y: 8)
    }
    
    @Namespace private var animation
}



