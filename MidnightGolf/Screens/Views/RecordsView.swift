//
//  RecordsView.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 4/28/25.
//

import SwiftUI



struct RecordsView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @State private var todayAttendance: [Attendance] = []
    @State private var weeklyAttendance: [Attendance] = []
    @State private var selectedFilter = 0
    let filters = ["Tardies", "Absences"]
    @State private var tardyStudents: [(Student, Attendance)] = []
    @State private var absentStudents: [Student] = []
    let student: Student
    @State private var attendanceHistory: [Attendance] = []
    
    var body: some View {
        
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            VStack {
                SegmentedPickerView(selectedFilter: $selectedFilter, filters: filters)
                    .font(.custom("NeueMontreal-Regular", size: screenWidth * 0.015))
                    .padding()
                
                AttendanceListView(selectedFilter: selectedFilter, todayAttendance: todayAttendance, weeklyAttendance: weeklyAttendance, monthlyAttendance: nil)
                    .frame(maxWidth: .infinity)
                
                PageIndicatorView(filters: filters, selectedFilter: selectedFilter, screenWidth: screenWidth, screenHeight: screenHeight)
                    .padding(.bottom)
                
                Spacer()
            }
        }
        .onAppear {
            Task {
                await viewModel.loadAllAttendance()
                attendanceHistory = viewModel.getAttendanceHistory(studentID: student.id)

              
                tardyStudents = attendanceHistory
                    .filter { $0.isLate }
                    .map  { (student, $0) }

                if viewModel.isAbsentToday(student) {
                    absentStudents = [student]
                } else {
                    absentStudents = []
                }
            }
        }
    }
}

#Preview {
    RecordsView(student: Student(id: "asd", first: "Hass", last: "Kal", born: "2002", isMale: true, cellNumber: "313-313-3133", email: "alkhafajihasssan@gmaic.asd", cohort: true, school: "Jameson", gradDate: "assd", qrCode: "HassKal"))
        .environmentObject(ViewModel())
}
