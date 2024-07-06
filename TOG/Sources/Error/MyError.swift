//
//  MyError.swift
//  TOG
//
//  Created by 이상준 on 4/4/24.
//

import Foundation

public enum MyError: Error {
    case unknown // 알 수 없는 오류
    case unauthorized // 인증 실패 오류
    case notFound // 찾을 수 없음
}

extension MyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknown: return NSLocalizedString("unknown error occred", comment: "unknown")
        case .unauthorized: return NSLocalizedString("Authorization issue. Please restart the app.", comment: "unauthorized")
        case .notFound: return NSLocalizedString("Data Not Found", comment: "not found")
        }
    }
}
