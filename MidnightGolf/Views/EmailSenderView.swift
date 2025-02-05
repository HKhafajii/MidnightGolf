//
//  EmailSenderView.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 11/27/24.
//

import SwiftUI

struct EmailSenderView: View {
    
    @State var mailSubject = ""
    @State var mailBody = ""
    @State var mailTo = ""
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                Button {
                    viewModel.mailManager.sendEmail(students: viewModel.students)
                } label: {
                    Text("Send Student List Email")
                        .font(.title2)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("MGPnavy")))
                        .foregroundColor(.white)
                }
                
            }// End of VStack
            .padding()
        }
    } // End of var body
} // End of EmailSenderView Struct

#Preview {
    EmailSenderView()
}
