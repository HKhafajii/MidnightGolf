//
//  AdminTest.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 2/8/25.
//

import SwiftUI

struct AdminTest: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var showAddStudentSheet = false
    var body: some View {
        
        NavigationStack {
            VStack {
                
                StudentDirectoryScreen()
                    .environmentObject(viewModel)
                
                HStack {
                    Button {
                        viewModel.mailManager.sendEmail(students: viewModel.students)
                    } label: {
                        HStack {
                            Image(systemName: "arrowshape.turn.up.right")
                            Text("Email Student List ") 
                        }
                        .font(.title3)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 24).fill(Color("MGPnavy")))
                        .foregroundColor(.white)
                    }
                    Spacer()
                    Button {
                        showAddStudentSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Student")
                        }
                        .font(.title3)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 24).fill(Color("MGPnavy")))
                        .foregroundColor(.white)
                        
                    }
                    .sheet(isPresented: $showAddStudentSheet) {
                        AddUser(showAddStudentSheet: $showAddStudentSheet)
                            .environmentObject(viewModel)
                    }
                    
                }
            }
            .padding()
        }
    }
}

#Preview {
    AdminTest()
        .environmentObject(ViewModel())
}
