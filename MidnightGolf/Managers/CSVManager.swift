//
//  CSVViewModel.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 4/26/25.
//

import SwiftUI
import SwiftCSV

class CSVManager: ObservableObject {
    @Published var csvData: String = ""
    @Published var headers: [String] = []
    @Published var rows: [[String]] = []
    @Published var students: [Student] = []
    
    
    func parseCSV(content: String) {
        do {
          // 1. Parse into a CSV<Named> (header → keys)
          let csv = try CSV<Named>(string: content, delimiter: .comma)
          
          // 2. Pull out the array of row-dictionaries
          let namedRows: [[String:String]] = csv.rows
          
          // 3. Turn each dictionary into a Student
          mapRowsToStudents(namedRows)
          
        } catch {
          print("CSV parsing failed:", error)
        }
      }
      
      private func mapRowsToStudents(_ rows: [[String:String]]) {
        var parsed: [Student] = []
        
        for row in rows {
          guard
            let id         = row["id"],
            let first      = row["first"],
            let last       = row["last"],
            let born       = row["born"],
            let isMaleStr  = row["isMale"],
            let cell       = row["cellNumber"],
            let email      = row["email"],
            let cohortStr  = row["cohort"],
            let school     = row["school"],
            let gradDate   = row["gradDate"],
            let qrCode     = row["qrCode"]
          else {
            // skip any malformed row
            continue
          }
          
          let student = Student(
            id:         id,
            first:      first,
            last:       last,
            born:       born,
            isMale:     (isMaleStr.lowercased() == "true"),
            cellNumber: cell,
            email:      email,
            cohort:     (cohortStr.lowercased() == "true"),
            school:     school,
            gradDate:   gradDate,
            qrCode:     qrCode
          )
          parsed.append(student)
        }
        
        
        DispatchQueue.main.async {
          self.students = parsed
        }
      }
    
    func handleFileImport(for result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            
            readFile(url)
            
        case .failure(let error):
            print("error loading file\(error)")
        }
    }
    
            func readFile(_ url: URL) {
                guard url.startAccessingSecurityScopedResource() else {return}
                do {
                    let content = try String(contentsOf: url, encoding: .utf8)
                    parseCSV(content: content)
                } catch {
                    print(error)
                }
                
                url.stopAccessingSecurityScopedResource()
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

    
}
