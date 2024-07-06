//
//  ChatTextView.swift
//  TOG
//
//  Created by 이상준 on 3/28/24.
//

import UIKit
import SnapKit

final class ChatTextView: UITextView, UITextViewDelegate {
    
    var heightConstraint: NSLayoutConstraint?
    
    var placeholder: String = "토그에게 무엇이든 물어보세요." {
        didSet {
            if text.isEmpty {
                text = placeholder
                textColor = .grey5
            }
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        delegate = self
        if text.isEmpty {
            text = placeholder
            textColor = .grey5
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textColor == .grey5 {
            text = nil
            textColor = .togBlack2
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if text.isEmpty {
            text = placeholder
            textColor = .grey5
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = sizeThatFits(CGSize(width: frame.width, height: .infinity))
        let newHeight = size.height
        if newHeight <= 110 {
            heightConstraint?.constant = newHeight
            isScrollEnabled = false
        } else {
            isScrollEnabled = true
        }
        superview?.layoutIfNeeded()
    }
    
    func resetUI() {
        text = ""
        heightConstraint?.constant = 35
    }
}
