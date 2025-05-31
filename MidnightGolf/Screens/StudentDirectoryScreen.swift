import SwiftUI

struct StudentDirectoryScreen: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var showAddStudentSheet = false

    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    StudentDirectoryHeaderView()
                        .environmentObject(viewModel)
                        .padding(.leading)
                        .padding(.top, 20)
                    
                    Divider()
                    
                    List(viewModel.students) { student in
                        NavigationLink {
                            AttendanceTabScreen(student: student, filters: ["Today", "Weekly", "Monthly"])
                                .environmentObject(viewModel)
                        } label: {
                            StudentRow(student: student)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .padding([.leading, .trailing], 10)
                }
            }
        }
    }
}

#Preview {
    StudentDirectoryScreen()
        .environmentObject(ViewModel())
}

struct StudentDirectoryHeaderView: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        HStack {
            Text("Student Directory")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
            Spacer()
//            Text("Records")
//                .font(.title3)
//                .fontWeight(.semibold)
//                .foregroundStyle(Color("MGPnavy"))
//            
//            ShareLink(item: viewModel.generateCSVFile()) {
//                Label("Attendance Records", systemImage: "list.bullet.rectangle.portrait")
//                    .fontWeight(.semibold)
//            }
            
          
            NavigationLink {
                RecordsTabScreen()
                    .environmentObject(viewModel)
            } label: {
                
                HStack {
                    Text("Records Log")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("MGPnavy"))
                    
                    Image(systemName: "list.bullet.rectangle.portrait")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("MGPnavy"))
                        .padding(.trailing)
                }
                
            }

            
            Spacer()
            
            NavigationLink {
                AdminSettingsScreen()
            } label: {
                
                HStack {
                    Text("Attendance Settings")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("MGPnavy"))
                    
                    Image(systemName: "gear")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("MGPnavy"))
                        .padding(.trailing)
                }
                
            }
        }
        .padding(.top, 20)
    }
}


struct StudentRow: View {
    let student: Student

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.black)
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text("\(student.first) \(student.last)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                if !student.school.isEmpty {
                    Text("School: \(student.school)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                if !student.gradDate.isEmpty {
                    Text("Grad: \(student.gradDate)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }

            Spacer()

       
            if let qrCodeImage = student.qrCodeImage() {
                Image(uiImage: qrCodeImage)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding(5)
            } else {
                Text("QR Not Found")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
