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
                ZStack() {
                    BackgroundImageView(screenWidth: screenWidth, screenHeight: screenHeight)
                    VStack {
                        
                        HeaderView(student: student)
                        
                        Spacer()
                        
                        HStack {
                            VStack {
                                StudentProfileView(student: student)
                                    .padding()
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
                                .frame(maxWidth: .infinity)
                                
                                PageIndicatorView(filters: filters, selectedFilter: selectedFilter, screenWidth: screenWidth, screenHeight: screenHeight)
                                    .padding(.bottom)
                                
                                Spacer()
                            }
                            
                            
                        }
                    }
                    .frame(maxHeight: screenHeight * 0.8)
                    .padding([.leading, .top])
                }
            }
        }
        .onAppear {
            Task {
                isLoading = true
                errorMessage = nil
                
                await viewModel.loadAllAttendance()
                attendanceHistory = viewModel.getAttendanceHistory(studentID: student.id)
                
                todayAttendance = viewModel.attendanceManager.filterCheckInToday(attendanceList: attendanceHistory)
                weeklyAttendance = viewModel.attendanceManager.filterCheckInWeek(attendanceList: attendanceHistory)
                monthlyAttendance = viewModel.attendanceManager.filterCheckInMonth(attendanceList: attendanceHistory)
                isLoading = false
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

#Preview {
    AttendanceTabScreen(student: Student(id: "234", group: "234", first: "234", last: "234", born: "234", isMale: true, cellNumber: "asdas", email: "asdasd", cohort: false, school: "asd", gradDate: "asd", qrCode: "asd"))
        .environmentObject(ViewModel())
}
