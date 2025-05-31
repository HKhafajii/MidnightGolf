//
//  RecordsTabScreen.swift
//  MidnightGolf
//

import SwiftUI

private struct TardyRow: Identifiable {
    let id = UUID()
    let student: Student
    let attendance: Attendance        
}

private struct AbsenceRow: Identifiable {
    let id = UUID()
    let student: Student
    let date: Date
}


struct RecordsTabScreen: View {

    @EnvironmentObject var viewModel: ViewModel

    
    @State private var selectedFilter = 0
    private let filters = ["Tardies", "Absences"]

    @State private var tardyRows:   [TardyRow]  = []
    @State private var absenceRows: [AbsenceRow] = []

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                BackgroundImageView(screenWidth: w, screenHeight: h)

                VStack {
                    SegmentedPickerView(selectedFilter: $selectedFilter,
                                        filters: filters)
                        .font(.custom("NeueMontreal-Regular", size: w * 0.015))
                        .padding()

                    RecordsListView(selectedFilter: selectedFilter,
                                    tardyRows: tardyRows,
                                    absenceRows: absenceRows)
                        .frame(maxWidth: .infinity)

                    PageIndicatorView(filters: filters,
                                      selectedFilter: selectedFilter,
                                      screenWidth: w,
                                      screenHeight: h)
                        .padding(.bottom)
                }
                .padding([.leading, .top])
            }
        }
        .task { await buildRows() }
        .ignoresSafeArea()
    }

   
    private func buildRows() async {
        await viewModel.loadAllStudents()
        await viewModel.loadAllAttendance()

        var tardies:  [TardyRow]  = []
        var absences: [AbsenceRow] = []

        for s in viewModel.students {
            let history = viewModel.getAttendanceHistory(studentID: s.id)

         
            tardies += history
                .filter(\.isLate)
                .map { TardyRow(student: s, attendance: $0) }

       
            if viewModel.isAbsentToday(s) {
                absences.append(AbsenceRow(student: s, date: Date()))
            }
        }
   tardyRows   = tardies.sorted { ($0.attendance.timeIn ?? .distantPast) > ($1.attendance.timeIn ?? .distantPast) }
        absenceRows = absences
    }
}


private struct RecordsListView: View {

    let selectedFilter: Int
    let tardyRows:   [TardyRow]
    let absenceRows: [AbsenceRow]

    private let df: DateFormatter = {
        let d = DateFormatter()
        d.dateStyle = .medium
        d.timeStyle = .short
        return d
    }()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if selectedFilter == 0 {
                    ForEach(tardyRows) { row in
                        AttendanceRowView(attendance: row.attendance)
                    }

                    ForEach(absenceRows) { row in
                        HStack {
                            Text("\(row.student.first) \(row.student.last)")
                                .fontWeight(.bold)
                            Spacer()
                            Text("Absent today")
                                .foregroundStyle(.red)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    RecordsTabScreen()
        .environmentObject(ViewModel())
}
