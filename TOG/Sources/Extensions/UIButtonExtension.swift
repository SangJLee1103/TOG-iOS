//
//  UIButtonExtension.swift
//  TOG
//
//  Created by 이상준 on 5/1/24.
//

import UIKit

extension UIButton {
    // MARK: - UIButton Title Underline
    func setUnderline() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: title.count)
        )
        setAttributedTitle(attributedString, for: .normal)
    }
}
