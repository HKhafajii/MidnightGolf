//
//  ContentView.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 9/25/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var fbManager = FirestoreManager()
    @State private var path: [String] = []
    @State var school: String
    @State var gradDate: String
    @State var firstName: String
    @State var lastName: String
    @State var birthYear: Int
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading) {
                
                Text("School")
                    .font(.title3)
                TextField("Enter email...", text: $school)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                Text("Graduation date")
                    .font(.title3)
                TextField("Enter Graduation date...", text: $gradDate)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                Text("First Name")
                    .font(.title3)
                TextField("Enter first name...", text: $firstName)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                Text("Last Name")
                    .font(.title3)
                TextField("Enter last name...", text: $lastName)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                Text("Birth Year")
                    .font(.title3)
                TextField("Enter birth year...", value: $birthYear, formatter: NumberFormatter())
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                HStack {
                    Spacer()
//                    Button("Add me") {
//                        Task {
//                            await fbManager.postUser(first: firstName, last: lastName, born: birthYear, )
//                            path.append("destination")
//                        }
//                        
//                    }
                    
//                    TODO: Fix this so that when the button is pressed it navigates to the next view and calls the async function
//                    .navigationDestination(for: String.self, destination: { value in
//                        if value == "destination" {
//                            Signedin()
//                        }
//                    })
                    Spacer()
                } // End of HStack
                
                NavigationLink("Send email", destination: EmailSenderView())
               
            } // End of VStack
          
            .padding()
        } // End of Navigationstack
    }
}

#Preview {
    ContentView(school: "", gradDate: "", firstName: "", lastName: "", birthYear: 0)
}


