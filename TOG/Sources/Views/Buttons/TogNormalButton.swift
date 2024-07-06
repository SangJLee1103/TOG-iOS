//
//  TogNormalButton.swift
//  TOG
//
//  Created by 이상준 on 5/14/24.
//

import UIKit

final class TogNormalButton: UIButton {
    
    var title: String = "" {
        didSet {
            setTitle(title, for: .normal)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setHeight(56)
        clipsToBounds = true
        backgroundColor = .white
        layer.cornerRadius = 6
        layer.borderWidth = 1
        layer.borderColor = UIColor.grey2.cgColor
        titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 16)
        setTitleColor(.grey4, for: .normal)
    }
}

