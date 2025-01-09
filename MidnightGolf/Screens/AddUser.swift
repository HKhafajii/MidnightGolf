import SwiftUI

struct AddUser: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var birthDate: Date = Date()
    @State var school: String = ""
    @State var gradDate: Date = Date()

    var body: some View {
        
        
        NavigationStack {
            ZStack {
                
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: 15) {
                    
                    VStack {
                        
                        Text("First name")
                            .font(.headline)
                        TextField("First name...", text: $firstName)
//                            .padding()
//                            .background(Color.gray.opacity(0.2))
//                            .cornerRadius(16)
                        
                        
                        Text("Last name")
                            .font(.headline)
                        TextField("Last name...", text: $lastName)
                        //                        .padding()
                        //                        .background(Color.gray.opacity(0.2))
                        //                        .cornerRadius(16)
                        
                        
                        
                        Text("Date of Birth")
                            .font(.headline)
//                        DatePicker("Date of Birth", selection: $birthDate, displayedComponents: .date)
                        //                        .padding()
                        //                        .background(Color.gray.opacity(0.2))
                        //                        .cornerRadius(16)
                        
                        
                        Text("School")
                            .font(.headline)
                        TextField("Highschool...", text: $school)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(16)
                        
                        
                        Text("Graduation Date")
                            .font(.headline)
                        //                    DatePicker("Graduation Date", selection: $gradDate, displayedComponents: .date)
                        //                        .padding()
                        //                        .background(Color.gray.opacity(0.2))
                        //                        .cornerRadius(16)
                    }
                }
                .padding()
            }
        }
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        }
    }


#Preview {
    AddUser()
}
