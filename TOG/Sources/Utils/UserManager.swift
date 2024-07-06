//
//  UserManager.swift
//  TOG
//
//  Created by 이상준 on 5/9/24.
//

import Foundation

final class UserManager {
    static let shared = UserManager()
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            print("DEBUG: UserManager init", user)
        }
    }
    
    init() {}
    
    func resetUserInfo() {
        user = nil
    }
}
