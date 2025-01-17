//
//  FirebaseManager.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 11/21/24.
//
import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class FirestoreManager: ObservableObject {
    
    // Singleton Instance
    static let shared = FirestoreManager()
    
    //    ------ Variables ---------
    @Published var mailHelper = MailHelper()
    @Published var student: Student?
    @Published var students: [Student] = []
    @Published var names: [String] = []
    @Published private(set) var studentQRCodes: Set<String> = []
    
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
    
    
    //    ------ REQUESTS ---------
    
    
    func postUser(first: String, last: String, born: Date, school: String, gradDate: Date, qrCode: Data) async {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let birthDateString = dateFormatter.string(from: born)
        let gradDateString = dateFormatter.string(from: gradDate)
        
        let qrCodebase64 = qrCode.base64EncodedString()
        
        
        do {
            let ref = try await userCollection.addDocument(data:
                                                            [
                                                                "first" : first,
                                                                "last" : last,
                                                                "born" : birthDateString,
                                                                "school" : school,
                                                                "gradDate" : gradDateString,
                                                                "qrCode" : qrCodebase64
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
        let qrCode = data["qrCode"] as? Data ?? Data()
        
        return Student(id: userId, first: first, last: last, born: born, school: school, gradDate: gradDate, qrCode: qrCode)
        
    } // End of GetUser
    
    func fetchAllUsers() async {
        do {
            let snapshot = try await userCollection.getDocuments()
            
            let fetchedStudents = snapshot.documents.compactMap { doc -> Student? in
                let data = doc.data()
                
                let first = data["first"] as? String ?? "Unknown"
                let last = data["last"] as? String ?? "Unknown"
                let born = data["born"] as? String ?? "Unknown"
                let school = data["school"] as? String ?? "Not Specified"
                let gradDate = data["gradDate"] as? String ?? "Unknown"
                let qrCodeBase64 = data["qrCode"] as? String ?? ""
                
                let qrCodeData = Data(base64Encoded: qrCodeBase64) ?? Data()
                
                return Student(
                    id: doc.documentID,
                    first: first,
                    last: last,
                    born: born,
                    school: school,
                    gradDate: gradDate,
                    qrCode: qrCodeData
                )
            }
            
            print("Parsed Students: \(fetchedStudents)")
            
            DispatchQueue.main.async {
                self.students = fetchedStudents
                
                self.studentQRCodes = Set(fetchedStudents.compactMap { student in
                    String(data: student.qrCode, encoding: .utf8)
                })
            }
        } catch {
            print("Error fetching users: \(error.localizedDescription)")
        }
    } // End of Fetch all users
    
    func getNames() -> [String] {
        
        var names: [String] = []
        
        for student in students {
            names.append(student.first + " " + student.last)
        }
        return names
    } // end of getNames
    
    func fetchQRCode(for documentID: String, completion: @escaping (UIImage?) -> Void) {
        
    }
    
    //    ------ END OF REQUESTS ---------
    
}

