//
//  User.swift
//  TOG
//
//  Created by 이상준 on 4/4/24.
//

import Firebase

struct User {
    let uid: String
    let displayName: String
    let email: String
    let photoUrl: String
    let createdAt: Timestamp
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.displayName = data["displayName"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.photoUrl = data["photoUrl"] as? String ?? ""
        self.createdAt = data["createdAt"] as? Timestamp ?? Timestamp(date: Date())
    }
}
