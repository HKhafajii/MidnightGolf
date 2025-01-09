//
//  UserManager.swift
//  MidnightGolf
//
//  Created by Hassan Alkhafaji on 1/6/25.
//


import Foundation
import FirebaseFirestore
import FirebaseAuth


class UserManager {
    
    func createUser(auth: AuthDataResult) {
        var user: [String:Any] = [
            "user_id" : auth.user.uid,
            "is_anonymous" : auth.user.isAnonymous,
            "created_at" : FieldValue.serverTimestamp()
        ]
        
        if let email = auth.user.email {
            user["email"] = email
        }
        Firestore.firestore().collection("users").document(auth.user.uid).setData(user, merge: false)
        
    }
    
}
