//
//  TogAlertViewController.swift
//  TOG
//
//  Created by 이상준 on 5/14/24.
//

import UIKit

enum AlertType {
    case leave
    case error
}

protocol TogLeaveDelegate: class {
    func isSuccessLeave()
}

final class TogAlertViewController: BaseViewController {
    
    weak var delegate: TogLeaveDelegate?
    private let type: AlertType
    private let titleLabel = UILabel().then {
        $0.textColor = .togBlack2
        $0.textAlignment = .center
        $0.font = UIFont(name: "Pretendard-Bold", size: 18)
    }
    
    private let imgView = UIImageView().then {
        $0.setDimensions(height: 76, width: 76)
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 76 / 2
    }
    
    private let descLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.textColor = .grey7
        $0.font = UIFont(name: "Pretendard-Regular", size: 16)
    }
    
    private let cancelButton = TogButton().then {
        $0.title = "취소"
        $0.isActive = true
        $0.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
    }
    
    private let confirmButton = TogButton().then {
        $0.title = "확인"
        $0.isActive = true
        $0.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
    }
    
    private let leaveButton = TogNormalButton().then {
        $0.title = "탈퇴"
    }
    
    init(type: AlertType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let presentationController = presentationController as? UISheetPresentationController {
            let customDtent = UISheetPresentationController.Detent.custom { context in
                return 320.0
            }
            presentationController.detents = [customDtent]
        }
        configureUI(type)
        bind()
    }
    
    private func configureUI(_ type: AlertType) {
        [titleLabel, imgView, descLabel].forEach {
            view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.centerX.equalToSuperview()
        }
        
        imgView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(22)
            $0.centerX.equalToSuperview()
        }
        
        descLabel.snp.makeConstraints {
            $0.top.equalTo(imgView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        switch type {
        case .leave:
            let stackView = UIStackView(arrangedSubviews: [cancelButton, leaveButton])
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 11
            
            view.addSubview(stackView)
            stackView.snp.makeConstraints {
                $0.top.equalTo(descLabel.snp.bottom).offset(26)
                $0.leading.trailing.equalToSuperview().inset(24)
                $0.bottom.equalToSuperview().inset(40)
            }
            
            titleLabel.text = "토그를 탈퇴하시겠어요?"
            imgView.image = UIImage(named: "cry_tog")
            descLabel.text = "서비스 탈퇴 시 생성했던 모든 대화방이 사라지며,\n참여했던 모든 대화방이 사라집니다."
        case .error:
            view.addSubview(confirmButton)
            confirmButton.snp.makeConstraints {
                $0.top.equalTo(descLabel.snp.bottom).offset(26)
                $0.leading.trailing.equalToSuperview().inset(24)
                $0.bottom.equalToSuperview().inset(40)
            }
            
            titleLabel.text = "오류가 발생했습니다."
            imgView.image = UIImage(named: "alert")
            descLabel.text = "서비스 이용에 불편을 드려 죄송합니다.\n잠시 후 다시 이용해 주세요."
        }
    }
    
    private func bind() {
        leaveButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true) {
                    self?.delegate?.isSuccessLeave()
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    static func showErrorAlert(on viewController: UIViewController) {
        let alertVC = TogAlertViewController(type: .error)
        viewController.present(alertVC, animated: true)
    }
}
