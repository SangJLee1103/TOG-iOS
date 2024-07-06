//
//  ApiConstant.swift
//  TOG
//
//  Created by 이상준 on 3/24/24.
//

import Foundation

struct ApiConstant {
    static var baseURL: URL {
        return URL(string: "https://api.openai.com/v1")!
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}
