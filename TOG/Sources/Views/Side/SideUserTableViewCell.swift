//
//  SideUserTableViewCell.swift
//  TOG
//
//  Created by 이상준 on 4/3/24.
//

import UIKit
import SnapKit
import Then
import Firebase
import SDWebImage

protocol SideUserTableViewCellDelegate: class {
    func didTapMoreButton()
}

final class SideUserTableViewCell: UITableViewCell {
    
    static let identifier = "SideUserTableViewCell"
    weak var delegate: SideUserTableViewCellDelegate?
    
    private let userImgView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.tintColor = .black
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 35 / 2
        $0.image = UIImage(named: "user_profile")
    }
    
    private let userNameLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Bold", size: 16)
    }
    
    private let moreButton = UIButton().then {
        $0.setImage(UIImage(named: "setting"), for: .normal)
        $0.tintColor = .systemGray2
        $0.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(userImgView)
        userImgView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10).priority(.high)
              $0.bottom.equalToSuperview().inset(10).priority(.high)
              $0.leading.equalToSuperview().offset(15)
              $0.width.height.equalTo(35)
        }
        
        contentView.addSubview(moreButton)
        moreButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        contentView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints {
            $0.leading.equalTo(userImgView.snp.trailing).offset(10)
            $0.trailing.equalTo(moreButton.snp.leading).offset(-20)
            $0.centerY.equalToSuperview()
        }
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        guard let user = UserManager.shared.user else { return }
        userNameLabel.text = user.displayName
        
        if (user.photoUrl != "") {
            userImgView.sd_setImage(with: URL(string: user.photoUrl))
        } else {
            userImgView.image = UIImage(named: "user_profile")
        }
    }
    
    @objc private func didTapMoreButton() {
        delegate?.didTapMoreButton()
    }
}
