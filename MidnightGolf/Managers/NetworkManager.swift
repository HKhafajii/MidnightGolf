//
//  NetworkManager.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 11/11/24.
//

import Foundation


final class NetworkManager: ObservableObject {
    
    static let shared = NetworkManager()
    
    @Published var students: [Student] = []
    
    
    func request() {
        guard let url = URL(string: "") else {
            print("API URL is not available")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("API request error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([Student].self, from: data)
                DispatchQueue.main.async {
                    self.students = decodedData
                    print("Data successfully received")
                }
                
            } catch let decodingError {
                print("Error Decoding: \(decodingError.localizedDescription)")
            }
            
        }.resume()
    } // End of Request
    
    func postAccount() {
//        guard let url = URL(string: "") else {
//            print("API URL is not available")
//            return
//        }
        
//        var studentData =  SET EQUAL FROM VIEWMODEL
        
    }
    
    
}
