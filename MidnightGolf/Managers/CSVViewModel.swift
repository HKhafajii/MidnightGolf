//
//  CSVViewModel.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 4/26/25.
//

import SwiftUI
import SwiftCSV

class CSVViewModel: ObservableObject {
    @Published var csvData: String = ""
    @Published var headers: [String] = []
    @Published var rows: [[String]] = []
    
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
                    self.csvData = content
                    print(content)
                } catch {
                    print(error)
                }
                
                url.stopAccessingSecurityScopedResource()
            }
    
    func parseCSV(content: String) {
        do {
            let data = try EnumeratedCSV(string: content, loadColumns: false)
            headers = data.header
            rows = data.rows
        } catch {
            print(error)
        }
    }
    
}
