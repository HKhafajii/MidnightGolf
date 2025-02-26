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
    @State private var isShowingEmailSentAlert = false
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                StudentDirectoryScreen()
                    .environmentObject(viewModel)
            }
            
            .padding()
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        viewModel.mailManager.sendEmail(students: viewModel.students)
                        isShowingEmailSentAlert = true
                    } label: {
                        
                        Text("Send student list")
                            .font(.title3)
                            .foregroundStyle(Color("MGPnavy"))
                        Image(systemName: "arrowshape.turn.up.right")
                            .font(.title3)
                            .foregroundStyle(Color("MGPnavy"))
                    }
                    
                    Spacer()
                    
                    
                    ShareLink(item: viewModel.generateCSVFile()) {
                        Label("Attendance Records", systemImage: "list.bullet.rectangle.portrait")
                            .font(.title3)
                            .foregroundStyle(Color("MGPnavy"))
                        
                    }
                    
                    Spacer()
                    
                    Button {
                        showAddStudentSheet = true
                    } label: {
                        Text("Add student")
                            .font(.title3)
                            .foregroundStyle(Color("MGPnavy"))
                        Image(systemName: "plus")
                            .font(.title3)
                            .foregroundStyle(Color("MGPnavy"))
                    }
                }
            }
            .alert("Email Sent!", isPresented: $isShowingEmailSentAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("The email has been sent successfully.")
            }
            .sheet(isPresented: $showAddStudentSheet) {
                AddUser(showAddStudentSheet: $showAddStudentSheet)
                    .environmentObject(viewModel)
            }
        }
    }
}

#Preview {
    AdminTest()
        .environmentObject(ViewModel())
}
