//
//  MentorModel.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 3/18/25.
//

import Foundation


struct Mentor: Identifiable {
    
    let id: String
    let name: String
    var students: [Student]
    
    // TODO: Later when making the iphone application, make sure to implement more capabilities for a Mentor
    
}
