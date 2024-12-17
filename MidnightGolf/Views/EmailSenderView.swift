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
    @ObservedObject var manager = FirestoreManager()
    
    var body: some View {
        VStack(spacing: 30) {
            
            TextField("Subject", text: $mailSubject)
                .font(.title2)
                
            TextField("Body", text: $mailBody)
                .font(.title2)
                
            TextField("To", text: $mailTo)
                .font(.title2)
            
            Button {
                
                manager.mailHelper.sendEmail(subject: mailSubject, body: mailBody, to: mailTo)
                
            } label: {
                Text("Send email")
            }
            
        }// End of VStack
        .padding()
    } // End of var body
} // End of EmailSenderView Struct

#Preview {
    EmailSenderView()
}
