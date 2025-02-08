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
    
    @Published var students: [Student] = []
    @Published private(set) var studentQRCodes: Set<String> = []
    
    @Published var isLoadingStudents = false
    @Published var isLoadingAttendance = false
    
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

        return  fetchedStudents.sorted { $0.last.localizedCaseInsensitiveCompare($1.last) == .orderedAscending }
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
    } // End of createAttendance
    
    func updateAttendance(_ attendanceID: String, fields: [String: Any]) async throws {
        
        let docRef = attendanceCollection.document(attendanceID)
        print("Updating the attendance record for: ", attendanceID, fields)
        
        try await docRef.updateData(fields)
        
//           try await attendanceCollection.document(attendanceID).updateData(fields)
       } // End of updateAttendance
    
    func fetchAttendance(for studentID: String) async throws -> [Attendance] {
         let snapshot = try await attendanceCollection
             .whereField("studentID", isEqualTo: studentID)
             .order(by: "timeIn", descending: true)
             .getDocuments()
         
         return snapshot.documents.compactMap { try? $0.data(as: Attendance.self) }
     } // End of fetchAttendance
     
     
    func fetchOpenAttendance(for studentID: String) async throws -> Attendance? {
        let snapshot = try await attendanceCollection
            .whereField("studentID", isEqualTo: studentID)
            .getDocuments()

        
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
                
                return nil
            }
        }.first
        
        return openAttendance
    } // End of fetchOpenAttendance
    
    @MainActor
    func fetchAllAttendance() async throws -> [Attendance] {
        isLoadingAttendance = true
        defer { isLoadingAttendance = false }

        let snapshot = try await attendanceCollection.getDocuments()

        let fetchedAttendance = snapshot.documents.compactMap { doc -> Attendance? in
            let data = doc.data()

            guard let studentID = data["studentID"] as? String else { return nil }
            let id = doc.documentID
            let timeIn = (data["timeIn"] as? Timestamp)?.dateValue()
            let timeOut = (data["timeOut"] as? Timestamp)?.dateValue()
            let totalTime = data["totalTime"] as? Double ?? 0
            let isCheckedIn = data["isCheckedIn"] as? Bool ?? false
            let isLate = data["isLate"] as? Bool ?? false

            return Attendance(
                id: id,
                studentID: studentID,
                timeIn: timeIn,
                timeOut: timeOut,
                isCheckedIn: isCheckedIn,
                isLate: isLate,
                totalTime: totalTime
            )
        }

        return fetchedAttendance
    }
    
    //    ------ END OF REQUESTS ---------
    
}

