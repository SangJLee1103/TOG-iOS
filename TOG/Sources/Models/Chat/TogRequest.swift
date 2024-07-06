//
//  TogRequest.swift
//  TOG
//
//  Created by 이상준 on 3/24/24.
//

import Foundation

struct TogRequest: Encodable {
    let model: String
    let messages: [Message]
    let stream: Bool
    
    init(model: String = "gpt-4o", messages: [Message], stream: Bool = true) {
        self.model = model
        self.messages = messages
        self.stream = stream
    }
}
