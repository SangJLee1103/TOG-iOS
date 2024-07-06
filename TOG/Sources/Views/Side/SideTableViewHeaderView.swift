//
//  SideTableViewHeaderView.swift
//  TOG
//
//  Created by 이상준 on 4/3/24.
//

import UIKit
import SnapKit
import Then

final class SideTableViewHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "SideTableViewHeaderView"
    
    private let lineView = UIView().then {
        $0.backgroundColor = .grey2
    }
    
    private let dayLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Bold", size: 12)
        $0.textColor = .grey5
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(1)
        }
        
        contentView.addSubview(dayLabel)
        dayLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(title: String) {
        dayLabel.text = title
    }
}
