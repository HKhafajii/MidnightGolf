//
//  AdminSettingsScreen.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 3/10/25.
//


import SwiftUI

enum AdminSettings: String, Identifiable, CaseIterable {
    var id: String { rawValue }
    case changeLateThreshold = "Change Late Threshold"
    case somethingElse = "Something Else"
    case attendanceByDate = "Attendance By Date"
}

struct AdminSettingsScreen: View {
    
    @State private var selectedSetting: AdminSettings? = .changeLateThreshold
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationSplitView {
            List(AdminSettings.allCases, selection: $selectedSetting) { setting in
                NavigationLink(value: setting) {
                    Text(setting.rawValue)
                        .foregroundStyle(Color("MGPnavy"))
                        .font(.headline)
                }
            }
            .navigationTitle("Admin Settings")
            
        } detail: {
            DetailView(selectedSetting: selectedSetting)
        }
        .tint(Color("MGPnavy"))
    }
}

struct DetailView: View {
    let selectedSetting: AdminSettings?
    
    var body: some View {
        Group {
            if let setting = selectedSetting {
                switch setting {
                case .changeLateThreshold:
                    LateThresholdChanges()
                case .somethingElse:
                    SomethingElseView()
                case .attendanceByDate:
                    AttendanceSearchView()
                }
            } else {
                Text("Select a setting")
                    .foregroundStyle(Color("MGPnavy"))
            }
        }
        .animation(.easeInOut, value: selectedSetting)
    }
}

#Preview {
    AdminSettingsScreen()
        .environmentObject(ViewModel())
}

struct SomethingElseView: View {
    var body: some View {
        Text("Hello, World!")
    }
}

struct AttendanceSearchView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var selectedDate: Date? = nil
    
    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
        
                TitleComponent(title: "Attendance By Date")
                
                Spacer()

                DatePicker(
                    "Select a date: ",
                    selection: Binding(
                        get: { selectedDate ?? Date() },
                        set: { selectedDate = $0 }
                    ),
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)
                .tint(Color("MGPnavy"))
                .font(.title2)
                .frame(maxWidth: CheckInScreen.deviceWidth / 2)
                .padding()
                
                List {
                    if filteredAttendance.isEmpty {
                        Text("No entries found")
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        ForEach(filteredAttendance) { record in
                            VStack(alignment: .leading) {
                                Text(viewModel.getStudentName(by: record.studentID))
                                if let date = record.timeIn {
                                    Text("Checked in on \(date.formatted(date: .long, time: .shortened))")
                                }
                            }
                        }
                    }
                }
                .background(Color.clear)
                .listStyle(PlainListStyle())
                .presentationCornerRadius(20)
                .padding(10)
                .frame(maxWidth: CheckInScreen.deviceWidth / 2)
            }
            .padding()
        }
    }
    
    private var filteredAttendance: [Attendance] {
        let calendar = Calendar.current
        
        let filtered: [Attendance]
        if let selected = selectedDate, dateWasChanged {
            filtered = viewModel.attendance.filter { record in
                if let date = record.timeIn {
                    return calendar.isDate(date, inSameDayAs: selected)
                }
                return false
            }
        } else {
            filtered = viewModel.attendance
        }
        
        return filtered.sorted {
            ($0.timeIn ?? Date.distantPast) > ($1.timeIn ?? Date.distantPast)
        }
    }
    
    private var dateWasChanged: Bool {
        guard let selected = selectedDate else { return false }
        let today = Calendar.current.startOfDay(for: Date())
        let selectedDay = Calendar.current.startOfDay(for: selected)
        return selectedDay != today
    }
}


struct LateThresholdChanges: View {
    @State var intValue: Int = 0
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                
                TitleComponent(title: "Change Late Threshold")
                
                Text("Enter an hour and a minute to change when a student is considered late")
                    .font(.headline)
                    .padding()
                
                Spacer()
                
                NumberFieldComponent(title: "Threshold Hour", description: "Enter an hour", intValue: intValue)
                NumberFieldComponent(title: "Threshold Minute", description: "Enter a minute", intValue: intValue)
                
                
                Button {
                    
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("MGPnavy"))
                            .frame(maxWidth: CheckInScreen.deviceWidth / 2.5,
                                   maxHeight: CheckInScreen.deviceHeight * 0.05)
                            .shadow(radius: 8, x: 0, y: 0)
                        
                        Text("Save Changes")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: CheckInScreen.deviceWidth / 2.5)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
}


