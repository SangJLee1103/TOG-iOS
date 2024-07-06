//
//  LoginButton.swift
//  TOG
//
//  Created by 이상준 on 4/29/24.
//

import UIKit

enum LoginType {
    case google
    case apple
}

final class LoginButton: UIButton {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setHeight(58)
        clipsToBounds = true
        layer.cornerRadius = 6
        layer.borderWidth = 1
        layer.borderColor = UIColor.grey3.cgColor
        titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 16)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6)
        imageView?.contentMode = .scaleAspectFill
        adjustsImageWhenHighlighted = false
    }
    
    func setStyle(type: LoginType, title: String) {
        setTitle(title, for: .normal)
        setTitleColor(.togBlack1, for: .normal)
        switch type {
        case .google:
            setImage(UIImage(named: "google"), for: .normal)
        case .apple:
            setImage(UIImage(named: "apple"), for: .normal)
        }
    }
}
