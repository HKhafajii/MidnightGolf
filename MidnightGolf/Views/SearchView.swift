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
                List(filteredStudents, id: \.self) { student in
                    
                
                    HStack {
                        Text(student.first + " " + student.last)
                            .font(.custom("NeueMontreal-Regular", size: CheckInScreen.deviceWidth * 0.015))

                            
                            .fontWeight(.semibold)
                        Spacer()
                        
                        Button {
                            Task { await viewModel.checkInOutStudent(student)
                            }
                        } label: {
                            Text("Check \(student.isCheckedIn ? "Out" : "In")")
                                .font(.custom("NeueMontreal-Regular", size: CheckInScreen.deviceWidth * 0.015))

//                                .font(.headline)
//                                .foregroundStyle(Color.white)
//                                .fontWeight(.semibold)
//                                .padding()
//                                .background(Capsule().fill(Color("blue")))
                                .padding()
                            
                        }

                        
                    }
                        
                    }
                    
                    .listStyle(PlainListStyle())
                } else {
                    
                }
            }
            
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
    
    
    struct ProfileView: View {
        
        let student: Student
        
        var body: some View {
            
            VStack(alignment: .leading) {
                
                Text(student.first + " " + student.last)
                    .font(.headline)
                Text("School: \(student.school)")
                Text("Graduation Date: \(student.gradDate)")
                Text("Student Group: \(student.group)")
                Text("Born: \(student.born)")
                Text("Checked In?: \(student.isCheckedIn ? "Yes" : "No")")
                
            }
        }
    }
