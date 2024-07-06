//
//  ChatMessage.swift
//  TOG
//
//  Created by 이상준 on 3/28/24.
//

import Foundation

struct ChatMessage {
    let id: String  // 고유 ID
    let sender: String
    var content: String
    
    init(sender: String, content: String) {
        self.id = UUID().uuidString
        self.sender = sender
        self.content = content
    }
}
