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
            Text("Checked In: \(attendance.timeIn?.formatted() ?? "N/A")")
                .font(.headline)
            Text(attendance.timeOut != nil
                 ? "Checked Out: \(attendance.timeOut!.formatted())"
                 : "Currently Checked In")
                .font(.subheadline)
                .foregroundColor(attendance.timeOut == nil ? .blue : .primary)
            Text("Late Arrival: \(attendance.isLate ? "Yes" : "No")")
                .font(.subheadline)
            Text("Total Time: \(attendance.totalTime, specifier: "%.2f") hours")
                .font(.subheadline)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.8))
                .shadow(radius: 5)
        )
        .padding(.horizontal)
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
                    .animation(.smooth, value: selectedFilter)
            }
        }
        .padding(.top, screenHeight * 0.4)
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
                        withAnimation(.smooth) {
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

