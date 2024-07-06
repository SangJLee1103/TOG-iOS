//
//  Setting.swift
//  TOG
//
//  Created by 이상준 on 4/16/24.
//

import Foundation

struct Setting {
    let imgName: String
    let title: String
    let desc: String
    let isLast: Bool
    let isAccessory: Bool
    
    init(imgName: String, title: String, desc: String, isLast: Bool, isAccessory: Bool) {
        self.imgName = imgName
        self.title = title
        self.desc = desc
        self.isLast = isLast
        self.isAccessory = isAccessory
    }
}
