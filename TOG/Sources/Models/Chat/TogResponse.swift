//
//  Message.swift
//  TOG
//
//  Created by 이상준 on 3/24/24.
//

import Foundation

struct TogResponse: Codable {
    let id: String
    let choices: [TogStreamChoice]
}

struct TogStreamChoice: Codable {
    let delta: TogStreamContent
    let finishReason: String?
    
    enum CodingKeys: String, CodingKey {
        case delta
        case finishReason = "finish_reason"
    }
}

struct TogStreamContent: Codable {
    let content: String?
}

struct Message: Codable {
    let role: String
    let content: String
}
