//
//  TermsViewController.swift
//  TOG
//
//  Created by 이상준 on 4/30/24.
//

import UIKit
import RxSwift
import RxCocoa

final class TermsViewController: BaseViewController {
    private let viewModel: TermsViewModel
    private let completion: () -> Void
    
    private lazy var leftBarButton = UIBarButtonItem(image: UIImage(named: "nav_left"), style: .plain, target: self, action: #selector(popVC))
    
    private lazy var allAgreeView = TermsRequiredView().then {
        $0.setTitle(title: "모두동의")
        $0.isHiddenDetailButton(isHidden: true)
    }
    
    private lazy var requiredFirstView = TermsRequiredView().then {
        $0.delegate = self
        $0.setTitle(title: "이용 약관(필수)")
        $0.isHiddenSeperatorView(isHidden: true)
    }
    
    private lazy var requiredSecondView = TermsRequiredView().then {
        $0.delegate = self
        $0.setTitle(title: "개인정보 수집 및 이용에 대한 동의(필수)")
        $0.isHiddenSeperatorView(isHidden: true)
    }
    
    private lazy var notRequiredThirdView = TermsRequiredView().then {
        $0.delegate = self
        $0.setTitle(title: "마케팅 정보 수집에 대한 동의(선택)")
        $0.isHiddenSeperatorView(isHidden: true)
    }
    
    private lazy var requiredFourthView = TermsRequiredView().then {
        $0.setTitle(title: "만 14세 이상입니다(필수)")
        $0.isHiddenSeperatorView(isHidden: true)
        $0.isHiddenDetailButton(isHidden: true)
    }
    
    private lazy var confirmButton = TogButton().then {
        $0.title = "동의하고 시작하기"
        $0.isActive = false
        $0.addTarget(self, action: #selector(didTapAgreeButton), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureUI()
        bind()
    }
    
    init(viewModel: TermsViewModel, completion: @escaping() -> Void) {
        self.viewModel = viewModel
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNavBar() {
        title = "이용 약관"
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .white
        navigationBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.togBlack1,
            .font: UIFont(name: "Pretendard-Bold", size: 16)!
        ]
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.leftBarButtonItem?.tintColor = .togBlack1
    }
    
    private func configureUI() {
        let stackView = UIStackView(arrangedSubviews: [allAgreeView, requiredFirstView, requiredSecondView, notRequiredThirdView, requiredFourthView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        
        [allAgreeView, requiredFirstView, requiredSecondView, notRequiredThirdView, requiredFourthView].forEach {
            $0.setHeight(48)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(20)
            $0.leading.trailing.equalTo(safeArea)
        }
        
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(safeArea).inset(16)
        }
        
        requiredFirstView.setDetailContent(url: "http://ec2-3-106-213-74.ap-southeast-2.compute.amazonaws.com/info/terms", title: "이용약관")
        requiredSecondView.setDetailContent(url: "http://ec2-3-106-213-74.ap-southeast-2.compute.amazonaws.com/info/service", title: "개인정보 처리방침")
        notRequiredThirdView.setDetailContent(url: "http://ec2-3-106-213-74.ap-southeast-2.compute.amazonaws.com/info/marketing", title: "마케팅 정보 수집 동의")
    }
    
    private func bind() {
        Observable<TermsButtonType>.merge([
            allAgreeView.rx.tapGesture().map { _ in .allAgree },
            requiredFirstView.rx.tapGesture().map { _ in .requiredFirst },
            requiredSecondView.rx.tapGesture().map { _ in .requiredSecond },
            notRequiredThirdView.rx.tapGesture().map { _ in .notRequiredThird },
            requiredFourthView.rx.tapGesture().map { _ in .requiredFourth },
        ])
        .bind(to: viewModel.input.buttonTapped)
        .disposed(by: rx.disposeBag)
        
        viewModel.nextButtonEnabled
            .bind(to: confirmButton.rx.isActive)
            .disposed(by: rx.disposeBag)
        
        // TermsRequiredView imgView 처리
        allAgreeView.bind(to: viewModel.allAgreeIsSelected.asObservable())
        requiredFirstView.bind(to: viewModel.requiredFirstIsSelected.asObservable())
        requiredSecondView.bind(to: viewModel.requiredSecondIsSelected.asObservable())
        notRequiredThirdView.bind(to: viewModel.notRequiredThirdIsSelected.asObservable())
        requiredFourthView.bind(to: viewModel.requiredFourthIsSelected.asObservable())
    }
    
    @objc func didTapAgreeButton() {
        self.completion()
        self.dismiss(animated: true)
    }
}

extension TermsViewController: TermsViewDelegate {
    func showDetailContent(url: String?, title: String?) {
        guard let urlString = url, let navTitle = title else {
            print("Invalid URL or Title")
            return
        }
        let webViewController = TogWebViewController(navTitle: navTitle, url: urlString)
        showFullScreenNavigationView(webViewController)
    }
}
