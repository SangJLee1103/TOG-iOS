//
//  ChatTableViewCell.swift
//  TOG
//
//  Created by 이상준 on 3/28/24.
//

import UIKit
import SnapKit
import Then
import MarkdownKit

final class TogTableViewCell: UITableViewCell, UITextViewDelegate {
    
    static let identifier = "TogTableViewCell"
    
    private let markdownParser = MarkdownParser(font: UIFont(name: "Pretendard-Regular", size: 14)!)
    
    private let bubbleView = UIImageView().then {
        $0.image = UIImage(named: "tog_bubble")
    }
    
    private let iconView = UIImageView().then {
        $0.image = UIImage(named: "tog_chat")
        $0.clipsToBounds = true
        $0.setDimensions(height: 40, width: 40)
    }
    
    private let nameLabel = UILabel().then {
        $0.textColor = .togBlack2
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.numberOfLines = 1
        $0.text = "토그"
    }
    
    private let messageTextView = UITextView().then {
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.textAlignment = .left
        $0.dataDetectorTypes = .link
        $0.isUserInteractionEnabled = true
        $0.isEditable = false
        $0.isScrollEnabled = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.textContainerInset = .zero
        $0.textContainer.lineFragmentPadding = 0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true
        
        messageTextView.delegate = self
        
        [bubbleView, iconView, nameLabel, messageTextView].forEach {
            contentView.addSubview($0)
        }
        
        iconView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.leading.equalToSuperview().offset(16)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(iconView.snp.trailing).offset(7)
        }
        
        messageTextView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(14)
            $0.leading.equalTo(iconView.snp.trailing).offset(23)
            $0.bottom.equalToSuperview().offset(-20)
            $0.width.lessThanOrEqualTo(250)
        }
        
        bubbleView.snp.makeConstraints {
            $0.top.equalTo(messageTextView.snp.top).offset(-10)
            $0.trailing.equalTo(messageTextView.snp.trailing).offset(16)
            $0.bottom.equalTo(messageTextView.snp.bottom).offset(10)
            $0.leading.equalTo(messageTextView.snp.leading).offset(-16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageTextView.text = nil
    }
    
    func setMessage(message: String) {
        let attributedString = markdownParser.parse(message)
        messageTextView.attributedText = attributedString
        contentView.layoutIfNeeded()
    }
    
    func appendMessage(_ text: String) {
        let currentText = messageTextView.attributedText?.string ?? ""
        let newText = currentText + text
        let attributedString = markdownParser.parse(newText)
        messageTextView.attributedText = attributedString
    }
}
