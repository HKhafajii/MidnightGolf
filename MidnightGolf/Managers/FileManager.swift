//
//  FileManager.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 2/26/25.
//

import Foundation


class CSVManager {
    
    
    func generateCSV(students: [Student]) -> URL {
        
        var fileURL: URL!
        let heading = "Student Attendance"
        let rows = students.map { "\($0.first)"}
        let stringData = heading + rows.joined(separator: "\n")
        
        do {
            
            let path = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)

            fileURL = path.appendingPathExtension("Student-Attendance-Data.csv")
        
            try stringData.write(to: fileURL, atomically: true, encoding: .utf8)
            print(fileURL)
            
        } catch {
            print("Error generating the csv file")
        }
        
        return fileURL
    }
    
}
