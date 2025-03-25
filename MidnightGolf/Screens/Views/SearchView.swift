import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var searchText: String = ""
    
    
    
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
            
            TextField("Search...", text: $searchText)
                .font(.custom("NeueMontreal-Regular", size: CheckInScreen.deviceWidth * 0.015))
            
                .frame(maxWidth: CheckInScreen.deviceWidth / 1.5)
                .padding()
                .background(Capsule().fill(.ultraThinMaterial))
                .shadow(radius: 8, x: 0, y: 8)
            
            
            
            if !searchText.isEmpty {
                
                List(filteredStudents) { student in
                    
                    
                    HStack {
                        Text(student.first + " " + student.last)
                            .font(.custom("NeueMontreal-Regular", size: CheckInScreen.deviceWidth * 0.015))
                            .fontWeight(.semibold)
                        Text(student.isCheckedIn ? "Checked In" : "Checked Out")
                        
                        Spacer()
                        
                        Button {
                            Task { await viewModel.checkInOutStudent(student)
                                    
                                await viewModel.loadAllStudents()
                            }
                        } label: {
                            Text("Check \(student.isCheckedIn ? "Out" : "In")")
                                .font(.custom("NeueMontreal-Regular", size: CheckInScreen.deviceWidth * 0.015))
                            
                            
                                .padding()
                            
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    
                }
                .padding()
                .listStyle(PlainListStyle())
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



