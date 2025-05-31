//
//  AdminTest.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 2/8/25.
//

import SwiftUI
import MessageUI

struct AdminScreen: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var showAddStudentSheet = false
    @State private var showMailComposer = false
    @State private var showEmailResultAlert = false

    var body: some View {
        NavigationStack {
            StudentDirectoryScreen()
                .environmentObject(viewModel)
                .padding()

            // ───────────── Toolbar ─────────────
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {

                        // 1️⃣  Button toggles *sheet* flag
                        Button {
                            if MFMailComposeViewController.canSendMail() {
                                showMailComposer = true          // ← only this flag
                            } else {
                                print("Mail not configured")
                            }
                        } label: {
                            Text("Student list")
                                .font(.title3)
                                .foregroundStyle(Color("MGPnavy"))
                                .fontWeight(.semibold)
                            Image(systemName: "arrowshape.turn.up.right")
                                .font(.title3)
                                .foregroundStyle(Color("MGPnavy"))
                                .fontWeight(.semibold)
                        }

                        Spacer()
                        CSVImportButton()
                            .environmentObject(viewModel)
                        Spacer()

                        Button {
                            showAddStudentSheet = true
                        } label: {
                            Text("Add student")
                                .font(.title3)
                                .foregroundStyle(Color("MGPnavy"))
                                .fontWeight(.semibold)
                            Image(systemName: "plus")
                                .font(.title3)
                                .foregroundStyle(Color("MGPnavy"))
                                .fontWeight(.semibold)
                        }
                    }
                }

            // ───────────── Modals ─────────────
                .sheet(isPresented: $showMailComposer) {          // ← bind sheet here
                    MailComposeView(
                        students: viewModel.students,
                        onFinish: { showEmailResultAlert = true }  // ← set alert flag
                    )
                }
                .alert("Email Sent!",
                       isPresented: $showEmailResultAlert) {      // ← alert flag only
                    Button("OK", role: .cancel) { }
                }

                .sheet(isPresented: $showAddStudentSheet) {
                    AddUser(showAddStudentSheet: $showAddStudentSheet)
                        .environmentObject(viewModel)
                }

                .toolbarBackground(Color.white, for: .bottomBar)
                .toolbarBackground(.visible, for: .bottomBar)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .tint(Color("MGPnavy"))
    }
}

#Preview {
    AdminScreen()
        .environmentObject(ViewModel())
}
