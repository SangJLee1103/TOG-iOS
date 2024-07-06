//
//  ChatRoom.swift
//  TOG
//
//  Created by 이상준 on 4/4/24.
//

import Firebase

struct ChatRoom {
    let chatRoomId: String
    let userId: String
    let title: String
    let createdAt: Timestamp
    
    init(data: [String: Any]) {
        self.chatRoomId = data["chatRoomId"] as? String ?? ""
        self.userId = data["userId"] as? String ?? ""
        self.title = data["title"] as? String ?? ""
        self.createdAt = data["createdAt"] as? Timestamp ?? Timestamp(date: Date())
    }
}
