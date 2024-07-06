//
//  OpenAiRouter.swift
//  TOG
//
//  Created by 이상준 on 3/24/24.
//

import Alamofire
import RxSwift

enum ChatRouter: URLRequestConvertible {
    
    case fetchTogMessage(messages: [Message])
    
    var path: String {
        switch self {
        case .fetchTogMessage:
            return "/chat/completions"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchTogMessage:
            return .post
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try URL(string: ApiConstant.baseURL.absoluteString
            .asURL()
            .appendingPathComponent(path)
            .absoluteString
            .removingPercentEncoding!)
        
        var request = URLRequest(url: url!)
        request.httpMethod = method.rawValue
        
        switch self {
        case .fetchTogMessage(let messages):
            let apiKey = Bundle.main.infoDictionary?["API_KEY"] as! String
            let togRequest = TogRequest(messages: messages)
            
            print(apiKey)
            
            do {
                // URLRequest에 JSONEncoder를 사용하여 TogRequest를 JSON으로 인코딩하고 바디에 설정
                let jsonData = try JSONEncoder().encode(togRequest)
                request.httpBody = jsonData
                request.addValue("application/json", forHTTPHeaderField: "Content-Type") // JSON 타입 명시
                request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return request
    }
}
