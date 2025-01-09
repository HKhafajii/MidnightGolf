//
//  UserView.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 1/6/25.
//

import SwiftUI

struct UsersView: View {
    @StateObject private var manager = FirestoreManager.shared

    var body: some View {
        List(manager.students) { student in
            VStack(alignment: .leading) {
                Text("\(student.first) \(student.last)")
                    .font(.headline)
                Text("Born: \(student.born)")
                Text("School: \(student.school)")
                Text("Graduation Date: \(student.gradDate)")
            }
        }
        .onAppear {
            Task {
                await manager.fetchAllUsers()
            }
        }
    }
}
#Preview {
    UsersView()
}
