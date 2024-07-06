//
//  SwitchTableViewCell.swift
//  TOG
//
//  Created by 이상준 on 4/16/24.
//

import UIKit
import SnapKit

final class SwitchTableViewCell: UITableViewCell {
    
    static let identifier = "SwitchTableViewCell"
    
    var viewModel: SettingsViewModel? {
        didSet {
            configure()
        }
    }
    
    private let imgView = UIImageView().then {
        $0.tintColor = .black
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 15)
    }
    
    private let hapticSwitch = UISwitch()
    
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
        
        [imgView, titleLabel, hapticSwitch].forEach {
            contentView.addSubview($0)
        }
        
        imgView.snp.makeConstraints {
            $0.width.height.equalTo(25)
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(imgView.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
        
        hapticSwitch.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        imgView.image = UIImage(systemName: viewModel.imgName)
        titleLabel.text = viewModel.title
        
        if viewModel.isLast {
            imgView.tintColor = .red
            titleLabel.textColor = .red
        }
    }
    
    
}
