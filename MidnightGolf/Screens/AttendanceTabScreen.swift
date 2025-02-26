//
//  AttendanceTabScreen.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 1/14/25.
//

import SwiftUI

struct AttendanceTabScreen: View {
    @EnvironmentObject var viewModel: ViewModel
    
    let student: Student
    @State private var attendanceHistory: [Attendance] = []
    @State private var errorMessage: String?
    @State private var isLoading = true
    @State private var todayAttendance: [Attendance] = []
    @State private var weeklyAttendance: [Attendance] = []
    @State private var monthlyAttendance: [Attendance] = []
    
    @State private var selectedFilter = 0
    let filters = ["Daily", "Weekly", "Monthly"]
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            NavigationStack {
                ZStack {
                    BackgroundImageView(screenWidth: screenWidth, screenHeight: screenHeight)
                    
                    VStack {
                        HeaderView(student: student)
                        Spacer()
                        
                        HStack {
                            
                            VStack {
                                Text("School: " + student.school)
                                Text("Graduation Date: " + student.gradDate)
                                Text("Mobile Phone: " + student.cellNumber)
                                Text("Birthdate" + student.born)
                                Text("Cohort: \(student.cohort ? "Mon/Wed" : "Tue/Thu")")
                                Text("Email: " + student.email)
                                
                                Spacer()
                            }
                            
                            VStack {
                                SegmentedPickerView(selectedFilter: $selectedFilter, filters: filters)
                                    .font(.custom("NeueMontreal-Regular", size: screenWidth * 0.015))
                                    .padding()
                                
                                AttendanceListView(
                                    selectedFilter: selectedFilter,
                                    todayAttendance: todayAttendance,
                                    weeklyAttendance: weeklyAttendance,
                                    monthlyAttendance: monthlyAttendance
                                )
                                .frame(maxWidth: screenWidth * 0.9)
                                .padding(.horizontal)
                                
                                PageIndicatorView(filters: filters, selectedFilter: selectedFilter, screenWidth: screenWidth, screenHeight: screenHeight)
                                    .padding(.bottom)
                                
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                    .padding()
                }
            }
            .safeAreaInset(edge: .top) {
                Spacer().frame(height: screenHeight * 0.05)
            }
        }
        .onAppear {
            Task {
                isLoading = true
                errorMessage = nil
                let history = viewModel.getAttendanceHistory(studentID: student.id)
                attendanceHistory = history
                isLoading = false
                
                await viewModel.loadAllAttendance()
                todayAttendance = viewModel.attendanceManager.filterCheckInToday(attendanceList: attendanceHistory)
                weeklyAttendance = viewModel.attendanceManager.filterCheckInWeek(attendanceList: attendanceHistory)
                monthlyAttendance = viewModel.attendanceManager.filterCheckInMonth(attendanceList: attendanceHistory)
            }
        }
        .ignoresSafeArea()
    }
}

struct BackgroundImageView: View {
    let screenWidth: CGFloat
    let screenHeight: CGFloat
    
    var body: some View {
        Image("bg")
            .resizable()
            .scaledToFill()
            .frame(width: screenWidth, height: screenHeight)
            .ignoresSafeArea()
    }
}

struct HeaderView: View {
    let student: Student
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text("Attendance for \(student.first) \(student.last)")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                Spacer()
            }
        }
    }
}

struct SegmentedPickerView: View {
    @Binding var selectedFilter: Int
    let filters: [String]
    
    var body: some View {
        CustomSegmentedPicker(selectedIndex: $selectedFilter, options: filters)
    }
}

struct AttendanceListView: View {
    let selectedFilter: Int
    let todayAttendance: [Attendance]
    let weeklyAttendance: [Attendance]
    let monthlyAttendance: [Attendance]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if selectedFilter == 0 {
                    ForEach(todayAttendance) { attendance in
                        AttendanceRowView(attendance: attendance)
                    }
                } else if selectedFilter == 1 {
                    ForEach(weeklyAttendance) { attendance in
                        AttendanceRowView(attendance: attendance)
                    }
                } else {
                    ForEach(monthlyAttendance) { attendance in
                        AttendanceRowView(attendance: attendance)
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

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
