//
//  MyTableViewCell.swift
//  TOG
//
//  Created by 이상준 on 5/17/24.
//

import UIKit
import SnapKit
import Then

final class MyTableViewCell: UITableViewCell {
    
    static let identifier = "MyTableViewCell"
    
    private let bubbleView = UIImageView().then {
        $0.image = UIImage(named: "my_bubble")
    }
    
    private let messageTextView = UITextView().then {
        $0.textColor = .white
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.isUserInteractionEnabled = true
        $0.isEditable = false
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
        $0.textContainerInset = .zero
        $0.textContainer.lineFragmentPadding = 0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true
        
        [bubbleView, messageTextView].forEach {
            contentView.addSubview($0)
        }
        
        messageTextView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-32)
            $0.bottom.equalToSuperview().offset(-22)
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
    
    func setMessage(content: String) {
        messageTextView.text = content
    }
}
