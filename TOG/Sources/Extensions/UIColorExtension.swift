//
//  UIColorExtension.swift
//  TOG
//
//  Created by 이상준 on 4/29/24.
//

import UIKit

extension UIColor {
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }

    class var grey1: UIColor {
        return UIColor(hex: 0xF8F8F8)
    }
    
    class var grey2: UIColor {
        return UIColor(hex: 0xDEDEDE)
    }
    
    class var grey5: UIColor {
        return UIColor(hex: 0x919191)
    }
    
    class var grey3: UIColor {
        return UIColor(hex: 0xC4C4C4)
    }
    
    class var grey4: UIColor {
        return UIColor(hex: 0xABABAB)
    }
    
    class var grey7: UIColor {
        return UIColor(hex: 0x5F5F5F)
    }
    
    class var togBlack1: UIColor {
        return UIColor(hex: 0x1C1C1C)
    }
    
    class var togBlack2: UIColor {
        return UIColor(hex: 0x121212)
    }
    
    class var togPurple: UIColor {
        return UIColor(hex: 0x6000D1)
    }
    
    class var togPurple10: UIColor {
        return UIColor(hex: 0xF2E8FF)
    }
    
    class var togPurple50: UIColor {
        return UIColor(hex: 0x9840FF)
    }
    
    class var togChatColor: UIColor {
        return UIColor(hex: 0xF5F5F5)
    }
    
    class var myChatColor: UIColor {
        return UIColor(hex: 0x9A81F3)
    }
    
    class var linkColor: UIColor {
        return UIColor(hex: 0x19A0FF)
    }
}
