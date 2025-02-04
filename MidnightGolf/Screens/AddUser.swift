import SwiftUI
import CoreImage.CIFilterBuiltins

struct AddUser: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @State var firstN: String = ""
    @State var lastN: String = ""
    
    @Binding var showAddStudentSheet: Bool
  
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                
                //                TODO: Make the background work properly
                //                Image("bg")
                //                    .resizable()
                //                    .scaledToFill()
                //                    .ignoresSafeArea()
                
                VStack(spacing: 15) {
                    
                    AddUserTextFields( showAddStudentSheet: $showAddStudentSheet )
                    
                    
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
    AddUser(showAddStudentSheet: .constant(false))
        .environmentObject(ViewModel())
}

struct AddUserTextFields: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var birthDate: Date = Date()
    @State var school: String = ""
    @State var gradDate: Date = Date()
    @Binding var showAddStudentSheet: Bool
    
    @EnvironmentObject var viewModel: ViewModel
    @State var qrCodeManager =  QRCodeManager()
    
    var body: some View {
        
        VStack {
            
            Text("First name")
                .font(.headline)
            TextField("First name...", text: $firstName)
                .padding()
                .frame(maxWidth: CheckInScreen.deviceWidth / 2)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(16)
            
            
            Text("Last name")
                .font(.headline)
            TextField("Last name...", text: $lastName)
                .padding()
                .frame(maxWidth: CheckInScreen.deviceWidth / 2)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(16)
            
            
            
            Text("Date of Birth")
                .font(.headline)
            DatePicker("Date of Birth", selection: $birthDate, displayedComponents: .date)
                .padding()
                .frame(maxWidth: CheckInScreen.deviceWidth / 2)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(16)
            
            
            Text("School")
                .font(.headline)
            TextField("Highschool...", text: $school)
                .padding()
                .frame(maxWidth: CheckInScreen.deviceWidth / 2)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(16)
            
            
            Text("Graduation Date")
                .font(.headline)
            DatePicker("Graduation Date", selection: $gradDate, displayedComponents: .date)
                .padding()
                .frame(maxWidth: CheckInScreen.deviceWidth / 2)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(16)
            
            Button {
                
                let qrCodeText = firstName + lastName
                
                Task {
                    do {
                        try await viewModel.firestoreManager.postUser(
                            first: firstName,
                            last: lastName,
                            born: birthDate,
                            school: school,
                            gradDate: gradDate,
                            qrCode: qrCodeText
                        )
                    }
                }
                showAddStudentSheet = false
            } label: {
                Text("Add User")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                    .frame(maxWidth: CheckInScreen.deviceWidth / 2.1)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color("blue")))
                    .shadow(radius: 8, x: 0, y: 8)
            }
            .padding()
        }
    }
}
