//
//  FirebaseManager.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 11/21/24.
//
import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth



class FirestoreManager: ObservableObject {
    static let shared = FirestoreManager()
    
    //    @Published var resources: [Resource] = []
    
    //    ------ Variables ---------
    @Published var mailHelper = MailHelper()
    @Published var student: Student?
    @Published var students: [Student] = []
    @Published var names: [String] = []
    
    private var userCollection: CollectionReference
    
    private func userDocument(uuid: String) -> DocumentReference {
        
        userCollection.document(uuid)
    }
    
    
    init(mailHelper: MailHelper = MailHelper(), students: [Student] = []) {
        self.mailHelper = mailHelper
        self.userCollection = Firestore.firestore().collection("users")
        names = getNames()
        Task {
            await fetchAllUsers()
        }
    }
    
    // Default Constructor
    
    
    
    //    ------ REQUESTS ---------
    
    
    func postUser(first: String, last: String, born: Date, school: String, gradDate: Date) async {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let birthDateString = dateFormatter.string(from: born)
        let gradDateString = dateFormatter.string(from: gradDate)
        
        do {
            let ref = try await userCollection.addDocument(data:
                                                            [
                                                                "first" : first,
                                                                "last" : last,
                                                                "born" : birthDateString,
                                                                "school" : school,
                                                                "gradDate" : gradDateString
                                                            ])
            print("Document added with ID: \(ref.documentID)")
        } catch {
            print("Error adding document: \(error)")
        }
        print("Added")
        
    } // End of Post request
    
    func getUser(userId: String) async throws -> Student {
        
        let snapshot = try await userDocument(uuid: userId).getDocument()
        
        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        let first = data["first"] as? String ?? ""
        let last = data["last"] as? String ?? ""
        let school = data["school"] as? String ?? ""
        let gradDate = data["graduationDate"] as? String ?? ""
        let born = data["born"] as? String ?? ""
        
        return Student(id: userId, first: first, last: last, born: born, school: school, gradDate: gradDate)
        
    }
    
    func fetchAllUsers() async {
        do {
            let snapshot = try await userCollection.getDocuments()
            
            // Print the raw documents received from Firestore
            print("Fetched Documents: \(snapshot.documents)")
            
            let fetchedStudents = snapshot.documents.compactMap { doc -> Student? in
                let data = doc.data()
                
                // Print each document's data for debugging
                print("Document ID: \(doc.documentID), Data: \(data)")
                
                let first = data["first"] as? String ?? "Unknown"
                let last = data["last"] as? String ?? "Unknown"
                let born = data["born"] as? String ?? "Unknown"
                let school = data["school"] as? String ?? "Not Specified"
                let gradDate = data["graduationDate"] as? String ?? "Unknown"
                
                return Student(id: doc.documentID, first: first, last: last, born: born, school: school, gradDate: gradDate)
            }
            
            // Print parsed Student objects
            print("Parsed Students: \(fetchedStudents)")
            
            DispatchQueue.main.async {
                FirestoreManager.shared.students = fetchedStudents
            }
        } catch {
            print("Error fetching users: \(error.localizedDescription)")
        }
    }
    
    func getNames() -> [String] {
        
        var names: [String] = []
        
        for student in students {
            names.append(student.first + " " + student.last)
        }
        return names
    }
    
    //    ------ END OF REQUESTS ---------
    
}

