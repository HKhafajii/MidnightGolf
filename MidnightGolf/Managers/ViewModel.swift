//
//  ViewModel.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 1/30/25.
//


import SwiftUI
import Combine

class ViewModel: ObservableObject {
        @Published var firestoreManager = FirestoreManager()
        @Published var checkInManager = CheckInManager()
        @Published var attendanceViewModel = AttendanceViewModel()

        init() {
            Task {
                await firestoreManager.fetchAllUsers()
            }
        }
    
    
    
    func loadAttendance(for student: Student) async {
        attendanceViewModel.isLoading = true
        attendanceViewModel.errorMessage = nil
        
        defer { attendanceViewModel.isLoading = false }
        do {
            attendanceViewModel.attendanceHistory = try await firestoreManager.getAttendanceHistory(studentID: student.id)
        } catch {
            attendanceViewModel.errorMessage = "Failed to load attendance: \(error.localizedDescription)"
        }
    
    } // End of loadAttendance Function
    }
