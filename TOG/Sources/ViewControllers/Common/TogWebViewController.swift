//
//  TogWebViewController.swift
//  TOG
//
//  Created by 이상준 on 5/3/24.
//

import UIKit
import WebKit

final class TogWebViewController: BaseViewController {
    
    var webView = WKWebView()
    
    private let navTitle: String
    private let url: String
    
    private let bottomView = UIView()
    private let confirmButton = TogButton().then {
        $0.title = "확인"
        $0.isActive = true
    }
    
    init(navTitle: String, url: String) {
        self.navTitle = navTitle
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureWebView()
        bind()
    }
    
    private func configureUI() {
        title = navTitle
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.height.equalTo(72)
            $0.leading.trailing.bottom.equalTo(safeArea)
        }
        
        bottomView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeArea)
            $0.bottom.equalTo(bottomView.snp.top)
        }
    }
    
    private func configureWebView() {
        guard let url = URL(string: url) else { return }
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.load(URLRequest(url: url))
    }
    
    private func bind() {
        confirmButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: rx.disposeBag)
    }
}
