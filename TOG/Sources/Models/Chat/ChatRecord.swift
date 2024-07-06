//
//  ChatRecord.swift
//  TOG
//
//  Created by 이상준 on 4/4/24.
//

import Firebase

struct ChatRecord {
    let chatId: String
    let chatRoomId: String
    let question: String
    let answer: String
    let createdAt: Timestamp
    
    init(data: [String: Any]) {
        self.chatId = data["chatId"] as? String ?? ""
        self.chatRoomId = data["chatRoomId"] as? String ?? ""
        self.question = data["question"] as? String ?? ""
        self.answer = data["answer"] as? String ?? ""
        self.createdAt = data["createdAt"] as? Timestamp ?? Timestamp(date: Date())
    }
}
