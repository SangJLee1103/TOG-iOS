//
//  TogButton.swift
//  TOG
//
//  Created by 이상준 on 5/2/24.
//

import UIKit

enum TogButtonType {
    case active
    case inActive
}

final class TogButton: UIButton {
    
    var title: String = "" {
        didSet {
            setTitle(title, for: .normal)
        }
    }
    
    var isActive: Bool = false {
        didSet {
            isActive ? setStyle(type: .active) : setStyle(type: .inActive)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setHeight(56)
        clipsToBounds = true
        layer.cornerRadius = 6
        layer.borderColor = UIColor.grey3.cgColor
        titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 16)
        setTitleColor(.white, for: .normal)
    }
    
    private func setStyle(type: TogButtonType) {
        switch type {
        case .active:
            isEnabled = true
            backgroundColor = .togPurple
        case .inActive:
            isEnabled = false
            backgroundColor = .togPurple10
        }
    }
}
