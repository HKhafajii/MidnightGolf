import SwiftUI

struct SearchView: View {
    // Mock data to search through
    let allItems = [
        "Apple", "Banana", "Cherry", "Date", "Eggfruit",
        "Fig", "Grapefruit", "Honeydew", "Jackfruit", "Kiwi"
    ]
    
    @State private var searchText: String = ""
    
    // Filtered results based on search text
    var filteredItems: [String] {
        guard !searchText.isEmpty else { return [] } // Return empty until typing begins
        return allItems.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        VStack {
            // Simple text field for searching
            TextField("Search...", text: $searchText)
                .font(.title3)
                .frame(maxWidth: CheckInScreen.deviceWidth / 1.5)
                .padding()
                .background(Capsule().fill(.ultraThinMaterial))
                .shadow(radius: 8, x: 0, y: 8)
            
            // Only show the list if there is search text
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
                // You can also show a placeholder or empty view here if you want
                // For example:
                // Text("Start typing to see results...")
                //     .foregroundColor(.gray)
            }
        }
        
//        ProfileView(someString: "", fireStoreManager: FirestoreManager())
    }
}

#Preview {
    SearchView()
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
