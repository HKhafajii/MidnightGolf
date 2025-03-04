import SwiftUI
import CoreImage.CIFilterBuiltins

struct AddUser: View {
    @EnvironmentObject var viewModel: ViewModel
    @Binding var showAddStudentSheet: Bool

    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height

            NavigationStack {
                ZStack {
                    Image("bg")
                        .resizable()
                        .scaledToFill()
                        .frame(width: screenWidth, height: screenHeight)
                        .ignoresSafeArea()

                    VStack(spacing: 15) {
                        
                        Text("Let's Add a Student!")
                            .font(.title)
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                            .frame(maxWidth: CheckInScreen.deviceWidth / 2.5,
                                   maxHeight: CheckInScreen.deviceHeight * 0.05)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 24).fill(Color("MGPnavy")))
                            .shadow(radius: 8, x: 0, y: 0)
                        
                        AddUserTextFields(showAddStudentSheet: $showAddStudentSheet)
                    }
                    .padding()
                }
            }
            .ignoresSafeArea()
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
        .ignoresSafeArea()
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
    @State var cellNumber: String = ""
    @State var email: String = ""
    @State var isMale: Bool = true
    @State var cohort: Bool = true
    
    @Binding var showAddStudentSheet: Bool

    @EnvironmentObject var viewModel: ViewModel
    @State var qrCodeManager = QRCodeManager()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
             
                Text("First name")
                    .font(.headline)
                TextField("First name...", text: $firstName)
                    .padding()
                    .frame(maxWidth: CheckInScreen.deviceWidth / 2)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(16)
                
             
                Text("Last name")
                    .font(.headline)
                TextField("Last name...", text: $lastName)
                    .padding()
                    .frame(maxWidth: CheckInScreen.deviceWidth / 2)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(16)
                
               
                Text("Date of Birth")
                    .font(.headline)
                HStack {
                    Text("Date of Birth")
                    Spacer()
                    DatePicker("", selection: $birthDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .tint(.mgPblue)
                        .overlay {
                            ZStack {
                                Color.mgPblue
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .cornerRadius(10)
                                Text(birthDate.formatted(date: .abbreviated, time: .omitted))
                                    .foregroundColor(.white)
                            }
                            .allowsHitTesting(false)
                        }
                }
                .padding()
                .frame(maxWidth: CheckInScreen.deviceWidth / 2)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(16)
                
               
                Text("School")
                    .font(.headline)
                TextField("Highschool...", text: $school)
                    .padding()
                    .frame(maxWidth: CheckInScreen.deviceWidth / 2)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(16)
                
               
                Text("Graduation Date")
                    .font(.headline)
                HStack {
                    Text("Graduation Date")
                    Spacer()
                    DatePicker("", selection: $gradDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .tint(.mgPnavy)
                        .overlay {
                            ZStack {
                                Color.mgPblue
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .cornerRadius(10)
                                Text(gradDate.formatted(date: .abbreviated, time: .omitted))
                                    .foregroundColor(.white)
                            }
                            .allowsHitTesting(false)
                        }
                }
                .padding()
                .frame(maxWidth: CheckInScreen.deviceWidth / 2)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(16)
                
               
                Text("Cell Number")
                    .font(.headline)
                TextField("Cell Number...", text: $cellNumber)
                    .padding()
                    .frame(maxWidth: CheckInScreen.deviceWidth / 2)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(16)
                
                
                Text("Email")
                    .font(.headline)
                TextField("Email...", text: $email)
                    .padding()
                    .frame(maxWidth: CheckInScreen.deviceWidth / 2)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(16)
                
              
                Text("Gender")
                    .font(.headline)
                Picker("Gender", selection: $isMale) {
                    Text("Male").tag(true)
                    Text("Female").tag(false)
                }
                .shadow(radius: 12, x: 0, y: 0)
                .pickerStyle(SegmentedPickerStyle())
                .frame(maxWidth: 200)
                .padding()
                
            
                Text("Cohort")
                    .font(.headline)
                Picker("Cohort", selection: $cohort) {
                    Text("Tue/Thu").tag(true)
                    Text("Mon/Wed").tag(false)
                }
                .shadow(radius: 12, x: 0, y: 0)
                .pickerStyle(SegmentedPickerStyle())
                .frame(maxWidth: 200)
                .padding()
                
              
                Button {
                    Task {
                        await viewModel.postUser(
                            first: firstName,
                            last: lastName,
                            born: birthDate,
                            school: school,
                            gradDate: gradDate,
                            cellNum: cellNumber,
                            email: email,
                            gender: isMale,
                            cohort: cohort
                        )
                    }
                    showAddStudentSheet = false
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("MGPnavy"))
                            .frame(maxWidth: CheckInScreen.deviceWidth / 2.5,
                                   maxHeight: CheckInScreen.deviceHeight * 0.05)
                            .shadow(radius: 8, x: 0, y: 0)
                        
                        Text("Add User")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: CheckInScreen.deviceWidth / 2.5)
                    }
                }
                .padding()
                .padding(.top)
            }
        }
    }
}
