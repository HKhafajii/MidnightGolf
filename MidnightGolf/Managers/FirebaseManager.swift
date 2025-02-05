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
            let docRef = attendanceCollection.document(attendance.id)
               
               var docData: [String: Any] = [
                   "id": attendance.id,
                   "studentID": attendance.studentID,
                   "isCheckedIn": attendance.isCheckedIn,
                   "isLate": attendance.isLate,
                   "totalTime": attendance.totalTime
               ]

               docData["timeIn"] = attendance.timeIn ?? FieldValue.serverTimestamp()

               if let out = attendance.timeOut {
                   docData["timeOut"] = out
               } else {
                   docData["timeOut"] = NSNull()
               }
               
               try await docRef.setData(docData)
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
    
    
    func postUser(first: String, last: String, born: Date, school: String, gradDate: Date, qrCode: String) async throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let birthDateString = dateFormatter.string(from: born)
        let gradDateString = dateFormatter.string(from: gradDate)
        let studentID = UUID().uuidString
        
        if let qrCodeImage = QRCodeManager().generateQRCode(from: qrCode), let qrCodeData = qrCodeImage.pngData() {
            let qrCodeBase64 = qrCodeData.base64EncodedString()
            do {
                try await userCollection.document(studentID).setData([
                    "id": studentID,
                    "first": first,
                    "last": last,
                    "born": birthDateString,
                    "school": school,
                    "gradDate": gradDateString,
                    "qrCode": qrCodeBase64,
                    "isCheckedIn": false
                ])
                print("Successfully added student with QR content: \(qrCode)")
            } catch {
                print("Error adding document: \(error)")
            }
        }
        
        
       
    } // End of Post request
    
    
//    func getUser(userId: String) async throws -> Student {
//        
//        let snapshot = try await userCollection.document(userId).getDocument()
//        
//        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
//            throw URLError(.badServerResponse)
//        }
//        
//        let first = data["first"] as? String ?? ""
//        let last = data["last"] as? String ?? ""
//        let group = data["group"] as? String ?? ""
//        let school = data["school"] as? String ?? ""
//        let gradDate = data["graduationDate"] as? String ?? ""
//        let born = data["born"] as? String ?? ""
//        let qrCode = data["qrCode"] as? Data ?? Data()
//        
//        return Student(id: userId, group: group, first: first, last: last, born: born, school: school, gradDate: gradDate, qrCode: qrCode)
//        
//    } // End of GetUser
    
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
            let group = data["group"] as? String ?? "Unknown"
            let born = data["born"] as? String ?? "Unknown"
            let school = data["school"] as? String ?? "Not Specified"
            let gradDate = data["gradDate"] as? String ?? "Unknown"
            let qrCodeText = data["qrCode"] as? String ?? ""

            

            return Student(
                id: studentId,
                group: group,
                first: first,
                last: last,
                born: born,
                school: school,
                gradDate: gradDate,
                qrCode: qrCodeText
            )
        }

        

        return fetchedStudents
    } // End of FetchAllUsers
    
    
  
    
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
        let newAttendance = attendance
        try docRef.setData(from: newAttendance)
    }
    
    func updateAttendance(_ attendanceID: String, fields: [String: Any]) async throws {
        
        let docRef = attendanceCollection.document(attendanceID)
        print("Updating the attendance record for: ", attendanceID, fields)
        
        try await docRef.updateData(fields)
        
//           try await attendanceCollection.document(attendanceID).updateData(fields)
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
            .whereField("studentID", isEqualTo: studentID) // Fetch all records for this student
            .getDocuments() // Get all documents to check what's being returned

        // Print all documents returned for debugging
        print("Firestore returned \(snapshot.documents.count) attendance records for student:", studentID)

        for document in snapshot.documents {
            let data = document.data()
            print("Document ID:", document.documentID, "Data:", data)
        }

        // Now filter to find an open attendance record (where timeOut is null)
        let openAttendance = snapshot.documents.compactMap { document -> Attendance? in
            let data = document.data()
            
            let timeIn = data["timeIn"] as? Timestamp
            let timeOut = data["timeOut"] as? Timestamp

            if timeOut == nil {
                print("Found open attendance record:", document.documentID)
                return Attendance(
                    id: document.documentID,
                    studentID: data["studentID"] as? String ?? "",
                    timeIn: timeIn?.dateValue(),
                    timeOut: timeOut?.dateValue(),
                    isCheckedIn: data["isCheckedIn"] as? Bool ?? false,
                    isLate: data["isLate"] as? Bool ?? false,
                    totalTime: data["totalTime"] as? Double ?? 0
                )
            } else {
                print("Skipping closed attendance record:", document.documentID, "timeOut:", timeOut?.dateValue() ?? "nil")
                return nil
            }
        }.first

        print("Final fetched open attendance:", openAttendance?.id ?? "None found")
        
        return openAttendance
    }
    //    ------ END OF REQUESTS ---------
    
}

