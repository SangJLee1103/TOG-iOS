//
//  SideChatHistoryTableViewCell.swift
//  TOG
//
//  Created by 이상준 on 4/3/24.
//

import UIKit
import SnapKit
import Then

protocol SideChatHistoryTableViewCellDelegate: class {
    func didTapDeleteButton(at indexPath: IndexPath)
    func didTapChatRoom(at indexPath: IndexPath)
}

final class SideChatHistoryTableViewCell: UITableViewCell {
    
    static let identifier = "SideChatHistoryTableViewCell"
    
    weak var delegate: SideChatHistoryTableViewCellDelegate?
    
    var indexPath: IndexPath?
    
    private lazy var titleLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapChatRoom))
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tap)
    }
    
    private lazy var deleteButton = UIButton().then {
        $0.setImage(UIImage(named: "trash"), for: .normal)
        $0.tintColor = .darkGray
        $0.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(deleteButton.snp.leading).offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    @objc func didTapDeleteButton() {
        if let indexPath = self.indexPath {
            delegate?.didTapDeleteButton(at: indexPath)
        }
    }
    
    @objc func didTapChatRoom() {
        if let indexPath = self.indexPath {
            delegate?.didTapChatRoom(at: indexPath)
        }
    }
}
