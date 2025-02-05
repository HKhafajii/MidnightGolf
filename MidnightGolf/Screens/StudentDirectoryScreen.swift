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

                VStack {
                    Text("Student Directory")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top, 20)

                    List(viewModel.students) { student in
                        NavigationLink {
                            AttendanceView(student: student)
                                .environmentObject(viewModel)
                        } label: {
                            StudentRow(student: student)
                                
                        }
                    }
                    .listStyle(PlainListStyle())
                    .padding([.leading, .trailing], 10)
                }
                .toolbar {
                    Button("Add Person", systemImage: "plus") {
                        showAddStudentSheet = true
                    }
                    .sheet(isPresented: $showAddStudentSheet) {
                        AddUser(showAddStudentSheet: $showAddStudentSheet)
                            .environmentObject(viewModel)
                    }
                }
            }
        }
    }
}

#Preview {
    StudentDirectoryScreen()
        .environmentObject(ViewModel())
}

#Preview {
    StudentDirectoryScreen()
        .environmentObject(ViewModel())
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
