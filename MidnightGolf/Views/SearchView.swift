import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var searchText: String = ""
    
    var filteredItems: [String] {
        guard !searchText.isEmpty else { return [] }
        return viewModel.names.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        VStack {
            
            TextField("Search...", text: $searchText)
                .font(.title3)
                .frame(maxWidth: CheckInScreen.deviceWidth / 1.5)
                .padding()
                .background(Capsule().fill(.ultraThinMaterial))
                .shadow(radius: 8, x: 0, y: 8)
            
            
            if !searchText.isEmpty {
                List(filteredItems, id: \.self) { item in
                    NavigationLink {
//                        ProfileView(someString: item)
                    } label: {
                        Text(item)
                            .font(.headline)
                            .fontWeight(.semibold)
                    }

                }
                
                .listStyle(PlainListStyle())
            } else {
                
            }
        }
        
//        ProfileView(someString: "", fireStoreManager: FirestoreManager())
    }
}

#Preview {
    SearchView()
        .environmentObject(ViewModel())
}


//struct ProfileView: View {
//    
//    @State var someString: String
//    @StateObject var fireStoreManager = FirestoreManager.shared
//    
//    var body: some View {
//        
//        VStack {
//            List(fireStoreManager.students) { student in
//                VStack(alignment: .leading) {
//                    
//                    Text(student.first + " " + student.last)
//                        .font(.headline)
//                    Text("School: \(student.school)")
//                    Text("Graduation Date: \(student.graduationDate)")
//                    
//                }
//            }
//            .task {
//                await fireStoreManager.get(collection: "users")
//                print("Students: \(fireStoreManager.students)")
//            }
//        }
//        
//        Text(someString)
//            .font(.headline)
//            .fontWeight(.semibold)
//    }
//}
