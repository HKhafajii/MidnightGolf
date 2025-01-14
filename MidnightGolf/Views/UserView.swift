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
                
                if let qrCodeImage = UIImage(data: student.qrCode) {
                    Image(uiImage: qrCodeImage)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                }
                
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
