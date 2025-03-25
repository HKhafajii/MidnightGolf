import SwiftUI

struct SearchView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var searchText: String = ""
    @State var didCheckIn: Bool = false
    
    private var filteredStudents: [Student] {
        if searchText.isEmpty {
            return viewModel.students
        } else {
            return viewModel.students.filter { student in
                student.first.localizedCaseInsensitiveContains(searchText)
                || student.last.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Check In")
                .font(.custom("NeueMontreal-Regular", size: CheckInScreen.deviceWidth * 0.03))
                .shadow(radius: 16, x: 0, y: 5)
                .fontWeight(.bold)
                .foregroundStyle(Color("MGPnavy"))
                .transition(.move(edge: .bottom).combined(with: .opacity))
            
            TextField("Search...", text: $searchText)
                .font(.custom("NeueMontreal-Regular", size: CheckInScreen.deviceWidth * 0.015))
                .frame(maxWidth: CheckInScreen.deviceWidth / 1.5)
                .padding()
                .background(RoundedRectangle(cornerRadius: 20).fill(.ultraThinMaterial))
                .shadow(radius: 8, x: 0, y: 8)
                .submitLabel(.done)
            
            if !searchText.isEmpty {
                List(filteredStudents) { student in
                    HStack {
                        Text(student.first + " " + student.last)
                            .font(.custom("NeueMontreal-Regular", size: CheckInScreen.deviceWidth * 0.015))
                            .foregroundStyle(Color("MGPnavy"))
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Button {
                            Task {
                                await viewModel.checkInOutStudent(student)
                                await viewModel.loadAllStudents()
                                didCheckIn = true
                            }
                        } label: {
                            Text("Check \(student.isCheckedIn ? "Out" : "In")")
                                .font(.custom("NeueMontreal-Regular", size: CheckInScreen.deviceWidth * 0.015))
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 20).fill(Color("MGPyellow")))
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .alert(isPresented: $didCheckIn) {
                        Alert(
                            title: Text("Check In/Out"),
                            message: Text("Checked in \(student.first + " " + student.last)"),
                            dismissButton: .cancel {
                                didCheckIn = false
                            }
                        )
                    }
                }
                .padding()
                .listStyle(.plain)
                .presentationCornerRadius(20)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.4), value: filteredStudents)
    }
    
    func getStudent(name: String) -> Student? {
        for student in viewModel.students {
            if student.first + " " + student.last == name {
                return student
            }
        }
        return nil
    }
}

#Preview {
    NavigationStack {
        SearchView()
            .environmentObject(ViewModel())
    }
}



