//
//  SettingsViewModel.swift
//  TOG
//
//  Created by 이상준 on 4/14/24.
//

import UIKit

struct SettingsViewModel {
    private let setting: Setting
    
    var imgName: String {
        return setting.imgName
    }
    
    var title: String {
        return setting.title
    }
    
    var desc: String {
        return setting.desc
    }
    
    var isLast: Bool {
        return setting.isLast
    }
    
    var isAccesory: Bool {
        return setting.isAccessory
    }
    
    init(setting: Setting) {
        self.setting = setting
    }
}
