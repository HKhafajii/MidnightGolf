//
//  CSVViewModel.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 4/26/25.
//

import SwiftUI
import SwiftCSV



final class CSVManager: ObservableObject {


    func loadStudents(from url: URL) async throws -> [Student] {
      

        guard url.startAccessingSecurityScopedResource() else {
   
            throw CocoaError(.fileReadNoPermission)
        }
        defer { url.stopAccessingSecurityScopedResource() }

  
        let rawData = try Data(contentsOf: url)
  
        let csvString = String(decoding: rawData, as: UTF8.self)
       


        return try await Task.detached(priority: .userInitiated) {
            let parsed = try self.parseStudents(csvString)
           
            return parsed
        }.value
    }


    func generateCSV(students: [Student]) -> URL {
        
        var fileURL: URL!
        let heading = "Student Attendance"
        let rows = students.map { "\($0.first)"}
        let stringData = heading + rows.joined(separator: "\n")
        
        do {
            
            let path = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            fileURL = path.appendingPathExtension("Student-Attendance-Data.csv")
            try stringData.write(to: fileURL, atomically: true, encoding: .utf8)
            
        } catch {
            print("Error generating the csv file")
        }
        
        return fileURL
    }

    private func parseStudents(_ content: String) throws -> [Student] {
        let csv = try CSV<Named>(string: content, delimiter: .comma)

        return csv.rows.compactMap { rawRow in
           
            let row = Dictionary(uniqueKeysWithValues:
                rawRow.map { ($0.key.lowercased(), $0.value) })

            guard
                let first = row["first"], !first.isEmpty,
                let last  = row["last"],  !last.isEmpty,
                let born  = row["born"],
                let cell  = row["cellnumber"],
                let email = row["email"],
                let school = row["school"],
                let gradDate = row["graddate"]
            else { return nil }
            let id = row["id"] ?? UUID().uuidString
            let isMale = row["ismale"]?.lowercased() == "true"
            let cohort = row["cohort"]?.lowercased() == "true"
            let qrText = row["qrcode"] ?? (first + last)

            return Student(id: id,
                           first: first,
                           last: last,
                           born: born,
                           isMale: isMale,
                           cellNumber: cell,
                           email: email,
                           cohort: cohort,
                           school: school,
                           gradDate: gradDate,
                           qrCode: qrText)
        }
    }
}
