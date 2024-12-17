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
    @Published var mailHelper = MailHelper()
    @Published var student: Student?
    @Published var students: [Student] = []
    
    private let userCollection = db.collection("users")
    
    private func userDocument(uuid: String) -> DocumentReference {
        userCollection.document(uuid)
    }

    
    init(mailHelper: MailHelper = MailHelper(), students: [Student]) {
        self.mailHelper = mailHelper
//        self.students = students
//        self.student = student
    }
    
    // Default Constructor
  
    init() { }
    
//    ------ REQUESTS ---------
    
    
    func postUser(first: String, last: String, born: Int) async {
        do {
            let ref = try await userCollection.addDocument(data:
                [
                "first" : first,
                "last" : last,
                "born" : born
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
        let gradDate = data["graduationDate"] as? Int ?? 0
        let born = data["born"] as? Int ?? 0
        
        return Student(id: userId, first: first, last: last, born: born, school: school, gradDate: gradDate)
        
    }
    
    func createNewUser(user: Student) async throws {
//        try await userDocument(uuid: auth.uid)
    }
}

