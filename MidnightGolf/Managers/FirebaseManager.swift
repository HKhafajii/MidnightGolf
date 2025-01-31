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
    

    @Published var student: Student?
    @Published var students: [Student] = []
    @Published private(set) var studentQRCodes: Set<String> = []
    
    @Published var isLoadingStudents = false
    
     let db = Firestore.firestore()
    
    private var userCollection: CollectionReference {
          db.collection("users")
      }
      
      private var attendanceCollection: CollectionReference {
          db.collection("attendance")
      }
    
    
    
   
    
    
    //    ------ REQUESTS ---------
    
    func postAttendance(_ attendance: Attendance) async throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(attendance), let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw URLError(.cannotParseResponse)
        }
        try await attendanceCollection.addDocument(data: dictionary)
        print("Attendance posted")
    } // End of postAttendance()
    
    
//    func fetchAttendance(for studentID: String) async throws -> [Attendance] {
//        let snapshot = try await attendanceCollection.whereField("studentID", isEqualTo: studentID).getDocuments()
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601
//        return snapshot.documents.compactMap { document in
//            guard let data = try? JSONSerialization.data(withJSONObject: document.data()),
//                  let attendance = try? decoder.decode(Attendance.self, from: data) else {
//                return nil
//            }
//            return attendance
//        }
//    } // End of fetchAttendance()
    
    
    func postUser(first: String, last: String, born: Date, school: String, gradDate: Date, qrCode: Data) async throws {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let birthDateString = dateFormatter.string(from: born)
        let gradDateString = dateFormatter.string(from: gradDate)
        
        let qrCodebase64 = qrCode.base64EncodedString()
        
        let studentID = UUID().uuidString
        do {
            try await userCollection.document(studentID).setData([
                    "id": studentID,
                    "first": first,
                    "last": last,
                    "born": birthDateString,
                    "school": school,
                    "gradDate": gradDateString,
                    "qrCode": qrCodebase64,
                    "isCheckedIn": false
                ])
            
        } catch {
            print("Error adding document: \(error)")
        }
        print("Added")
        
    } // End of Post request
    
    
    func getUser(userId: String) async throws -> Student {
        
        let snapshot = try await userCollection.document(userId).getDocument()
        
        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        let first = data["first"] as? String ?? ""
        let last = data["last"] as? String ?? ""
        let group = data["group"] as? String ?? ""
        let school = data["school"] as? String ?? ""
        let gradDate = data["graduationDate"] as? String ?? ""
        let born = data["born"] as? String ?? ""
        let qrCode = data["qrCode"] as? Data ?? Data()
        
        return Student(id: userId, group: group, first: first, last: last, born: born, school: school, gradDate: gradDate, qrCode: qrCode)
        
    } // End of GetUser
    
    @MainActor
    func fetchAllUsers() async throws -> [Student] {
        isLoadingStudents = true
        defer { isLoadingStudents = false }
        
        
            let snapshot = try await userCollection.getDocuments()
            
            let fetchedStudents = snapshot.documents.compactMap { doc -> Student? in
                let data = doc.data()
                
                let studentId = doc.documentID
                let first = data["first"] as? String ?? "Unknown"
                let last = data["last"] as? String ?? "Unknown"
                let group = data["group"] as? String ?? "Unkown"
                let born = data["born"] as? String ?? "Unknown"
                let school = data["school"] as? String ?? "Not Specified"
                let gradDate = data["gradDate"] as? String ?? "Unknown"
                let qrCodeBase64 = data["qrCode"] as? String ?? ""
                
                let qrCodeData = Data(base64Encoded: qrCodeBase64) ?? Data()
                
                return Student(
                    id: studentId,
                    group: group,
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
                self.studentQRCodes = Set(fetchedStudents.compactMap { student in
                    student.qrString()
                })
                
            }
        return fetchedStudents
            
                    
    } // End of Fetch all users
    
    
  
    
    func updateStudentStatus(studentID: String, isCheckedIn: Bool) async throws {
        
        try await userCollection.document(studentID).updateData(["isCheckedIn" : isCheckedIn])
      } // End of updateStudentStatus()
      
    
    @MainActor
      func getAttendanceHistory(studentID: String) async throws -> [Attendance] {
          
          let snapshot = try await db.collection("attendance")
              .whereField("studentID", isEqualTo: studentID)
              .order(by: "timeIn", descending: true)
              .getDocuments()
          
          return try snapshot.documents.map { document in
              return try document.data(as: Attendance.self)
          }
          
      } // End of getAttendanceHistory()
    
    
    func createAttendance(_ attendance: Attendance) async throws {
        let docRef = attendanceCollection.document()
        var newAttendance = attendance
        
        try docRef.setData(from: newAttendance)
    }
    
    func updateAttendance(_ attendanceID: String, fields: [String: Any]) async throws {
           try await attendanceCollection.document(attendanceID).updateData(fields)
       }
    
    func fetchAttendance(for studentID: String) async throws -> [Attendance] {
         let snapshot = try await attendanceCollection
             .whereField("studentID", isEqualTo: studentID)
             .order(by: "timeIn", descending: true)
             .getDocuments()
         
         return snapshot.documents.compactMap { try? $0.data(as: Attendance.self) }
     }
     
     
     func fetchOpenAttendance(for studentID: String) async throws -> Attendance? {
         let snapshot = try await attendanceCollection
             .whereField("studentID", isEqualTo: studentID)
             .whereField("timeOut", isEqualTo: NSNull())
             .limit(to: 1)
             .getDocuments()
         
         return snapshot.documents.compactMap { try? $0.data(as: Attendance.self) }.first
     }
    //    ------ END OF REQUESTS ---------
    
}

