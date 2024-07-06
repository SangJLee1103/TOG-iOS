//
//  SettingsTableViewCell.swift
//  TOG
//
//  Created by 이상준 on 4/13/24.
//

import UIKit
import SnapKit
import Then

final class SettingsTableViewCell: UITableViewCell {
    
    static let identifier = "SettingsTableViewCell"
    
    var viewModel: SettingsViewModel? {
        didSet {
            configure()
        }
    }
    
    private let imgView = UIImageView().then {
        $0.tintColor = .black
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .togBlack2
    }
    
    private let descLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.textAlignment = .right
        $0.textColor = .togPurple50
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func configureUI() {
        contentView.clipsToBounds = true
        selectionStyle = .none
        
        [imgView, titleLabel, descLabel].forEach {
            contentView.addSubview($0)
        }
        
        imgView.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(imgView.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
        
        descLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(30)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        imgView.image = UIImage(named: viewModel.imgName)
        titleLabel.text = viewModel.title
        descLabel.text = viewModel.desc
        
        if !viewModel.isAccesory {
            accessoryView = nil
        }
        
        if viewModel.isLast {
            titleLabel.textColor = .grey4
        }
    }
}
