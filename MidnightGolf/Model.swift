//
//  Model.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 11/11/24.
//

import Foundation

struct Student: Identifiable, Codable {
    let id: String
    let first: String
    let last: String
    let born: Int
    let school: String
    let gradDate: Int
    
//    var school: String
//    var graduationDate: Int
}


//let first = data["first"] as? String ?? ""
//let last = data["last"] as? String ?? ""
//let born = data["born"] as? Int ?? 0
//
//return Student(userId: userId, first: first, last: last, born: born)

