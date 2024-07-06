//
//  TermsButton.swift
//  TOG
//
//  Created by 이상준 on 4/30/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

protocol TermsViewDelegate: class {
    func showDetailContent(url: String?, title: String?)
}

final class TermsRequiredView: UIView {
    
    weak var delegate: TermsViewDelegate?
    let disposeBag = DisposeBag()
    
    var detailUrl: String?
    var detailTitle: String?
    
    private let checkImgView = UIImageView().then {
        $0.image = UIImage(named: "not_check")
        $0.setDimensions(height: 24, width: 24)
    }
    
    private let seperatorView = UIView().then {
        $0.setHeight(1)
        $0.backgroundColor = .grey2
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Regular", size: 16)
        $0.textColor = .black
    }
    
    private let detailButton = UIButton().then {
        $0.setTitle("보기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.titleLabel?.textColor = .grey7
        $0.setUnderline()
        $0.addTarget(self, action: #selector(didTapDetailButton), for: .touchUpInside)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setHeight(48)
        
        [checkImgView, titleLabel, detailButton, seperatorView].forEach { addSubview($0) }
        
        checkImgView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.bottom.equalToSuperview().inset(12)
        }
        
        detailButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(checkImgView.snp.trailing).offset(14)
            $0.trailing.equalTo(detailButton.snp.leading).offset(-14)
        }
        
        seperatorView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
    
    func bind(to observable: Observable<Bool>) {
        observable
            .map { $0 ? UIImage(named: "check") : UIImage(named: "not_check") }
            .bind(to: checkImgView.rx.image)
            .disposed(by: disposeBag)
    }
    
    func isHiddenSeperatorView(isHidden: Bool) {
        seperatorView.isHidden = isHidden
    }
    
    func isHiddenDetailButton(isHidden: Bool) {
        detailButton.isHidden = isHidden
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func setDetailContent(url: String, title: String) {
        self.detailUrl = url
        self.detailTitle = title
    }
    
    @objc func didTapDetailButton() {
        delegate?.showDetailContent(url: detailUrl, title: detailTitle)
    }
}
